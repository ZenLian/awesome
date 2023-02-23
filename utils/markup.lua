local M = {}

M.fg = function(text, fg)
  return "<span foreground='" .. fg .. "'>" .. text .. "</span>"
end

-- M.font =

return M
