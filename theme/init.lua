local PREFIX = ... .. "."

local M = {}

function M.init()
  -- init awesome's beautiful module
  require("theme.beautiful").init()
end

return setmetatable(M, {
  __index = function(_, key)
    local module = require(PREFIX .. key)
    -- rawset(self, key, module)
    return module
  end,
})
