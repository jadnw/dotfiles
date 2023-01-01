-- GENERAL
--------------------------------------------------------------------------------
pcall(require, "luarocks.loader")
local gears = require("gears")
local naughty = require("naughty")

--- Errors Handling
naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification({
    urgency = "critical",
    title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
    message = message,
  })
end)

--- THEME
--------------------------------------------------------------------------------
require("themes")

--- LOAD GLOBAL CONFIGS
----------------------------------------------------------------------------------------------------
require("configs")

--- CONFIGURATIONS
--------------------------------------------------------------------------------
require("configurations")

-- LOAD MODULES
-- Notifications
require("modules.notifications")

--- USER INTERFACES
--------------------------------------------------------------------------------
-- wibar
require("ui.wibar")

--- Garbage Collection
--------------------------------------------------------------------------------
--- Enable for lower memory consumption
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
gears.timer({
  timeout = 5,
  autostart = true,
  call_now = true,
  callback = function()
    collectgarbage("collect")
  end,
})
