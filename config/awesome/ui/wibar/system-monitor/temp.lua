local awful = require("awful")
local beautiful = require("beautiful")

local lib = require("lib")
local dpi = require("lib.utils").dpi
local factory = require("factory")
local apps = require("configurations.apps")

local temp = factory.create_circular_progress({
	tooltip = "temp Usage",
  radius = dpi(13),
	icon = beautiful.icon_temp,
	min_value = 0,
	max_value = 100,
	ring_color = beautiful.palette.red,
	on_click = function()
		lib.run.run_once_grep(apps.default.system_monitor)
	end,
})

awful.widget.watch(
	[[fish -c "sensors | grep "^edge" | awk '{ print $2 }'"]],
	_G.configs.system_monitor.temp_sampling_time,
	function(_, stdout)
		local cpu_temp = tonumber(stdout:match("(%d+)"))
		temp:set_value(cpu_temp)
		temp.set_tooltip("Your CPU is boiling at " .. cpu_temp .. "C. Time to get some eggs.")
		collectgarbage("collect")
	end
)

return temp
