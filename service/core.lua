local gears = { timer = require("gears.timer") }
local naughty = require("naughty")

local M = {
  status = {
    STOPPED = "stopped",
    STARTING = "starting",
    RUNNING = "running",
  },
}

local service_run = function(s)
  if s.status ~= M.status.STOPPED then
    return
  end
  s.status = M.status.STARTING

  if s.init then
    s.init()
  end

  if s.timeout > 0 then
    gears.timer {
      timeout = s.timeout,
      autostart = true,
      call_now = true,
      callback = function()
        s.update("timeout")
      end,
    }
  else
    s.update("init")
  end

  s.status = M.status.RUNNING
end

M.register = function(s, name, timeout)
  s.name = "service::" .. name
  s.timeout = timeout or s.timeout or 0
  s.status = M.status.STOPPED
  s.run = function()
    service_run(s)
  end

  -- update
  if s.get_async then
    s.update = function(src)
      s.get_async(function(result)
        awesome.emit_signal(s.name, result, src)
      end)
    end
  elseif s.get then
    s.update = function(src)
      awesome.emit_signal(s.name, s.get(), src)
    end
  else
    naughty.notify {
      preset = naughty.config.presets.warn,
      title = s.name,
      text = "missing get_async() or get()",
    }
  end

  -- return setmetatable(serv, { __index = service })
  return s
end

return M
