local wibox = require("wibox")

local dpi = require("lib.utils").dpi
local cpu = require("ui.wibar.system-monitor.cpu")
local memory = require("ui.wibar.system-monitor.memory")
local disk = require("ui.wibar.system-monitor.disk")
local temp = require("ui.wibar.system-monitor.temp")

return function()
	local system_monitor_widget = wibox.widget({
		cpu,
		memory,
		disk,
		temp,
		spacing = dpi(8),
		layout = wibox.layout.fixed.horizontal,
	})

	return system_monitor_widget
end
