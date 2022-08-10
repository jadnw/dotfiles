local awful = require("awful")
local beautiful = require("beautiful")

local lib = require("lib")
local factory = require("factory")
local apps = require("configurations.apps")

local disk = factory.create_circular_progress({
	tooltip = "Disk Usage",
	icon = beautiful.icon_disk,
	min_value = 0,
	max_value = 100,
	ring_color = beautiful.palette.yellow,
	on_click = function()
		lib.run.run_once_grep(apps.default.system_monitor)
	end,
})

awful.widget.watch(
	[[fish -c "df -h /home | grep '^/' | awk '{print $5}'"]],
	_G.configs.system_monitor.disk_sampling_time,
	function(_, stdout)
		local space_consumed = tonumber(stdout:match("(%d+)"))
		disk:set_value(space_consumed)
		disk.set_tooltip("You used <b>" .. space_consumed .. "%</b> on your cheap SSD")
		collectgarbage("collect")
	end
)

return disk
