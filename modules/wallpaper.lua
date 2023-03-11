local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local config = require("config")

local M = {}

local wallpaper_dir = os.getenv("HOME") .. "/.config/awesome/theme/wallpapers"

M.new = function(s)
  local engine = setmetatable({}, { __index = M })
  engine.screen = s
  engine.timer = gears.timer.new {
    timeout = config.theme.random_wallpaper.auto_timeout * 60,
    autostart = true,
    callback = function()
      engine:change_wallpaper()
    end,
  }

  return engine
end

M.change_wallpaper = function(self)
  local wallpaper = gears.filesystem.get_random_file_from_dir(wallpaper_dir, { ".jpg", ".png" }, true)
  awful.wallpaper {
    screen = self.screen,
    widget = {
      image = wallpaper,
      widget = wibox.widget.imagebox,
      upscale = true,
      downscale = true,
      horizontal_fit_policy = "fit",
      vertical_fit_policy = "fit",
    },
  }
  self.timer:again()
end

screen.connect_signal("request::wallpaper", function(s)
  if not s.wallpaper_engine then
    s.wallpaper_engine = M.new(s)
  end
  s.wallpaper_engine:change_wallpaper()
end)

return setmetatable(M, {
  __call = function(_, ...)
    return M.new(...)
  end,
})
