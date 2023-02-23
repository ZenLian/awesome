local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local utils = require("utils")
local theme = require("theme")
local config = require("config")

local M = {}

local new = function(s)
  local dashboard = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(10),
    require("layout.right_panel.dashboard.settings")(),
    -- require("layout.right_panel.dashboard.monitor")(),
  }
  return dashboard
end

return setmetatable(M, {
  __call = function(_, ...)
    return new(...)
  end,
})
