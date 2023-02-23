local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")
local color = require("theme.sys.color")

local M = {}

local defaults = {
  icon = "",
  text = "",
  fg_on = color.on_primary,
  bg_on = color.primary,
  fg_off = color.on_surface,
  bg_off = color.surface,
}

function M.new(args)
  args = utils.table.extend(defaults, args)

  local wicon = wibox.widget {
    widget = wibox.widget.textbox,
    halign = "center",
    valign = "bottom",
    font = utils.icon_font(18),
    text = args.icon,
  }
  --
  local wtext = wibox.widget {
    widget = wibox.widget.textbox,
    halign = "center",
    valign = "top",
    font = utils.font(12),
    text = args.text,
  }

  local wrapper = wibox.widget {
    wicon,
    wtext,
    layout = wibox.layout.ratio.vertical,
    spacing = dpi(5),
  }
  wrapper:set_ratio(1, 0.5)
  --
  local widget = wibox.widget {
    {
      wrapper,
      margins = dpi(4),
      widget = wibox.container.margin,
    },
    widget = wibox.container.background,
    bg = args.bg_off,
    shape = utils.shape.rrect(),
    forced_width = dpi(100),
    forced_height = dpi(100),
    -- width = dpi(200),
    -- height = dpi(200),
  }

  rawset(widget, "enabled", false)
  -- without user action
  function widget:set_enabled(value)
    if value == rawget(widget, "enabled") then
      return
    end
    rawset(widget, "enabled", value)
    -- change color
    -- utils.debug("set_enabled: " .. tostring(value))
    if value then
      self.bg = args.bg_on
      self.fg = args.fg_on
    else
      self.bg = args.bg_off
      self.fg = args.fg_off
    end
  end

  function widget:toggle(value)
    if value == nil then
      value = not self.enabled
    end

    local old_value = self.enabled
    self:set_enabled(value)
    if old_value ~= value then
      -- user callback
      if args.on_toggle then
        args.on_toggle(value)
      end
    end
  end

  widget:buttons {
    awful.button({}, 1, function()
      widget:toggle()
      -- widget.bg = beautiful.palette.blue
      -- widget.enabled = not widget.enabled
    end),
  }

  return widget
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
