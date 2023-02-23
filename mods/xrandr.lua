--> https://awesomewm.org/recipes/xrandr/
--- Separating Multiple Monitor functions as a separeted module (taken from awesome wiki)

local gtable = require("gears.table")
local awful = require("awful")
local naughty = require("naughty")

-- A path to a fancy icon
local icon_path = ""

-- Get active outputs
local function outputs()
  local out = {}
  local xrandr = io.popen("xrandr -q --current")

  if xrandr then
    for line in xrandr:lines() do
      local output = line:match("^([%w-]+) connected ")
      if output then
        out[#out + 1] = output
      end
    end
    xrandr:close()
  end

  return out
end

local function arrange(out)
  -- We need to enumerate all permutations of horizontal outputs.

  local choices = {}
  local previous = { {} }
  for i = 1, #out do
    -- Find all permutation of length `i`: we take the permutation
    -- of length `i-1` and for each of them, we create new
    -- permutations by adding each output at the end of it if it is
    -- not already present.
    local new = {}
    for _, p in pairs(previous) do
      for _, o in pairs(out) do
        if not gtable.hasitem(p, o) then
          new[#new + 1] = gtable.join(p, { o })
        end
      end
    end
    choices = gtable.join(choices, new)
    previous = new
  end

  return choices
end

-- Build available choices
local function menu()
  local menu = {}
  local out = outputs()
  local choices = arrange(out)

  for _, choice in pairs(choices) do
    local cmd = "xrandr"
    -- Enabled outputs
    for i, o in pairs(choice) do
      cmd = cmd .. " --output " .. o .. " --auto"
      if i > 1 then
        cmd = cmd .. " --right-of " .. choice[i - 1]
      end
    end
    -- Disabled outputs
    for _, o in pairs(out) do
      if not gtable.hasitem(choice, o) then
        cmd = cmd .. " --output " .. o .. " --off"
      end
    end

    local label = ""
    if #choice == 1 then
      label = 'Only <span weight="bold">' .. choice[1] .. "</span>"
    else
      for i, o in pairs(choice) do
        if i > 1 then
          label = label .. " + "
        end
        label = label .. '<span weight="bold">' .. o .. "</span>"
      end
    end

    menu[#menu + 1] = { label, cmd }
  end

  return menu
end

-- Display xrandr notifications from choices
local state = { notif = nil }

local function naughty_destroy_callback(notif, reason, visible)
  local reasons = naughty.notification_closed_reason
  -- reason == naughty.notificationClosedReason.expired or reason == naughty.notificationClosedReason.dismissedByUser
  if reason == reasons.expired or reason == reasons.dismissed_by_user then
    local action = state.index and state.menu[state.index - 1][2]
    if action then
      awful.spawn(action, false)
      state.index = nil
    end
  end
  state.notif = nil
end

local function xrandr()
  -- Build the list of choices
  if not state.index then
    state.menu = menu()
    state.index = 1
  end

  -- Select one and display the appropriate notification
  local label, action
  local next = state.menu[state.index]
  state.index = state.index + 1

  if not next then
    label = "Keep the current configuration"
    state.index = nil
  else
    label, action = next[1], next[2]
  end
  if not state.notif then
    state.notif = naughty.notification {
      text = label,
      icon = icon_path,
      position = "top_middle",
      timeout = 3,
      screen = awful.screen.focused(),
    }
    state.notif:connect_signal("destroyed", naughty_destroy_callback)
  else
    state.notif.text = label
  end
end

return {
  outputs = outputs,
  arrange = arrange,
  menu = menu,
  xrandr = xrandr,
}
