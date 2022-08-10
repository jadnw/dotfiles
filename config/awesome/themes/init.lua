local gears = require("gears")
local beautiful = require("beautiful")

local theme_config = gears.filesystem.get_configuration_dir() .. "themes/theme.lua"
beautiful.init(theme_config)
