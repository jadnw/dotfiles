local awful = require("awful")

local l = awful.layout.suit
tag.connect_signal("request::default_layouts", function()
  awful.layout.append_default_layouts({
    l.tile,
    l.spiral.dwindle,
    l.floating,
    l.max,
  })
end)
