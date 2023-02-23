local awful = require("awful")
local naughty = require("naughty")

-- run a command once, do nothing if another instance is running
local run_once = function(command)
  local name = command
  local pos = command:find(" ")
  if pos then
    name = command:sub(0, pos - 1)
  end

  -- awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", name, command))
  awful.spawn.easy_async_with_shell(
    string.format("pgrep -u $USER -x %s > /dev/null || (%s)", name, command),
    function(_, stderr)
      if not stderr or stderr == "" then
        return
      end
      naughty.notification {
        app_name = "Start-up Applications",
        title = string.format("<b>Oops! Error detected when starting '%s'!</b>", name),
        message = stderr:gsub("%\n", ""),
        timeout = 20,
        icon = require("beautiful").awesome_icon,
      }
    end
  )
end

local commands = {
  "picom --experimental-backend --config $HOME/.config/awesome/extra/picom.conf",
  "fcitx5 -d",
  "xss-lock -- $HOME/.config/awesome/extra/lock.sh",
}

for _, command in pairs(commands) do
  run_once(command)
end
