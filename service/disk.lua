-- "service::disk"
local awful = require("awful")
local service = require("service.core")
local utils = require("utils")

local M = {}

local df_cmd = "df -h /home | tail -1"

local parse = function(stdout)
  local result = {}
  -- local i = 1
  -- for v in string.gmatch(stdout, "[%s]+([^%s]+)") do
  --   if i == 1 then
  --     result.dev = v
  --   elseif i == 2 then
  --     result.size = v
  --   elseif i == 3 then
  --     result.used = v
  --   elseif i == 4 then
  --     result.avail = v
  --   elseif i == 5 then
  --     result.perc = tonumber(string.match(v, "([%d]+)%%"))
  --   end
  --   i = i + 1
  -- end
  result.perc = string.match(stdout, "([%d]+)%%")
  -- require("naughty").notification {
  --   text = stdout,
  -- }
  return result
end

M.get_async = function(callback)
  awful.spawn.easy_async_with_shell(df_cmd, function(stdout)
    local result = parse(stdout)
    callback(result)
  end)
end

return service.register(M, "disk", 1)
