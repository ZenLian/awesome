local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local utils = require("utils")
local theme = require("theme")
local config = require("config")
local naughty = require("naughty")

local M = {}

local new = function(s)
  local notiflist = require("layout.right_panel.notification.notiflist")
  local notifpane = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(10),
    notiflist,
  }
  return notifpane
end

return setmetatable(M, {
  __call = function(_, ...)
    return new(...)
  end,
})
