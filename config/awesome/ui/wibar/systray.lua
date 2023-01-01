local beautiful = require("beautiful")
local wibox = require("wibox")

local factory = require("factory")

return function()
  local systray_caret = wibox.widget({
    {
      {
        id = "icon",
        text = beautiful.icon_systray_closed,
        font = beautiful.icon_font .. " Round 16",
        widget = wibox.widget.textbox,
      },
      id = "background",
      fg = beautiful.palette.fg1,
      widget = wibox.container.background,
    },
    widget = wibox.container.place,
  })

  local icon = systray_caret:get_children_by_id("icon")[1]
  local background = systray_caret:get_children_by_id("background")[1]

  local systray_button = factory.create_button({
    child = systray_caret,
    tooltip = true,
    bg_hover = beautiful.palette.bg1,
    on_click = function()
      awesome.emit_signal("systray::toggle")
    end,
  })

  systray_button.set_tooltip("Open systray")

  local systray_bar = wibox.widget({
    widget = wibox.widget.systray,
  })

  local systray = wibox.widget({
    systray_bar,
    systray_button,
    layout = wibox.layout.fixed.horizontal,
  })

  local toggle_systray_bar = function()
    systray_bar.visible = not systray_bar.visible
    if systray_bar.visible then
      icon:set_text(beautiful.icon_systray_opened)
      background:set_fg(beautiful.palette.purple)
      systray_button.set_tooltip("Close systray")
    else
      icon:set_text(beautiful.icon_systray_closed)
      background:set_fg(beautiful.palette.fg1)
      systray_button.set_tooltip("Open systray")
    end
  end

  awesome.connect_signal("systray::toggle", toggle_systray_bar)

  return #systray_bar:get_all_children() > 0 and systray or nil
end
