local beautiful = require("beautiful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local utils = require("utils")
local theme_path = os.getenv("HOME") .. "/.config/awesome/theme"
local p = require("theme.palette")
local comp = require("theme.comp")
local icons = require("theme.icons")

local function init()
  local O = require("config").theme
  local sys_themes_dir = require("gears.filesystem").get_themes_dir()

  local theme = {}

  -- {{{ fonts/icons and wallpapers
  theme.font = O.font.family .. " " .. O.font.size
  -- theme.wallpaper = theme_path .. "/wallpapers/LockScreen/arch-rainbow-1920x1080.png"
  theme.wallpaper = theme_path .. "/wallpapers/LockScreen/doggocat.png"
  theme.icon_theme = "Papirus"
  -- }}}
  --

  for k, v in pairs(comp.beautiful) do
    theme[k] = v
  end

  -- {{{ gap/border/rounded
  theme.useless_gap = dpi(5)
  theme.border_width = dpi(2)
  theme.border_width_maximized = 0
  -- custom
  theme.border_radius = dpi(10) -- not builtin
  -- }}}

  --------------------
  -- {{{ notifications
  --------------------
  -- Variables set for theming notifications:
  -- notification_font
  -- notification_[bg|fg]
  -- notification_[width|height|margin]
  -- notification_[border_color|border_width|shape|opacity]
  theme.notification_font = utils.font()
  theme.notification_border_width = 0
  theme.notification_shape = gears.shape.rounded_rect
  theme.notification_opacity = 0.9
  theme.notification_margin = dpi(10)
  theme.notification_width = dpi(420)
  -- theme.notification_height = dpi(200)
  theme.notification_spacing = dpi(10)
  -- }}}

  ---------------
  -- {{{ titlebar
  ---------------
  -- titlebar_[bg|fg]_[normal|focus]
  theme.titlebar_bg_normal = comp.titlebar.container.bg
  theme.titlebar_bg_focus = comp.titlebar.container.focus.bg
  theme.titlebars_enabled = true
  -- icons
  theme.titlebar_close_button_normal = sys_themes_dir .. "default/titlebar/close_normal.png"
  theme.titlebar_close_button_focus = sys_themes_dir .. "default/titlebar/close_focus.png"
  theme.titlebar_minimize_button_normal = sys_themes_dir .. "default/titlebar/minimize_normal.png"
  theme.titlebar_minimize_button_focus = sys_themes_dir .. "default/titlebar/minimize_focus.png"
  theme.titlebar_ontop_button_normal_inactive = sys_themes_dir .. "default/titlebar/ontop_normal_inactive.png"
  theme.titlebar_ontop_button_focus_inactive = sys_themes_dir .. "default/titlebar/ontop_focus_inactive.png"
  theme.titlebar_ontop_button_normal_active = sys_themes_dir .. "default/titlebar/ontop_normal_active.png"
  theme.titlebar_ontop_button_focus_active = sys_themes_dir .. "default/titlebar/ontop_focus_active.png"
  theme.titlebar_sticky_button_normal_inactive = sys_themes_dir .. "default/titlebar/sticky_normal_inactive.png"
  theme.titlebar_sticky_button_focus_inactive = sys_themes_dir .. "default/titlebar/sticky_focus_inactive.png"
  theme.titlebar_sticky_button_normal_active = sys_themes_dir .. "default/titlebar/sticky_normal_active.png"
  theme.titlebar_sticky_button_focus_active = sys_themes_dir .. "default/titlebar/sticky_focus_active.png"
  theme.titlebar_floating_button_normal_inactive = sys_themes_dir .. "default/titlebar/floating_normal_inactive.png"
  theme.titlebar_floating_button_focus_inactive = sys_themes_dir .. "default/titlebar/floating_focus_inactive.png"
  theme.titlebar_floating_button_normal_active = sys_themes_dir .. "default/titlebar/floating_normal_active.png"
  theme.titlebar_floating_button_focus_active = sys_themes_dir .. "default/titlebar/floating_focus_active.png"
  theme.titlebar_maximized_button_normal_inactive = sys_themes_dir .. "default/titlebar/maximized_normal_inactive.png"
  theme.titlebar_maximized_button_focus_inactive = sys_themes_dir .. "default/titlebar/maximized_focus_inactive.png"
  theme.titlebar_maximized_button_normal_active = sys_themes_dir .. "default/titlebar/maximized_normal_active.png"
  theme.titlebar_maximized_button_focus_active = sys_themes_dir .. "default/titlebar/maximized_focus_active.png"
  -- }}}

  -- {{{ layout icons
  ---------------------
  theme.layout_floating = gears.color.recolor_image(theme_path .. "/icons/layouts/floating.svg", theme.fg_normal)
  theme.layout_dwindle = gears.color.recolor_image(theme_path .. "/icons/layouts/dwindle.svg", theme.fg_normal)
  theme.layout_tile = gears.color.recolor_image(theme_path .. "/icons/layouts/tile.svg", theme.fg_normal)
  theme.layout_max = gears.color.recolor_image(theme_path .. "/icons/layouts/max.svg", theme.fg_normal)
  theme.layout_fullscreen = gears.color.recolor_image(theme_path .. "/icons/layouts/fullscreen.svg", theme.fg_normal)

  -- not in use
  theme.layout_fairh = sys_themes_dir .. "default/layouts/fairhw.png"
  theme.layout_fairv = sys_themes_dir .. "default/layouts/fairvw.png"
  theme.layout_spiral = sys_themes_dir .. "default/layouts/spiralw.png"
  theme.layout_magnifier = sys_themes_dir .. "default/layouts/magnifierw.png"
  theme.layout_tilebottom = sys_themes_dir .. "default/layouts/tilebottomw.png"
  theme.layout_tileleft = sys_themes_dir .. "default/layouts/tileleftw.png"
  theme.layout_tiletop = sys_themes_dir .. "default/layouts/tiletopw.png"
  theme.layout_cornernw = sys_themes_dir .. "default/layouts/cornernww.png"
  theme.layout_cornerne = sys_themes_dir .. "default/layouts/cornernew.png"
  theme.layout_cornersw = sys_themes_dir .. "default/layouts/cornersww.png"
  theme.layout_cornerse = sys_themes_dir .. "default/layouts/cornersew.png"
  --- }}}

  -- drop-down menu {{{
  -- menu_[bg|fg]_[normal|focus]
  -- menu_[border_color|border_width]
  theme.menu_bg = p.surface
  theme.menu_fg = theme.fg_normal
  theme.menu_font = O.font.family .. " 10"
  theme.menu_submenu_icon = icons.get_mdi("menu-right-outline", theme.fg_normal) --sys_themes_path .. "default/submenu.png"
  theme.menu_height = dpi(25)
  theme.menu_width = dpi(150)
  -- theme.menu_border_radius = 200
  theme.menu_border_width = 0
  theme.awesome_icon = theme_path .. "/icons/awesome.svg"
  -- theme_assets.awesome_icon(theme.menu_height, theme.bg_normal, theme.fg_focus)
  -- }}}

  ---------------------
  -- hotkyes popup {{{1
  ---------------------
  -- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
  theme.hotkeys_shape = utils.shape.rrect(theme.border_radius)
  theme.hotkeys_border_width = 0
  -- theme.hotkeys_border_color = C.blue
  theme.hotkeys_font = O.font.family .. " 11"
  theme.hotkeys_group_margin = 30
  -- theme.hotkeys_label_bg = p.rosewater
  -- theme.hotkeys_label_fg = p.base
  theme.hotkeys_description_font = O.font.family .. " 11"
  theme.hotkeys_description_fg = theme.fg_normal .. "ee"
  theme.hotkeys_modifiers_fg = theme.fg_normal .. "88"
  theme.hotkeys_bg = p.background

  ----------------
  -- Tooltips {{{
  ----------------
  theme.tooltip_bg = p.surface0
  theme.tooltip_fg = p.text
  theme.tooltip_opacity = 0.95
  theme.tooltip_border_width = 0
  theme.tooltip_align = "top"
  theme.tooltip_margin = "top"
  -- }}}

  -- There are other variable sets
  -- overriding the default one when
  -- defined, the sets are:
  -- mouse_finder_[color|timeout|animate_timeout|radius|factor]
  -- prompt_[fg|bg|fg_cursor|bg_cursor|font]

  -- init theme, or fallback to default
  if not beautiful.init(theme) then
    beautiful.init(sys_themes_dir .. "/default/theme.lua")
  end
end

return {
  init = init,
}
