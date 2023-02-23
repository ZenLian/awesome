local p = require("theme.palette")
local c = require("theme.sys.color")
local dpi = require("beautiful.xresources").apply_dpi
local comp = require("theme.comp")
local config = require("config")

M = {
  -- {{{ base colors
  bg_normal = p.base,
  fg_normal = p.text,
  bg_focus = p.surface0,
  fg_focus = p.blue,
  bg_urgent = p.red,
  fg_urgent = p.base,
  bg_minimize = p.base,
  fg_minimize = p.text,
  -- }}}
  -- {{{ gap/border/rounded
  border_color_maximized = p.base,
  border_color_normal = p.surface2 .. "80",
  border_color_active = p.blue,
  border_color_marked = p.mauve,
  -- }}}
  -- {{{ notifications
  notification_fg = p.text,
  notification_bg = p.base,
  notification_border_color = p.surface,
  -- }}}
  -- {{{ taglist
  taglist_bg_focus = p.blue,
  taglist_fg_focus = p.blue,
  taglist_bg_urgent = p.red,
  taglist_fg_urgent = p.base,
  taglist_bg_occupied = p.base,
  taglist_fg_occupied = p.text,
  taglist_bg_empty = p.base,
  taglist_fg_empty = p.overlay0,
  -- -- Generate taglist squares:
  -- local taglist_square_size = dpi(10)
  -- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
  -- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)
  taglist_disable_icon = true,
  -- }}}
  -- {{{ systray
  bg_systray = comp.wibar.systray.bg,
  systray_max_rows = 1,
  systray_icon_spacing = dpi(2),
  -- }}}
}

-- {{{ tasklist
-- theme.tasklist_bg_minimize = C.mantle
-- theme.tasklist_bg_normal = C.base
-- theme.tasklist_bg_focus = C.surface0
M.tasklist_fg_minimize = p.overlay0
M.tasklist_font = config.theme.font.family .. " 11"
-- M.tasklist_disable_task_name = true
-- M.tasklist_disable_icon = true
M.tasklist_plain_task_name = true
-- }}}

return M
