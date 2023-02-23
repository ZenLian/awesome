local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local utils = require("utils")

local M = {}

M.new = function(args)
  args = args or {}
  -- local iconic = setmetatable({}, { __index = M })
  local icon = wibox.widget {
    widget = wibox.widget.textbox,
    font = utils.icon_font(),
    markup = utils.markup.fg(args.icon, args.icon_fg or args.fg),
  }

  local desc = wibox.widget {
    widget = wibox.widget.textbox,
    fg = args.text_fg or args.fg,
    markup = utils.markup.fg(args.desc, args.desc_fg or args.fg),
  }

  local iconic = wibox.widget {
    icon,
    desc,
    layout = wibox.layout.fixed.horizontal,
    spacing = dpi(1),
  }

  iconic.icon = icon
  iconic.desc = desc
  return iconic
end

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
