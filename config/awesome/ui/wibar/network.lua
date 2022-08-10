local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local factory = require("factory")
local apps = require("configurations.apps")
local utils = require("lib.utils")

return function(s)
	require("ui.popups.network")(s)

	local network_icon = wibox.widget({
		{
			{
				id = "icon",
				text = beautiful.icon_network,
				font = beautiful.icon_font .. " Round 15",
				widget = wibox.widget.textbox,
			},
			id = "background",
			fg = beautiful.palette.fg3,
			widget = wibox.container.background,
		},
		widget = wibox.container.place,
	})

	local network = factory.create_button({
		child = network_icon,
		tooltip = true,
		bg_hover = beautiful.palette.bg1,
		on_click = function()
			awesome.emit_signal("network_popup::toggle") -- luacheck: no global
		end,
		on_right_click = function()
			awful.spawn(apps.default.network_manager, false)
		end,
	})

	awful.widget.watch([[fish -c "nmcli n"]], _G.configs.network.sampling_time, function(_, stdout)
		stdout = utils.trim(stdout)
		local icon = network_icon:get_children_by_id("icon")[1]
		local background = network_icon:get_children_by_id("background")[1]

		if stdout == "enabled" then
			icon:set_text(beautiful.icon_network)
			background:set_fg(beautiful.palette.fg3)
			awesome.emit_signal("network_popup::checked", true) -- luacheck: no global
			awful.spawn.easy_async_with_shell([[fish -c "nmcli c | head -n 2 | tail -n 1"]], function(o)
				local arr = utils.split(o, " ")
				local interface = arr[#arr]
				local interface_type = arr[#arr - 1]
				local label =
					utils.trim(interface_type:gsub("^%l", string.upper) .. ": " .. interface .. " (" .. stdout .. ")")
				network.set_tooltip(label)
				awesome.emit_signal("network_popup::interface", label) -- luacheck: no global
				awful.spawn.easy_async_with_shell(
					[[fish -c "nmcli -p device show | grep '^IP4.ADDRESS' | head -n 1"]],
					function(oip)
						local contains_ip = utils.split(oip, " ")
						local ip = utils.split(contains_ip[#contains_ip], "/")[1]
						awesome.emit_signal("network_popup::ip", ip) -- luacheck: no global
					end
				)
			end)
		else
			icon:set_text(beautiful.icon_network_disable)
			background:set_fg(beautiful.palette.red)
			awesome.emit_signal("network_popup::checked", false) -- luacheck: no global
			awesome.emit_signal("network_popup::interface", "Internet Disabled") -- luacheck: no global
			awesome.emit_signal("network_popup::ip", "No address") -- luacheck: no global
			network.set_tooltip("Pay the Internet bill, please!") -- luacheck: no global
		end
	end)

	return network
end
