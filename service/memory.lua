-- "service::memory"
-- * total
-- * free
-- * used
-- * perc
-- * swap
--   * total
--   * free
local service = require("service.core")

local M = {}

M.get = function()
  local mem = { buf = {}, swap = {} }
  for line in io.lines("/proc/meminfo") do
    for k, v in string.gmatch(line, "([%a]+):[%s]+([%d]+).+") do
      if k == "MemTotal" then
        mem.total = math.floor(v / 1024)
      elseif k == "MemFree" then
        mem.buf.free = math.floor(v / 1024)
      elseif k == "MemAvailable" then
        mem.buf.available = math.floor(v / 1024)
      elseif k == "Buffers" then
        mem.buf.buffers = math.floor(v / 1024)
      elseif k == "Cached" then
        mem.buf.cached = math.floor(v / 1024)
      elseif k == "SwapTotal" then
        mem.swap.total = math.floor(v / 1024)
      elseif k == "SwapFree" then
        mem.swap.free = math.floor(v / 1024)
      end
    end
  end
  -- memory percentage
  mem.free = mem.buf.available
  mem.used = mem.total - mem.free
  mem.perc = math.floor(mem.used / mem.total * 100)
  -- swap percentage
  mem.swap.used = mem.swap.total - mem.swap.free
  mem.swap.perc = math.floor(mem.swap.used / mem.swap.total * 100)

  return mem
end

return service.register(M, "memory", 9)
