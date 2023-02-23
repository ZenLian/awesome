local awful = require("awful")
local wibox = require("wibox")
local utils = require("utils")
local theme = require("theme")
local service = require("service")
local config = require("config")

-- DEBUG

local M = {}

local fg = theme.palette.blue

M.new = function()
  -- local widget = wibox.widget.textbox(theme.icons.bluetooth_off)
  local widget = wibox.widget {
    widget = wibox.widget.textbox,
    font = utils.icon_font(),
    markup = theme.icons.bluetooth_off,
  }
  awesome.connect_signal("service::bluetooth", function(result)
    local icon = result.status ~= "off" and theme.icons.bluetooth or theme.icons.bluetooth_off
    local text = string.format("%s", icon)
    widget.markup = utils.markup.fg(text, fg)
  end)

  -- tooltip
  awful.tooltip {
    ontop = true,
    objects = { widget },
    timeout = 5,
    timer_function = function()
      local content = {}
      local result = service.bluetooth.get()

      table.insert(content, string.format("Status: %s", result.status))
      for addr, dev in pairs(result.devices) do
        table.insert(content, ("%s(%s)"):format(addr, dev.Name))
      end

      return table.concat(content, "\n")
    end,
  }

  widget:buttons {
    awful.button({}, 1, function()
      service.bluetooth.toggle()
    end),
    awful.button({}, 2, function()
      awful.spawn.with_shell(config.apps.terminal .. " -e bluetoothctl")
    end),
  }

  return widget
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
