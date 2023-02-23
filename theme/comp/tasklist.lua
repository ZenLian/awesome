local p = require("theme.palette")
local dpi = require("beautiful.xresources").apply_dpi

local M = {
  bg = p.base,
  fg = p.text,
  focus = {
    bg = p.surface0,
    fg = p.blue,
  },
  minimized = {
    fg = p.overlay0,
  },
}

return M
