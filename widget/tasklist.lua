local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local comp = require("theme.comp")
local icons = require("theme.icons")
local utils = require("utils")

local tasklist_buttons = {
  awful.button({}, 1, function(c)
    c:activate { context = "tasklist", action = "toggle_minimization" }
  end),
  awful.button({}, 2, function(c)
    c:kill()
  end),
  awful.button({}, 3, function()
    awful.menu.client_list { theme = { width = 250 } }
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(-1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(1)
  end),
}

local tasklist_update = function(self, c)
  local textbox = self:get_children_by_id("clientclass")[1]
  local fg = comp.tasklist.fg
  if client.focus == c then
    fg = comp.tasklist.focus.fg
  elseif c.minimized then
    fg = comp.tasklist.minimized.fg
  end
  textbox.markup = utils.markup.fg(c.class, fg)
end

local tasklist = function(s)
  return awful.widget.tasklist {
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    layout = {
      spacing = dpi(3),
      layout = wibox.layout.fixed.horizontal,
    },
    widget_template = {
      {
        {
          id = "clientclass",
          widget = wibox.widget.textbox,
        },
        -- {
        --   id = "clienticon",
        --   widget = awful.widget.clienticon,
        -- },
        -- margins = { left = dpi(8), right = dpi(8), top = dpi(3), bottom = dpi(3) },
        margins = dpi(4),
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
      -- forced_width = dpi(32),
      -- create_callback = function(self, c)
      --   self:get_children_by_id("clienticon")[1].client = c
      -- end,
      create_callback = tasklist_update,
      update_callback = tasklist_update,
    },
    buttons = tasklist_buttons,
  }
end

return tasklist
