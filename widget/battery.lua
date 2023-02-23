local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local service = require("service")
local utils = require("utils")
local theme = require("theme")

local M = {}

local battery_buttons = {
  awful.button({}, 1, function()
    awful.spawn("xfce4-power-manager-settings")
  end),
}

M.new = function()
  local fg_normal = theme.comp.wibar.battery.fg
  local fg_low = beautiful.fg_urgent
  local bat = wibox.widget {
    widget = wibox.widget.textbox,
    font = utils.icon_font(),
    markup = "N/A",
  }

  bat:buttons(battery_buttons)

  -- tooltip
  local bat_tip = awful.tooltip {
    ontop = true,
    objects = { bat },
    timer_function = function()
      local content = {}
      local result = service.battery.get()

      table.insert(content, string.format("State: %s%%(%s)", result.percentage, result.state))
      table.insert(content, string.format("Health: %s%%", result.health))

      if result.time ~= "N/A" then
        table.insert(content, string.format("Time left: %s", result.time))
      end
      if result.rate ~= "N/A" then
        table.insert(content, string.format("Energy rate: %.2f mW", result.rate))
      end

      return table.concat(content, "\n")
    end,
  }

  awesome.connect_signal("service::battery", function(result)
    -- local text = string.format(
    --   "[BAT] %s%%(%s %s) health(%s%%) rate(%s mW)",
    --   result.percentage,
    --   result.state,
    --   result.time,
    --   result.health,
    --   result.rate
    -- )
    local charging = false
    if result.state == "fully-charged" or result.state == "charging" then
      charging = true
    end
    local percentage = 100
    if result.percentage ~= "N/A" then
      percentage = result.percentage
    end
    local icon = theme.icons.get_battery(percentage, charging)
    local fg = fg_normal
    if percentage < 15 then
      fg = fg_low
    end
    bat.markup = utils.markup.fg(icon, fg)
  end)

  return bat
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
