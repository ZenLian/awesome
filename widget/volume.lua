local awful = require("awful")
local utils = require("utils")
local theme = require("theme")
local service = require("service")
local widget = require("widget")
local O = require("config")

local factory = function()
  local fg = theme.palette.teal
  local vol = widget.iconic {
    icon = theme.icons.get_volume(),
    desc = "N/A",
    fg = theme.comp.wibar.volume.fg,
  }

  awesome.connect_signal("service::volume", function(result)
    local icon = theme.icons.get_volume(result.muted)
    local desc = string.format("%3d%%", result.volume)
    vol.icon.markup = utils.markup.fg(icon, fg)
    vol.desc.markup = utils.markup.fg(desc, fg)
    -- local naughty = require("naughty")
    -- naughty.notify {
    --   title = "service::volume",
    --   text = markup,
    -- }
  end)

  vol:buttons {
    awful.button({}, 1, function() -- left click
      service.volume.set("toggle")
    end),
    awful.button({}, 2, function() -- middle click
      service.volume.set(100)
    end),
    awful.button({}, 3, function() -- right click
      -- TODO:
      awful.spawn(O.apps.terminal .. " -e alsamixer")
    end),
    awful.button({}, 4, function() -- scroll up
      service.volume.set("1%+")
    end),
    awful.button({}, 5, function() -- scroll down
      service.volume.set("1%-")
    end),
  }

  return vol
end

return factory
