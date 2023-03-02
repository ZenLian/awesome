local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local icons = require("theme.icons")
local utils = require("utils")
local theme = require("theme")
local config = require("config")

local M = {}

local line_separator = wibox.widget {
  orientation = "horizontal",
  forced_height = dpi(1),
  span_ratio = 1.0,
  color = beautiful.groups_title_bg,
  widget = wibox.widget.separator,
}

local vertical_separator = wibox.widget {
  widget = wibox.widget.separator,
  orientation = "vertical",
  forced_width = dpi(1),
  span_ratio = 1,
  color = theme.palette.crust,
}

M.new = function(s)
  local panel_width = dpi(config.layout.right_panel.width)
  local panel = wibox {
    screen = s,
    type = "utility",
    visible = false,
    ontop = true,
    width = s.geometry.width,
    height = s.geometry.height,
    x = s.geometry.x,
    y = s.geometry.y,
    bg = "#00000000",
    -- fg = beautiful.fg_normal,
  }
  s.top_panel = panel

  local backdrop = wibox.widget {
    widget = wibox.container.background,
    bg = theme.palette.base .. "33",
  }
  backdrop:buttons {
    awful.button({}, 1, function()
      panel:close()
    end),
  }

  panel:buttons {
    awful.button({}, 2, function()
      panel:close()
    end),
    awful.button({}, 3, function()
      panel:close()
    end),
  }

  local dashboard = require("layout.right_panel.dashboard")
  panel:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    backdrop,
    {
      widget = wibox.container.background,
      bg = theme.palette.mantle,
      forced_width = panel_width,
      forced_height = s.geometry.height,
      {
        layout = wibox.layout.align.horizontal,
        nil,
        {
          widget = wibox.container.margin,
          margins = dpi(10),
          {
            layout = wibox.layout.fixed.vertical,
            require("layout.right_panel.headline"),
            spacing = dpi(10),
            {
              layout = wibox.layout.stack,
              {
                id = "dashboard_pane",
                visible = true,
                layout = wibox.layout.fixed.vertical,
                dashboard,
              },
              {
                id = "notification_pane",
                visible = false,
                layout = wibox.layout.fixed.vertical,
                require("layout.right_panel.notification")(),
              },
            },
          },
        },
        {
          layout = wibox.layout.fixed.horizontal,
          vertical_separator,
          require("layout.right_panel.navigation")(s),
        },
      },
    },
  }

  function panel:switch(name)
    local all = { "dashboard", "notification" }
    for _, target in pairs(all) do
      local p = panel:get_children_by_id(target .. "_pane")[1]
      if name == target then
        p.visible = true
      else
        p.visible = false
      end
    end
    awesome.emit_signal("layout::right_panel::switch", name)
  end
  panel:switch("dashboard")

  function panel:open()
    panel.visible = true
  end
  function panel:close()
    panel.visible = false
  end
  function panel:toggle()
    panel.visible = not panel.visible
  end

  return panel
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
