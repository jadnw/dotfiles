local awful = require("awful")
local beautiful = require("beautiful")

local lib = require("lib")
local dpi = require("lib.utils").dpi
local factory = require("factory")
local apps = require("configurations.apps")

local cpu = factory.create_circular_progress({
	tooltip = true,
  radius = dpi(13),
	icon = beautiful.icon_cpu,
	min_value = 0,
	max_value = 100,
	ring_color = beautiful.palette.teal,
	on_click = function()
		lib.run.run_once_grep(apps.default.system_monitor)
	end,
})

local total_prev = 0
local idle_prev = 0

awful.widget.watch(
	[[fish -c "
  cat /proc/stat | grep '^cpu '
  "]],
	_G.configs.system_monitor.cpu_sampling_time,
	function(_, stdout)
		local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice = -- luacheck: no unused
			stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")

		local total = user + nice + system + idle + iowait + irq + softirq + steal
		local diff_idle = idle - idle_prev
		local diff_total = total - total_prev
		local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10

		cpu:set_value(diff_usage)
		cpu.set_tooltip("Your potato CPU is loading <b>" .. math.ceil(diff_usage) .. "%</b>")
		total_prev = total
		idle_prev = idle
		collectgarbage("collect")
	end
)

return cpu
