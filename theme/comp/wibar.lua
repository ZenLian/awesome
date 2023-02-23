local p = require("theme.palette")
local dpi = require("beautiful.xresources").apply_dpi

local M = {
  height = dpi(28),
  bg = p.base,
  systray = {
    bg = p.surface1,
  },
  systat = {
    bg = p.rosewater,
  },
  volume = {
    fg = p.rosewater,
  },
  battery = {
    fg = p.green,
  },
  wifi = {
    fg = p.lavender,
  },
  bluetooth = {
    fg = p.blue,
  },
  cpu = {
    fg = p.mauve,
  },
  memory = {
    fg = p.sky,
  },
  thermal = {
    fg = p.maroon,
  },
}

return M
