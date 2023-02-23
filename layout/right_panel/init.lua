local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
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
  backdrop:buttons { awful.button({}, 1, function()
    panel:close()
  end) }

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
            layout = wibox.layout.stack,
            {
              id = "dashboard_pane",
              visible = true,
              layout = wibox.layout.fixed.vertical,
              require("layout.right_panel.dashboard")(),
            },
            {
              id = "notification_pane",
              visible = false,
              layout = wibox.layout.fixed.vertical,
              wibox.widget.textbox("notif"),
            },
          },
        },
        require("layout.right_panel.navigation")(s),
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
  end

  function panel:open()
    panel.visible = true
  end
  function panel:close()
    panel.visible = false
  end
  function panel:toggle()
    panel.visible = not panel.visible
  end

  -- DEBUG
  awful.keyboard.append_global_keybindings {
    awful.key({ "Mod4", "Mod1" }, "n", function()
      s.right_panel:toggle()
    end),
  }

  return panel
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
