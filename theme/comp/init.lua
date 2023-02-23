local PREFIX = ... .. "."
return setmetatable({}, {
  __index = function(self, key)
    local module = require(PREFIX .. key)
    rawset(self, key, module)
    return module
  end,
})
