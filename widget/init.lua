local PREFIX = ... .. "."
return setmetatable({}, {
  __index = function(self, key)
    local widget = require(PREFIX .. key)
    rawset(self, key, widget)
    return widget
  end,
})
