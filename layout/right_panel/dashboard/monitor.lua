local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")
local theme = require("theme")
local icons = require("theme.icons")
local widget = require("widget")
local service = require("service")
local naughty = require("naughty")

local cpu = widget.ringbar {
  image = theme.icons("cpu"),
}
awesome.connect_signal("service::cpu", function(result)
  cpu.value = result.usage
end)

local memory = widget.ringbar {
  image = theme.icons("memory"),
}
awesome.connect_signal("service::memory", function(result)
  memory.value = result.perc
end)

local thermal = widget.ringbar {
  image = theme.icons("thermometer"),
}
awesome.connect_signal("service::thermal", function(result)
  thermal.value = result.thermal
end)

local disk = widget.ringbar {
  image = theme.icons("harddisk"),
}
awesome.connect_signal("service::disk", function(result)
  -- naughty.notification {
  --   text = result.perc,
  -- }
  disk.value = tonumber(result.perc)
end)

return wibox.widget {
  widget = wibox.container.background,
  bg = theme.palette.base,
  shape = utils.shape.rrect(5),
  {
    widget = wibox.container.margin,
    margins = dpi(12),
    {
      layout = wibox.layout.fixed.horizontal,
      spacing = dpi(12),
      cpu,
      memory,
      thermal,
      disk,
    },
  },
}
