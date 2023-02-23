local PREFIX = ... .. "."

local M = require(PREFIX .. "core")

M.run = function()
  local services = {
    --
    "volume",
    "brightness",
    "cpu",
    "memory",
    "thermal",
    "battery",
    -- "network",
    "nm",
    -- "bt",
    "bluetooth",
  }
  for _, name in ipairs(services) do
    require(PREFIX .. name).run()
  end
end

return setmetatable(M, {
  __index = function(self, key)
    local service = require(PREFIX .. key)
    rawset(self, key, service)
    return service
  end,
})
