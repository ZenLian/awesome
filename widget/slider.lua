local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")
local theme = require("theme")

local M = {}

local defaults = {
  min = 0,
  max = 100,
  init = nil,
  on_value_change = nil,
  on_icon_press = nil,
}

M.new = function(args)
  args = utils.table.extend(defaults, args)

  local slider = wibox.widget {
    widget = wibox.widget.slider,
    bar_shape = gears.shape.rounded_bar,
    bar_height = dpi(5),
    bar_color = theme.palette.surface0,
    bar_margins = { bottom = dpi(18), top = dpi(18) },
    bar_active_color = theme.palette.blue,
    handle_color = theme.palette.blue,
    handle_shape = gears.shape.circle,
    handle_width = dpi(14),
    shape = gears.shape.rounded_bar,
    minimum = args.min or 0,
    maximum = args.max or 100,
    value = 0,
  }

  local slider_icon = wibox.widget {
    widget = wibox.widget.textbox,
    -- font = beautiful.icon_var .. "17",
    font = utils.icon_font(),
    align = "center",
    valign = "center",
  }

  local slider_text = wibox.widget {
    widget = wibox.widget.textbox,
    -- markup = utils.markup.fg(" 10%", beautiful.fg_normal),
    -- font = beautiful.font_var .. "13",
    align = "center",
    valign = "center",
  }

  local widget = wibox.widget {
    slider_icon,
    slider,
    slider_text,
    -- layout = wibox.layout.fixed.horizontal,
    layout = wibox.layout.align.horizontal,
    forced_height = dpi(42),
    spacing = dpi(17),
    -- expand = "none",
  }

  function widget:set_icon(markup)
    slider_icon.markup = markup .. " "
  end

  function slider_text:set_value(value)
    value = math.max(math.min(value, args.max), args.min)
    self.markup = string.format("%4s%%", value)
  end

  function widget:set_value(value, no_block_signal)
    -- slider_text.markup = string.format("%4s%%", value)
    slider_text.value = value
    self.block_signal = not no_block_signal
    slider.value = value
    self.block_signal = false
  end

  widget:buttons {
    awful.button({}, 4, function() -- scroll up
      widget:set_value(slider.value + 1, true)
      -- widget.value = slider.value + 1
    end),
    awful.button({}, 5, function() -- scroll down
      widget:set_value(slider.value - 1, true)
      -- widget.value = slider.value - 1
    end),
  }

  if args.icon then
    widget.icon = args.icon
  end

  if args.init then
    local ret = args.init(widget)
    if ret ~= nil then
      widget.value = ret
    end
  end

  slider:connect_signal("property::value", function(_, new_value)
    slider_text.value = new_value
    if not widget.block_signal and args.on_value_change then
      args.on_value_change(new_value)
    end
  end)

  if args.on_icon_press then
    slider_icon:buttons {
      awful.button({}, 1, function()
        args.on_icon_press(widget)
      end),
    }
  end

  return widget
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
