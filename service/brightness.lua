-- brightness signal
-- "service::brightness"
-- percentage, src(string)
local awful = require("awful")
-- local gtimer = require("gears.timer")
local service = require("service.core")

local M = {
  status = service.status.STOPPED,
}

local brightness_cmd = "brightnessctl info"

local parse = function(stdout)
  local percentage = string.match(stdout, "%(([%d]+)%%%)")
  return { percentage = tonumber(percentage) }
end

M.get_async = function(callback)
  awful.spawn.easy_async_with_shell(brightness_cmd, function(stdout)
    local result = parse(stdout)
    callback(result)
  end)
end

M.set = function(val, src)
  if type(val) == "number" then
    awful.spawn.easy_async("brightnessctl set " .. val .. "% -q", function()
      M.update(src)
    end)
  else
    awful.spawn.easy_async("brightnessctl set " .. val .. " -q", function()
      M.update(src)
    end)
  end
end

return service.register(M, "brightness")
