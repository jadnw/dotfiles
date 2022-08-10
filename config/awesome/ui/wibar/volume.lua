local awful = require("awful")
local beautiful = require("beautiful")

local lib = require("lib")
local dpi = require("lib.utils").dpi
local factory = require("factory")
local apps = require("configurations.apps")

return function(s)
	require("ui.popups.volume")(s)
	local volume = factory.create_circular_progress({
		tooltip = true,
    radius = dpi(13),
		icon = beautiful.icon_volume,
		min_value = 0,
		max_value = 100,
		ring_color = beautiful.palette.teal,
		on_click = function()
			awesome.emit_signal("volume_popup::toggle") -- luacheck: no global
		end,
		on_right_click = function()
			awful.spawn(apps.default.volume_control, false)
		end,
	})

	awful.widget.watch([[fish -c "pamixer --get-volume"]], _G.configs.volume.sampling_time, function(_, stdout)
		local volume_percentage = tonumber(stdout)
		if volume_percentage ~= nil then
			awful.spawn.easy_async_with_shell([[fish -c "pamixer --get-default-sink | tail -n 1"]], function(o)
				local device_name = lib.utils.split(o, '"')[4]
				awesome.emit_signal("volume_popup::device", device_name) -- luacheck: no global
			end)
			volume:set_value(volume_percentage)
			volume.set_tooltip("I'm singing at " .. math.ceil(volume_percentage or 0) .. "%")
			awesome.emit_signal("volume_popup::value", volume_percentage) -- luacheck: no global
		end

		collectgarbage("collect")
	end)

	return volume
end
