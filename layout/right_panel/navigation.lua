local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local utils = require("utils")
local theme = require("theme")
local widget = require("widget")
local config = require("config")

local function create_button(name, icon, action)
  local wdg = wibox.widget {
    widget = wibox.container.background,
    id = name .. "_button",
    forced_height = dpi(32),
    fg = theme.palette.text,
    {
      layout = wibox.layout.align.horizontal,
      {
        id = "indicator",
        widget = wibox.widget.separator,
        orientation = "vertical",
        thickness = dpi(2),
        forced_width = dpi(2),
        span_ratio = 1,
        color = theme.palette.mantle,
      },
      {
        widget = wibox.widget.textbox,
        font = utils.icon_font(17),
        align = "center",
        valign = "center",
        text = icons[icon],
      },
      nil,
    },
  }
  wdg:buttons {
    awful.button({}, 1, action),
  }

  wdg:connect_signal("mouse::enter", function()
    wdg.bg = theme.palette.surface0
  end)
  wdg:connect_signal("mouse::leave", function()
    wdg.bg = nil
  end)

  function wdg:activate()
    wdg:get_children_by_id("indicator")[1].color = theme.palette.blue
    wdg.fg = theme.palette.blue
  end
  function wdg:deactivate()
    wdg:get_children_by_id("indicator")[1].color = theme.palette.mantle
    wdg.fg = theme.palette.text
  end

  return wdg
end

local panels = {
  {
    name = "dashboard",
    icon = "view_dashboard",
  },
  {
    name = "notification",
    icon = "message",
  },
}

local new = function(s)
  local close_button = create_button("close", "close", function()
    s.right_panel:toggle()
  end)
  close_button.fg = theme.palette.lavender

  local items = {}
  local items_map = {}
  for _, panel in ipairs(panels) do
    local item = create_button(panel.name, panel.icon, function()
      s.right_panel:switch(panel.name)
    end)
    table.insert(items, item)
    items_map[panel.name] = item
  end
  -- local dashboard_button = create_button("dashboard", function()
  --   s.right_panel:switch("dashboard")
  -- end)
  -- local notification_button = create_button("message", function()
  --   s.right_panel:switch("notification")
  -- end)

  local nav = wibox.widget {
    widget = wibox.container.background,
    bg = theme.palette.mantle,
    forced_width = dpi(32),
    forced_height = s.geometry.height,
    {
      layout = wibox.layout.fixed.vertical,
      -- spacing = dpi(8),
      close_button,
      table.unpack(items),
    },
  }

  -- highlight current panel
  -- nav.current = items_map["dashboard"]
  -- nav.current:activate()
  awesome.connect_signal("layout::right_panel::switch", function(name)
    if nav.current then
      nav.current:deactivate()
    end
    nav.current = items_map[name]
    nav.current:activate()
  end)

  return nav
end

return new
