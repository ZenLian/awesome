local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")
local theme = require("theme")
local widget = require("widget")
local service = require("service")

local volume = widget.slider {
  min = 0,
  max = 100,
  init = function(self)
    service.volume.get_async(function(result)
      local icon = theme.icons.get_volume(result.muted)
      self.icon = icon
      self.value = result.volume
    end)
  end,
  on_value_change = function(val)
    service.volume.set(val, "cc_slider")
  end,
  on_icon_press = function(_)
    service.volume.set("toggle")
  end,
}

awesome.connect_signal("service::volume", function(result, src)
  local icon = theme.icons.get_volume(result.muted)
  volume.icon = icon
  -- ignore self-emit signal
  if src ~= "cc_slider" then
    volume.value = result.volume
  end
end)

local brightness = widget.slider {
  min = 0,
  max = 100,
  init = function(self)
    self.icon = theme.icons.brightness
    service.brightness.get_async(function(result)
      self.value = result.percentage
    end)
  end,
  on_value_change = function(val)
    service.brightness.set(val, "cc_slider")
  end,
}

awesome.connect_signal("service::brightness", function(result, src)
  -- local icon = theme.icons.get_volume(result.percentage)
  -- volume.icon = icon
  -- ignore self-emit signal
  if src ~= "cc_slider" then
    brightness.value = result.percentage
  end
end)

local new = function()
  return wibox.widget {
    widget = wibox.container.background,
    bg = theme.palette.base,
    shape = utils.shape.rrect(5),
    {
      widget = wibox.container.margin,
      margins = dpi(12),
      {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(12),
        volume,
        brightness,
      },
    },
  }
end

return new
