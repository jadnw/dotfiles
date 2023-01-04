local awful = require("awful")
local beautiful = require("beautiful")

local apps = require("configurations.apps")
local factory = require("factory")
local lib = require("lib")
local utils = lib.utils

return function()
  local network = factory.create_qs_button({
    icon = beautiful.icon_network_disabled,
    on_click = function()
      awesome.emit_signal("network::toggle")
    end,
    on_right_click = function() end,
  })

  awful.widget.watch(apps.utils.network .. " state", _G.configs.network.sampling_time, function(_, stdout)
    stdout = utils.trim(stdout)

    if stdout == "on" then
      network.set_icon(beautiful.icon_network)
      network:set_bg(beautiful.palette.accent)
      awful.spawn.easy_async_with_shell([[nmcli c | head -n 2 | tail -n 1]], function(o)
        local arr = utils.split(o, " ")
        local interface = arr[#arr]
        local interface_type = arr[#arr - 1]
        local label = utils.trim(interface_type:gsub("^%l", string.upper) .. ": " .. interface .. " (" .. stdout .. ")")
        network.set_tooltip(label)
      end)
    else
      network.set_icon(beautiful.icon_network_disabled)
      network:set_bg(beautiful.palette.black)
      network.set_tooltip("No network") -- luacheck: no global
    end
  end)

  local network_toggle = function()
    awful.spawn.easy_async_with_shell(apps.utils.network .. " toggle", function(stdout)
      if stdout == "on" then
        network.set_icon(beautiful.icon_network)
        network:set_bg(beautiful.palette.accent)
        network.set_tooltip("Network loading ...") -- luacheck: no global
      else
        network.set_icon(beautiful.icon_network_disabled)
        network:set_bg(beautiful.palette.black)
        network.set_tooltip("No network") -- luacheck: no global
      end
      awesome.emit_signal("network::change", stdout == "on" and true or false)
    end)
  end

  awesome.connect_signal("network::toggle", network_toggle)

  return network
end
