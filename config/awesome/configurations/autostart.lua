local awful = require("awful")
local gears = require("gears")
local gfs = gears.filesystem

local lib = require("lib")
local lock_screen = require("modules.lockscreen")

local config_dir = gfs.get_configuration_dir()

local function autostart()
  -- Compositor
  lib.run.check_if_running("picom --experimental-backends", nil, function()
    awful.spawn("picom --experimental-backends --config " .. config_dir .. "externals/picom/picom.conf", false)
  end)
  -- Set keyboard repeat delay & repeat rate
  lib.run.run_once_grep("xset r rate 300 50")
  -- Init lockscreen
  lock_screen.init()
  -- Idle Management
  lib.run.run_once_pgrep(config_dir .. "scripts/idle set")
  --- Polkit Agent
	lib.run.run_once_ps(
		"polkit-gnome-authentication-agent-1",
		"/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
	)
  -- Network Manager Applet
  lib.run.run_once_grep("nm-applet")
  -- Music Daemon
  lib.run.run_once_pgrep("mpd")
  lib.run.run_once_pgrep("mpDris2")
  lib.run.run_once_pgrep("mpc add /")
end

autostart()
