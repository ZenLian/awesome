local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local utils = require("utils")
local theme = require("theme")
local config = require("config")

local monitor = require("layout.right_panel.dashboard.monitor")
local settings = require("layout.right_panel.dashboard.settings")
local dashboard = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = dpi(10),
  settings,
  monitor,
}
return dashboard
