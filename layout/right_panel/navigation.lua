local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local utils = require("utils")
local theme = require("theme")
local widget = require("widget")
local config = require("config")

local M = {}

local function create_button(icon, action)
  local btn = wibox.widget {
    widget = wibox.widget.imagebox,
    image = icons(icon),
  }
  btn:buttons {
    awful.button({}, 1, action),
  }
  return widget.container.clickable(btn)
end

M.new = function(s)
  local close_button = create_button("close", function()
    s.right_panel:toggle()
  end)
  local dashboard_button = create_button("dashboard", function()
    s.right_panel:switch("dashboard")
  end)
  local notification_button = create_button("message", function()
    s.right_panel:switch("notification")
  end)

  return wibox.widget {
    widget = wibox.container.background,
    bg = theme.palette.mantle,
    forced_width = dpi(32),
    forced_height = s.geometry.height,
    {
      widget = wibox.container.margin,
      margins = dpi(5),
      {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(8),
        close_button,
        dashboard_button,
        notification_button,
      },
    },
  }
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
