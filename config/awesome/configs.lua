local beautiful = require("beautiful")

-- Notifications
_G.nightlight_enabled = false
_G.dnd_enable = false
_G.notifications = {}

-- User defined configs
_G.configs = {
	system_monitor = {
		cpu_sampling_time = 30,
		memory_sampling_time = 30,
		temp_sampling_time = 30,
		disk_sampling_time = 1800,
	},
	network = {
		sampling_time = 15,
	},
	volume = {
		sampling_time = 15,
	},
	-- for notification icons and colors
	notifications = {
		apps = {
			["screenshot tool"] = { icon = "", color = beautiful.palette.yellow },
			["screencast tool"] = { icon = "", color = beautiful.palette.magenta },
			["color picker"] = { icon = "", color = beautiful.palette.cyan },
		},
	},
}
