local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

local factory = require("factory")
local lib = require("lib")
local dpi = require("lib.utils").dpi

naughty.persistence_enabled = true
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 10
naughty.config.defaults.title = "There is something that's matter to you"
naughty.config.defaults.position = "bottom_right"
naughty.config.presets.low.timeout = 5
naughty.config.presets.critical.timeout = 30

local get_oldest_notification = function()
  for _, notification in ipairs(naughty.active) do
    if notification and notification.timeout > 0 then
      return notification
    end
  end
  -- Fallback to the first one
  return naughty.active[1]
end

-- Handle notification icon
naughty.connect_signal("request::icon", function(n, context, hints)
  -- Handle other contexts here
  if context ~= "app_icon" then
    return
  end
  -- Use XDG icon
  local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())
  if path then
    n.icon = path
  end
end)

-- Handle notification action icon
naughty.connect_signal("request::action_icon", function(a, context, hints) -- luacheck: no unused args
  a.icon = menubar.utils.lookup_icon(hints.id)
end)

-- Save the notification to the list on Notifications Center
naughty.connect_signal("added", function(n)
  n.datetime = os.date("%b %d - %H:%M")
  table.insert(_G.notifications, 1, n)
  naughty.emit_signal("notifications::updated", _G.notifications)
end)

-- Display notification with custom widget
naughty.connect_signal("request::display", function(n)
  local notification = factory.create_notification(n)
  local widget = naughty.layout.box({
    widget_template = notification,
    notification = n,
    position = "bottom_right",
    border_width = dpi(1),
    border_color = beautiful.palette.accent,
    ontop = true,
    cursor = "hand",
    type = "notification",
    shape_bounding = lib.ui.rrect(beautiful.border_radius),
    bg = beautiful.notification_bg,
    fg = beautiful.palette.fg1,
    maximum_width = dpi(480),
    minimum_width = dpi(440),
    maximum_height = dpi(196),
    minimum_height = dpi(96),
  })

  widget.buttons = {}

  if #naughty.active > 5 then
    get_oldest_notification():destroy(naughty.notification_closed_reason.too_many_on_screen)
  end
end)

-- for i = 1, 12, 1 do
--   naughty.notification({
--     title = "This is title " .. i,
--     message = "What do you want from a notification like me? I need somebody to heal",
--     app_name = "Firefox Developer Edition",
--     app_icon = "firefox-developer-edition",
--     actions = {
--       naughty.action({
--         name = "Accept",
--       }),
--       naughty.action({
--         name = "Refuse",
--       }),
--       naughty.action({
--         name = "Ignore",
--       }),
--     },
--   })
-- end
