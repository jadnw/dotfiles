local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local lib = require("lib")
local dpi = lib.utils.dpi

return function()
  local profile = wibox.widget({
    {
      {
        {
          {
            {
              image = beautiful.avatar,
              resize = true,
              widget = wibox.widget.imagebox,
              clip_shape = lib.ui.rrect(80),
              forced_width = dpi(160),
              forced_height = dpi(160),
            },
            shape = lib.ui.rrect(80),
            border_width = dpi(2),
            border_color = beautiful.palette.accent,
            widget = wibox.container.background,
          },
          halign = "center",
          widget = wibox.container.place,
        },
        {
          {
            {
              text = "JADEN WU @jadnw",
              font = beautiful.font_family .. " Heavy 16",
              widget = wibox.widget.textbox,
            },
            {
              markup = '<span weight="800">Github:</span> github.com/jadnw',
              font = beautiful.font,
              widget = wibox.widget.textbox,
            },
            {
              markup = '<span weight="800">Twitter:</span> twitter.com/jadnw',
              font = beautiful.font,
              widget = wibox.widget.textbox,
            },
            {
              markup = '<span weight="800">Email:</span> jadenwu137@protonmail.com',
              font = beautiful.font,
              widget = wibox.widget.textbox,
            },
            {
              markup = '<span weight="800">Website:</span> jadnw.github.io',
              font = beautiful.font,
              widget = wibox.widget.textbox,
            },
            spacing = dpi(8),
            layout = wibox.layout.fixed.vertical,
          },
          valign = "center",
          widget = wibox.container.place,
        },
        spacing = dpi(48),
        layout = wibox.layout.fixed.horizontal,
      },
      margins = dpi(24),
      widget = wibox.container.margin,
    },
    border_width = dpi(1),
    border_color = beautiful.palette.bg4,
    shape = lib.ui.rrect(4),
    widget = wibox.container.background,
  })

  return profile
end
