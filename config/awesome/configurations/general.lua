local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

-- Enable autofocus (will be deprecated in v5)
require("awful.autofocus")

client.connect_signal("request::manage", function(c) -- luacheck: no global
  -- Set the windows at the slave
  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then -- luacheck: no global
    -- Prevent clients from being unreachable after screen count changes
    awful.placement.no_offscreen(c)
  end
end)

-- Back to previous client after closing/minimizing client
local function back_to_prev_client()
  local s = awful.screen.focused()
  local c = awful.client.focus.history.get(s, 0)
  if c then
    client.focus = c -- luacheck: no global
    c:raise()
  end
end

client.connect_signal("unmanage", back_to_prev_client) -- luacheck: no global
client.connect_signal("property::minimized", back_to_prev_client) -- luacheck: no global

--- Hide all windows when a splash is shown
--------------------------------------------------------------------------------
awesome.connect_signal("widgets::splash::visibility", function(vis) -- luacheck: no global
  local t = screen.primary.selected_tag -- luacheck: no global
  if vis then
    for idx, c in ipairs(t:clients()) do -- luacheck: no unused
      c.hidden = true
    end
  else
    for idx, c in ipairs(t:clients()) do -- luacheck: no unused
      c.hidden = false
    end
  end
end)

--- Enable sloppy focus, so that focus follows mouse.
--------------------------------------------------------------------------------
client.connect_signal("mouse::enter", function(c) -- luacheck: no global
  c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

--- Wallpapers
--------------------------------------------------------------------------------
local set_wallpaper = function(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper

    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end

    gears.wallpaper.maximized(wallpaper, s, false, nil)
  end
end

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)
end)
