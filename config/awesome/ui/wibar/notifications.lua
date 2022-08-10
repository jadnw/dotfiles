local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

local factory = require("factory")

return function()
	local notifications_icon = wibox.widget({
		{
			{
				id = "icon",
				text = beautiful.icon_notifications,
				font = beautiful.icon_font .. " Round 16",
				widget = wibox.widget.textbox,
			},
			id = "background",
			fg = beautiful.palette.fg3,
			widget = wibox.container.background,
		},
		widget = wibox.container.place,
	})

	local icon = notifications_icon:get_children_by_id("icon")[1]
	local background = notifications_icon:get_children_by_id("background")[1]

	require("ui.popups.notifications-center")()
	local notifications = factory.create_button({
		child = notifications_icon,
		tooltip = true,
		bg_hover = beautiful.palette.bg1,
		on_click = function()
			awesome.emit_signal("notifications_center::toggle") -- luacheck: no global
		end,
		on_right_click = function()
			_G.dnd_enabled = not _G.dnd_enabled
			naughty.suspended = _G.dnd_enabled
			icon:set_text(_G.dnd_enabled and beautiful.icon_notifications_dnd_none or beautiful.icon_notifications)
			background:set_fg(_G.dnd_enabled and beautiful.palette.bg4 or beautiful.palette.fg3)
		end,
	})

	notifications.set_tooltip("You have no notifications")

	naughty.connect_signal("property::active", function()
		local message = "You have no notifications"
		if #naughty.active > 0 then
			message = "You have " .. #naughty.active .. " notification" .. (#naughty.active == 1 and "" or "s")
		end
		notifications.set_tooltip(message)
	end)

	naughty.connect_signal("added", function()
		icon:set_text(_G.dnd_enabled and beautiful.icon_notifications_dnd or beautiful.icon_notifications_active)
		background:set_fg(_G.dnd_enabled and beautiful.palette.bg4 or beautiful.palette.orange)
	end)

	naughty.connect_signal("destroyed", function()
		if #naughty.active == 0 then
			icon:set_text(beautiful.icon_notifications)
			background:set_fg(beautiful.palette.fg3)
		end
	end)

	return notifications
end
