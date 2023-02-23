local PREFIX = ... .. "."
local submodule = function(name)
  return require(PREFIX .. name)
end
submodule("rules")
