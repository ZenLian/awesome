local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local config = require("config")
local modkey = require("config").keys.modkey
local theme = require("theme")

local total_height = config.layout.top_panel.height
local indicator_height = 2

local taglist_buttons = {
  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewprev(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewnext(t.screen)
  end),
}

local taglist = function(s)
  return awful.widget.taglist {
    screen = s,
    filter = awful.widget.taglist.filter.all,
    widget_template = {
      {
        {
          {
            id = "text_role",
            widget = wibox.widget.textbox,
            align = "center",
          },
          id = "mainbox",
          widget = wibox.container.background,
          bg = beautiful.bg_normal,
          forced_width = dpi(total_height - indicator_height - 4),
          forced_height = dpi(total_height - indicator_height),
        },
        layout = wibox.layout.fixed.vertical,
      },
      id = "background_role",
      widget = wibox.container.background,
      -- Add support for hover colors and an index label
      ---@diagnostic disable-next-line: unused-local
      create_callback = function(self, c, index, objects) --luacheck: no unused args
        local mainbox = self:get_children_by_id("mainbox")[1]
        self:connect_signal("mouse::enter", function()
          mainbox.bg = theme.palette.surface0
        end)
        self:connect_signal("mouse::leave", function()
          mainbox.bg = theme.palette.base
        end)
      end,
      -- update_callback = function(self, c3, index, objects) --luacheck: no unused args
      -- 	self:get_children_by_id("index_role")[1].markup = "<b> " .. c3.index .. " </b>"
      -- end,
    },
    buttons = taglist_buttons,
  }
end

return taglist
