local dpi = require("beautiful.xresources").apply_dpi
local p = require("theme.palette")

local M = {
  container = {
    height = dpi(32),
    bg = p.base,
    focus = {
      bg = p.base,
    },
  },
  button = {
    width = dpi(14),
    height = dpi(14),
    margin = dpi(14),
    bg = p.surface1,
  },
  minimize_button = {
    bg = p.yellow,
  },
  maximize_button = {
    bg = p.green,
  },
  close_button = {
    bg = p.red,
  },
}

return M
