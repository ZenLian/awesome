local awful = require("awful")

local tags = { "1", "2", "3", "4", "5", "6", "7", "8", "9" }

-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts {
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.spiral.name,
    awful.layout.suit.tile.right,
    awful.layout.suit.floating,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.max,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.fair,
  }
end)

screen.connect_signal("request::desktop_decoration", function(s)
  screen[s].padding = { left = 0, right = 0, top = 0, bottom = 0 }
  awful.tag(tags, s, awful.layout.layouts[1])
end)
