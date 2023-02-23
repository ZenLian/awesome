local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local comp = require("theme.comp")
local utils = require("utils")
local PREFIX = ...

local M = {
  _setup = false,
  -- show in which screen
  screen = nil,
}

-- add to screen
M.create = function(s)
  local mycc = wibox {
    type = "dock",
    shape = utils.shape.rrect(),
    screen = s,
    width = dpi(400),
    height = dpi(400),
    bg = comp.controlhub.container.bg,
    -- margins = dpi(20),
    ontop = true,
    visible = false,
    -- opacity = 0.95,
  }
  s.mycc = mycc

  mycc.x = s.geometry.x + s.geometry.width - mycc.width - beautiful.useless_gap
  mycc.y = s.geometry.y + comp.wibar.height + beautiful.useless_gap

  -- widgets
  local powers = require(PREFIX .. ".powers")
  local sliders = require(PREFIX .. ".sliders")
  local switchers = require(PREFIX .. ".switchers")

  mycc:setup {
    {
      powers,
      sliders,
      switchers,
      layout = wibox.layout.fixed.vertical,
      spacing = comp.controlhub.spacing,
    },
    widget = wibox.container.margin,
    margins = comp.controlhub.spacing,
  }

  mycc:buttons {
    awful.button({}, 3, function()
      M.hide()
    end),
  }

  return mycc
end

function M.hide()
  if M.screen then
    M.screen.mycc.visible = false
  end
  M.screen = nil
end

function M.show(s)
  s = s or screen.primary

  if M.screen ~= s then
    M.hide()
  end
  s.mycc.visible = true
  M.screen = s
end

function M.toggle(s)
  if M.screen == nil or M.screen ~= s then
    M.show(s)
  else
    M.hide()
  end
end

function M.setup()
  if M._setup then
    return
  end

  -- add to screen
  awful.screen.connect_for_each_screen(function(s)
    M.create(s)
  end)

  screen.connect_signal("request::remove", function(s)
    if M.screen == s then
      M.hide()
    end
  end)

  M._setup = true
end

return M
