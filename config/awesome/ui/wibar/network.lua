local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local factory = require("factory")
local apps = require("configurations.apps")
local dpi = require("lib.utils").dpi
local utils = require("lib.utils")

return function(s)
  require("ui.popups.network")(s)

  local network_label = wibox.widget({
    {
      id = "icon",
      text = beautiful.icon_network,
      font = beautiful.icon_font .. " Round 16",
      widget = wibox.widget.textbox,
    },
    {
      id = "text",
      text = "Ethernet",
      font = beautiful.font .. " Semibold 11",
      widget = wibox.widget.textbox,
    },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal,
  })

  local network = factory.create_button({
    child = network_label,
    tooltip = true,
    padding_right = dpi(10),
    bg = beautiful.palette.blue,
    on_click = function()
      awesome.emit_signal("network_popup::toggle") -- luacheck: no global
    end,
    on_right_click = function()
      awful.spawn(apps.default.network_manager, false)
    end,
  })

  local icon = network_label:get_children_by_id("icon")[1]
  local text = network_label:get_children_by_id("text")[1]

  awful.widget.watch([[fish -c "nmcli n"]], _G.configs.network.sampling_time, function(_, stdout)
    stdout = utils.trim(stdout)

    if stdout == "enabled" then
      icon:set_text(beautiful.icon_network)
      awesome.emit_signal("network_popup::checked", true) -- luacheck: no global
      awful.spawn.easy_async_with_shell([[fish -c "nmcli c | head -n 2 | tail -n 1"]], function(o)
        local arr = utils.split(o, " ")
        local interface = arr[#arr]
        local interface_type = arr[#arr - 1]
        local label = utils.trim(interface_type:gsub("^%l", string.upper) .. ": " .. interface .. " (" .. stdout .. ")")
        text:set_text(interface)
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
      awesome.emit_signal("network_popup::checked", false) -- luacheck: no global
      awesome.emit_signal("network_popup::interface", "Internet Disabled") -- luacheck: no global
      awesome.emit_signal("network_popup::ip", "No address") -- luacheck: no global
      network.set_tooltip("You forgot pay the Internet bill, huh?") -- luacheck: no global
    end
  end)

  return network
end
