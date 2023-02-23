-- "service::thermal"
-- * thermal(float)
--   Temperature with celsius units
local service = require("service.core")
local utils = require("utils")

local M = {}

local THERMAL_FILE = "/sys/class/thermal/thermal_zone0/temp"

M.get = function()
  local thermal = utils.io.first_line(THERMAL_FILE)
  return { thermal = tonumber(thermal) / 1000 }
end

return service.register(M, "thermal", 11)
