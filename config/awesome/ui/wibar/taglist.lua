local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local lib = require("lib")
local animation = require("lib.animation")
local dpi = require("lib.utils").dpi

local mod = "Mod4"

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ mod }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ mod }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

return function(s)
	local taglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		layout = {
			forced_width = dpi(332),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					id = "taglist_indicator",
					forced_width = dpi(20),
					forced_height = dpi(10),
					shape = gears.shape.rounded_bar,
					bg = beautiful.palette.bg4,
					widget = wibox.container.background,
				},
				left = dpi(16),
				right = dpi(16),
				widget = wibox.container.margin,
			},
			id = "taglist_item",
			fill_vertical = true,
			widget = wibox.container.place,
			-- Add support for hover colors and an index label
			create_callback = function(self, t)
				local taglist_item = self:get_children_by_id("taglist_item")[1]
				lib.ui.add_hover_cursor(taglist_item)
				local taglist_indicator = self:get_children_by_id("taglist_indicator")[1]
				self.indicator_animation = animation:new({
					duration = 0.25,
					easing = animation.easing.linear,
					update = function(_, pos)
						taglist_indicator.forced_width = pos
					end,
				})

				if t.selected then
					taglist_indicator.bg = beautiful.palette.accent
					self.indicator_animation:set(dpi(40))
				elseif #t:clients() == 0 then
					taglist_indicator.bg = beautiful.palette.bg4
					self.indicator_animation:set(dpi(20))
				else
					taglist_indicator.bg = beautiful.palette.orange
					self.indicator_animation:set(dpi(20))
				end
			end,
			update_callback = function(self, t)
				local taglist_indicator = self:get_children_by_id("taglist_indicator")[1]

				if t.selected then
					taglist_indicator.bg = beautiful.palette.accent
					self.indicator_animation:set(dpi(40))
				elseif #t:clients() == 0 then
					taglist_indicator.bg = beautiful.palette.bg4
					self.indicator_animation:set(dpi(20))
				else
					taglist_indicator.bg = beautiful.palette.orange
					self.indicator_animation:set(dpi(20))
				end
			end,
		},
		buttons = taglist_buttons,
	})

	local widget = wibox.widget({
		{
			taglist,
			left = dpi(16),
			right = dpi(16),
			widget = wibox.container.margin,
		},
		bg = beautiful.palette.bg1,
		shape = lib.ui.rrect(beautiful.border_radius),
		widget = wibox.container.background,
	})

	return widget
end
