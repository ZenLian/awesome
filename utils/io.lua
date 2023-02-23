local M = {}

-- get a table with all lines from a file
M.all_lines = function(path)
  local lines = {}
  for line in io.lines(path) do
    lines[#lines + 1] = line
  end
  return lines
end

-- get lines range
M.get_lines = function(path, from, to)
  local lines = {}
  from = from or 1

  local i = 1
  for line in io.lines(path) do
    if to and i > to then
      break
    end
    if i >= from then
      lines[#lines + 1] = line
    end
    i = i + 1
  end

  return lines
end

-- read first line from a file
M.first_line = function(path)
  local line
  local f = io.open(path, "rb")
  if f then
    line = f:read("*l")
    f:close()
  end
  return line
end

return M
