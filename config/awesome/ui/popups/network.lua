local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local factory = require("factory")
local lib = require("lib")
local dpi = require("lib.utils").dpi

return function(s)
	local network_interface = wibox.widget({
		text = "Oops. Unrecognized Connection",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	})

	local network_ip = wibox.widget({
		text = "Oops. Unrecognized IP Address",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	})

	local network_toggler = wibox.widget({
		checked = false,
		color = beautiful.palette.accent,
		paddings = dpi(2),
		shape = lib.ui.rrect(beautiful.border_radius),
		check_shape = lib.ui.rrect(beautiful.border_radius),
		check_color = beautiful.palette.accent,
		forced_width = dpi(16),
		forced_height = dpi(16),
		widget = wibox.widget.checkbox,
	})

  lib.ui.add_hover_cursor(network_toggler)

	network_toggler:buttons(gears.table.join(awful.button({}, 1, function()
		network_toggler.checked = not network_toggler.checked
	end)))

	-- Enable/Disable network connection when the checked value changes
	network_toggler:connect_signal("property::checked", function()
		local checked = network_toggler:get_checked()
		if checked then
			awful.spawn("nmcli n on", false)
		else
			awful.spawn("nmcli n off", false)
		end
	end)

	local network_popup = factory.create_popup({
		screen = s,
		child = {
			{
				network_interface,
				nil,
				network_toggler,
				layout = wibox.layout.align.horizontal,
			},
			network_ip,
			spacing = dpi(8),
			layout = wibox.layout.fixed.vertical,
		},
		placement = function(w)
			awful.placement.bottom_right(w, {
				margins = {
					right = beautiful.useless_gap + dpi(2),
					bottom = beautiful.wibar_height + beautiful.useless_gap + dpi(2),
				},
			})
		end,
		width = dpi(320),
		height = dpi(80),
	})

	-- Set interface
	network_popup.set_interface = function(interface)
		network_interface:set_text(interface)
	end
	-- Set IP address
	network_popup.set_ip = function(ipa)
		network_ip:set_text("IP Addr: " .. ipa)
	end
	-- Set checked
	network_popup.set_toggler_value = function(value)
		network_toggler:set_checked(value)
	end

	--Signals
	awesome.connect_signal("network_popup::toggle", function()
		network_popup.toggle_visible()
	end)
	awesome.connect_signal("network_popup::interface", function(interface)
		network_popup.set_interface(interface)
	end)
	awesome.connect_signal("network_popup::ip", function(ip)
		network_popup.set_ip(ip)
	end)
	awesome.connect_signal("network_popup::checked", function(checked)
		network_popup.set_toggler_value(checked)
	end)

	return network_popup
end
