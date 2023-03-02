local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
local theme = require("theme")
local icons = require("theme.icons")
local utils = require("utils")
local config = require("config")
local naughty = require("naughty")
local modkey = require("config").keys.modkey

local M = {}

local function build_power_widget(name, icon, callback)
  local normal_bg = "00000000"
  local hover_bg = theme.palette.surface2 .. "33"
  local background = wibox.widget {
    {
      {
        image = icon,
        widget = wibox.widget.imagebox,
      },
      margins = dpi(16),
      widget = wibox.container.margin,
    },
    widget = wibox.container.background,
    bg = normal_bg,
    shape = gears.shape.rounded_rect,
    forced_width = dpi(90),
    forced_height = dpi(90),
  }

  local item = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    spacing = dpi(5),
    {
      background,
      left = dpi(24),
      right = dpi(24),
      widget = wibox.container.margin,
    },
    {
      widget = wibox.widget.textbox,
      text = name,
      -- font = utils.font(10),
      align = "center",
      valign = "center",
    },
  }

  item:connect_signal("button::release", function()
    callback()
  end)

  item:connect_signal("mouse::enter", function()
    background.bg = hover_bg
  end)
  item:connect_signal("mouse::leave", function()
    background.bg = normal_bg
  end)
  return item
end

local items = {
  {
    name = "Poweroff",
    icon = icons("power"),
    key = "p",
    command = function()
      awful.spawn.with_shell("systemctl poweroff")
      awesome.emit_signal("layout::exit_screen::hide")
    end,
  },
  {
    name = "Reboot",
    icon = icons("restart"),
    key = "r",
    command = function()
      naughty.notification {
        text = "reboot!",
      }
      awful.spawn.with_shell("systemctl reboot")
      awesome.emit_signal("layout::exit_screen::hide")
    end,
  },
  {
    name = "Sleep",
    icon = icons("power-sleep"),
    key = "s",
    command = function()
      awesome.emit_signal("layout::exit_screen::hide")
      awful.spawn.with_shell("systemctl suspend")
    end,
  },
  {
    name = "Logout",
    icon = icons("logout"),
    key = "o",
    command = function()
      awesome.quit()
    end,
  },
  {
    name = "Lock",
    icon = icons("lock"),
    key = "l",
    command = function()
      awesome.emit_signal("layout::exit_screen::hide")
      awful.spawn.with_shell("$HOME/.config/awesome/extra/lock.sh")
    end,
  },
}

local power_widgets = {}
for _, item in pairs(items) do
  local widget = build_power_widget(item.name, item.icon, item.command)
  table.insert(power_widgets, widget)
end

local exit_screen_keygrabber = awful.keygrabber {
  -- stop_key = modkey,
  auto_start = true,
  stop_event = "release",
  keypressed_callback = function(self, mod, key, command)
    for _, item in pairs(items) do
      if key == item.key then
        item.command()
        return
      end
    end
    -- hide on any other keys
    awesome.emit_signal("layout::exit_screen::hide")
  end,
}

M.new = function(s)
  local exit_screen = wibox {
    screen = s,
    type = "splash",
    visible = false,
    ontop = true,
    bg = theme.palette.base .. "33",
    fg = beautiful.fg_normal,
    height = s.geometry.height,
    width = s.geometry.width,
    x = s.geometry.x,
    y = s.geometry.y,
  }

  exit_screen:buttons {
    -- awful.button({}, 1, function()
    --   awesome.emit_signal("layout::exit_screen::hide")
    -- end),
    awful.button({}, 2, function()
      awesome.emit_signal("layout::exit_screen::hide")
    end),
    awful.button({}, 3, function()
      awesome.emit_signal("layout::exit_screen::hide")
    end),
  }

  exit_screen:setup {
    layout = wibox.layout.align.vertical,
    expand = "none",
    nil,
    {
      layout = wibox.layout.align.horizontal,
      -- spacing = dpi(30),
      expand = "none",
      nil,
      {
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(30),
        table.unpack(power_widgets),
      },
      nil,
    },
    nil,
  }
  return exit_screen
end

local exit_on_screen = nil

function M.hide()
  exit_screen_keygrabber:stop()
  if exit_on_screen then
    exit_on_screen.exit_screen.visible = false
  end
  exit_on_screen = nil
end

function M.show()
  -- local s = screen.primary
  local s = awful.screen.focused()
  if exit_on_screen == s then
    return
  elseif exit_on_screen ~= s and exit_on_screen ~= nil then
    exit_on_screen.exit_screen.visible = false
  end
  exit_on_screen = s
  exit_on_screen.exit_screen.visible = true
  exit_screen_keygrabber:start()
end

function M.toggle()
  if exit_on_screen then
    M.hide()
  else
    M.show()
  end
end

awesome.connect_signal("layout::exit_screen::show", function()
  M.show()
end)

awesome.connect_signal("layout::exit_screen::hide", function()
  M.hide()
end)

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
