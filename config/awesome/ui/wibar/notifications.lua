local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")

local dpi = require("lib.utils").dpi
local factory = require("factory")

return function()
  local notifications_label = wibox.widget({
    {
      id = "icon",
      text = beautiful.icon_notifications,
      font = beautiful.icon_font .. " Round 16",
      widget = wibox.widget.textbox,
    },
    {
      id = "text",
      text = "0 notifications",
      font = beautiful.font .. " Semibold 11",
      widget = wibox.widget.textbox,
    },
    spacing = dpi(6),
    layout = wibox.layout.fixed.horizontal,
  })

  local icon = notifications_label:get_children_by_id("icon")[1]
  local text = notifications_label:get_children_by_id("text")[1]

  require("ui.notification_center")()
  local notifications = factory.create_button({
    child = notifications_label,
    tooltip = true,
    padding_right = dpi(10),
    bg = beautiful.palette.yellow,
    on_click = function()
      awesome.emit_signal("notification_center::toggle") -- luacheck: no global
    end,
    on_right_click = function()
      _G.dnd_enabled = not _G.dnd_enabled
      naughty.suspended = _G.dnd_enabled
      icon:set_text(_G.dnd_enabled and beautiful.icon_notifications_dnd_none or beautiful.icon_notifications)
      text:set_text(_G.dnd_enabled and "DND Enabled" or "0 notifications")
    end,
  })

  notifications.set_tooltip("You have 0 notifications")

  naughty.connect_signal("property::active", function()
    local message = "You have 0 notifications"
    local label = "0 notifications"
    if #naughty.active > 0 then
      label = #naughty.active .. " notification" .. (#naughty.active == 1 and "" or "s")
      message = "You have " .. label
    end
    notifications.set_tooltip(message)
    text:set_text(label)
  end)

  naughty.connect_signal("added", function()
    icon:set_text(_G.dnd_enabled and beautiful.icon_notifications_dnd or beautiful.icon_notifications_active)
  end)

  naughty.connect_signal("destroyed", function()
    if #naughty.active == 0 then
      icon:set_text(beautiful.icon_notifications)
    end
  end)

  return notifications
end
