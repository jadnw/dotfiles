local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")
local wibox = require("wibox")

local factory = require("factory")
local lib = require("lib")
local dpi = require("lib.utils").dpi

return function()
	local title = wibox.widget({
		text = "NOTIFICATIONS CENTER",
		font = beautiful.font_family .. " Bold 12",
		align = "center",
		widget = wibox.widget.textbox,
	})

	local message = wibox.widget({
		text = "You have no notifications",
		font = beautiful.font,
		align = "center",
		widget = wibox.widget.textbox,
	})

	local list = wibox.widget({
		spacing = dpi(12),
		layout = wibox.layout.fixed.vertical,
	})

	local CURRENT_DISPLAYED_ITEMS = 8
	local start_index = 1

	-- Make list scrollable
	list:buttons(gears.table.join(
		awful.button({}, 4, nil, function()
			if #_G.notifications <= CURRENT_DISPLAYED_ITEMS or start_index == 1 then
				return
			end
			start_index = start_index <= 1 and 1 or (start_index - 1)
			naughty.emit_signal("notifications::updated", _G.notifications, start_index)
		end),
		awful.button({}, 5, nil, function()
			if
				#_G.notifications <= CURRENT_DISPLAYED_ITEMS
				or start_index == #_G.notifications - CURRENT_DISPLAYED_ITEMS + 1
			then
				return
			end
			start_index = (start_index >= #_G.notifications - CURRENT_DISPLAYED_ITEMS + 1)
					and (#_G.notifications - CURRENT_DISPLAYED_ITEMS + 1)
				or (start_index + 1)
			naughty.emit_signal("notifications::updated", _G.notifications, start_index)
		end)
	))

	local clear = factory.create_button({
		child = {
			text = "Clear History",
			font = beautiful.font_family .. " Bold 11",
			widget = wibox.widget.textbox,
		},
		bg = beautiful.palette.transparent,
		fg = beautiful.palette.accent,
		border_width = dpi(1),
		border_color = beautiful.palette.accent,
		on_click = function()
			list:reset()
			_G.notifications = {}
			message:set_text("You have no notifications")
		end,
	})

	local update_notifications = function(notifications, start)
		start = start or 1
		list:reset()
		for i = start, CURRENT_DISPLAYED_ITEMS + start - 1, 1 do
			local n = notifications[i]
			if not n then
				return
			end
			local box = factory.create_notification_box(n, i, function(index)
				table.remove(_G.notifications, index)
				naughty.emit_signal("notifications::updated", _G.notifications, start)
			end)
			list:add(box)
		end
	end

	-- Update entire the list of notifications if signal "updated" is emitted
	update_notifications(_G.notifications) -- for the first time
	naughty.connect_signal("notifications::updated", function(notifications, start)
		update_notifications(notifications, start)
		if #notifications > 0 then
			message:set_text("You have " .. #notifications .. " notification" .. (#notifications == 1 and "" or "s"))
		else
			message:set_text("You have no notifications")
		end
	end)

	local notifications_center = factory.create_popup({
		child = {
			{
				{
					{
						title,
						bottom = dpi(6),
						top = dpi(6),
						widget = wibox.container.margin,
					},
					bg = beautiful.palette.bg2,
					shape = lib.ui.rrect(beautiful.border_radius),
					widget = wibox.container.background,
				},
				{
					{
						message,
						top = dpi(16),
						bottom = dpi(16),
						widget = wibox.container.margin,
					},
					fg = beautiful.palette.fg3,
					widget = wibox.container.background,
				},
				layout = wibox.layout.fixed.vertical,
			},
			list,
			clear,
			layout = wibox.layout.align.vertical,
		},
		placement = function(w)
			awful.placement.bottom_right(w, {
				margins = {
					top = beautiful.useless_gap + dpi(4),
					right = beautiful.useless_gap + dpi(2),
					bottom = beautiful.wibar_height + beautiful.useless_gap + dpi(2),
				},
			})
		end,
		width = dpi(480),
		height = awful.screen.focused().workarea.height - dpi(6),
	})

	awesome.connect_signal("notifications_center::toggle", notifications_center.toggle_visible) -- luacheck: no global
	-- Close Notifications Center after clearing the history
	clear:connect_signal("button::release", function()
		notifications_center.toggle_visible()
	end)

	return notifications_center
end
