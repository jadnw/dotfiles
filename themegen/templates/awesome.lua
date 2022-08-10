local utils = require("themegen.utils")

local _awesome_template = {}

_awesome_template.name = "awesome"

_awesome_template.path = "awesome/themes"
_awesome_template.filename = "palette.lua"

_awesome_template.gen = function(schema)
	local template = utils.template(
		[[
-- ${theme} color palette
return {
  -- Accent color
  accent = "${accent}",
  -- Backgrounds & Foregrounds
  bg0 = "${bg0}",
  bg1 = "${bg1}",
  bg2 = "${bg2}",
  bg3 = "${bg3}",
  bg4 = "${bg4}",
  fg0 = "${fg0}",
  fg1 = "${fg1}",
  fg2 = "${fg2}",
  fg3 = "${fg3}",
  -- Palette
  black = "${black}",
  red = "${red}",
  orange = "${orange}",
  yellow = "${yellow}",
  green = "${green}",
  teal = "${teal}",
  cyan = "${cyan}",
  blue = "${blue}",
  magenta = "${magenta}",
  purple = "${purple}",
  white = "${white}",
  gray = "${gray}",
}
    ]],
		schema
	)

	return template
end

return _awesome_template
