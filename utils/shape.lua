local M = {}

local gears = require("gears")
local beautiful = require("beautiful")

M.rrect = function(radius)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, radius or beautiful.border_radius)
  end
end

M.prrect = function(radius, tl, tr, br, bl)
  return function(cr, width, height)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end

return M
