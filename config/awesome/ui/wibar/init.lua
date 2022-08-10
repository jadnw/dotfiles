local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local dpi = require("lib.utils").dpi

--- MODULES
----------------------------------------------------------------------------------------------------
local create_bar = function(s)
	-- Wibar
	s.wibar = awful.wibar({
		position = "bottom",
		screen = s,
		type = "dock",
		width = s.geometry.width,
		height = beautiful.wibar_height,
		border_width = beautiful.wibar_border_width,
		border_color = beautiful.wibar_border_color,
		shape = gears.shape.rectangle,
		bg = beautiful.wibar_bg,
		fg = beautiful.wibar_fg,
	})

	-- Create modules
	local clock = require("ui.wibar.clock")(s)
	local taglist = require("ui.wibar.taglist")(s)
	local layoutbox = require("ui.wibar.layoutbox")(s)
	local system_monitor = require("ui.wibar.system-monitor")()
	local volume = require("ui.wibar.volume")(s)
	local network = require("ui.wibar.network")(s)
	local notifications = require("ui.wibar.notifications")()
	local nightlight = require("ui.wibar.nightlight")()
	local systray = require("ui.wibar.systray")()

	-- Containers
	local left_modules = wibox.widget({
		{
			system_monitor,
			volume,
			spacing = dpi(30),
			layout = wibox.layout.fixed.horizontal,
		},
		left = dpi(6),
		widget = wibox.container.margin,
	})
	local middle_modules = wibox.widget({
		taglist,
		widget = wibox.container.place,
	})
	local right_modules = wibox.widget({
		systray,
		notifications,
		network,
		nightlight,
		clock,
		layoutbox,
		spacing = dpi(2),
		layout = wibox.layout.fixed.horizontal,
	})

	-- Wibar Setup
	s.wibar:setup({
		{
			{
				left_modules,
				middle_modules,
				right_modules,
				expand = "none",
				layout = wibox.layout.align.horizontal,
			},
			margins = dpi(4),
			widget = wibox.container.margin,
		},
		fill_horizontal = true,
		widget = wibox.container.background,
	})
end

awful.screen.connect_for_each_screen(function(s)
	create_bar(s)
end)
