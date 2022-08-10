local awful = require("awful")
local beautiful = require("beautiful")

local lib = require("lib")
local dpi = require("lib.utils").dpi
local factory = require("factory")
local apps = require("configurations.apps")

local memory = factory.create_circular_progress({
	tooltip = "Memory Usage",
  radius = dpi(13),
	icon = beautiful.icon_memory,
	min_value = 0,
	max_value = 100,
	ring_color = beautiful.palette.green,
	on_click = function()
		lib.run.run_once_grep(apps.default.system_monitor)
	end,
})

awful.widget.watch([[fish -c "free | grep '^Mem'"]], _G.configs.system_monitor.memory_sampling_time, function(_, stdout)
	local total, used, free, shared, buff_cache, available = -- luacheck: no unused
		stdout:match("(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)%s*(%d+)")
	local percentage = used / total * 100
	local bytes_per_gigabytes = 1024 * 1024
	memory:set_value(percentage)
	memory.set_tooltip(
		"Hmm. It is <b>"
			.. math.ceil(percentage)
			.. "%</b>. You used "
			.. math.ceil(used / bytes_per_gigabytes)
			.. "GB of "
			.. math.ceil(total / bytes_per_gigabytes)
			.. "GB"
	)
	collectgarbage("collect")
end)

return memory
