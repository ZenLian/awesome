local M = {}

--- Checks if a table is empty.
---
---@param t table Table to check
---@return boolean `true` if `t` is empty
M.isempty = function(t)
  assert(type(t) == "table", string.format("Expected table, got %s", type(t)))
  return next(t) == nil
end

--- Checks if a table is array-like.
---
--- Empty table `{}` is assumed to be an array
---
---@param t table Table to check
---@return boolean `true` if `t` is array-like
M.islist = function(t)
  if type(t) ~= "table" then
    return false
  end

  local count = 0

  for k, _ in pairs(t) do
    if type(k) == "number" then
      count = count + 1
    else
      return false
    end
  end

  return count > 0
end

--- We only merge empty tables or tables that are not a list
---@private
local function can_merge(v)
  return type(v) == "table" and (M.isempty(v) or not M.islist(v))
end

--- Merges recursively two or more map-like tables.
---
--- Use value from the rightmost map if a key is found in more than one map.
---
---@param ... table Two or more map-like tables
---@return table Merged table
M.extend = function(...)
  local nargs = select("#", ...)
  if nargs < 2 then
    error(("wrong number of arguments (given '%d', expected at least 2)"):format(nargs))
  end

  local ret = {}
  for i = 1, nargs do
    local tbl = select(i, ...)
    if tbl == nil then
      tbl = {}
    end
    if type(tbl) ~= "table" then
      error(("wrong type of argument #%d (given '%s', expected 'table')"):format(i, type(tbl)))
    end
    for k, v in pairs(tbl) do
      if can_merge(v) and can_merge(ret[k]) then
        ret[k] = M.extend(ret[k], v)
      else
        ret[k] = v
      end
    end
  end
  return ret
end

return M
