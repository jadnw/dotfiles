local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local apps = require("configurations.apps")
local lib = require("lib")
local factory = require("factory")

return function()
	local nightlight_icon = wibox.widget({
		{
			{
				id = "icon",
				text = beautiful.icon_nightlight_disabled,
				font = beautiful.icon_font .. " Round 16",
				widget = wibox.widget.textbox,
			},
			id = "background",
			fg = beautiful.palette.fg3,
			widget = wibox.container.background,
		},
		widget = wibox.container.place,
	})

	local icon = nightlight_icon:get_children_by_id("icon")[1]
	local background = nightlight_icon:get_children_by_id("background")[1]

	local nightlight = factory.create_button({
		child = nightlight_icon,
		tooltip = true,
		bg_hover = beautiful.palette.bg1,
		on_click = function()
			awesome.emit_signal("nightlight::toggle")
		end,
	})

	nightlight.set_tooltip("Nightlight: Disabled")

	local toggle_nightlight = function()
		awful.spawn.easy_async_with_shell(apps.utils.nightlight, function(stdout)
			stdout = lib.utils.trim(stdout)

			if stdout == "false" then
				icon:set_text(beautiful.icon_nightlight_disabled)
				background:set_fg(beautiful.palette.fg3)
				nightlight.set_tooltip("Nightlight: Disabled")
			else
				icon:set_text(beautiful.icon_nightlight)
				background:set_fg(beautiful.palette.yellow)
				nightlight.set_tooltip("Nightlight: Enabled")
			end
		end)
	end

	awesome.connect_signal("nightlight::toggle", toggle_nightlight)

	return nightlight
end
