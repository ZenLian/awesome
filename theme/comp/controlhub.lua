local p = require("theme.palette")
local dpi = require("beautiful.xresources").apply_dpi

local M = {
  container = {
    bg = p.mantle,
    spacing = dpi(10),
  },
  subcontainer = {
    bg = p.base,
  },
}

return M
