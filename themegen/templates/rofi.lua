local utils = require("themegen.utils")

local _rofi_template = {}

_rofi_template.name = "rofi"

_rofi_template.path = "awesome/externals/rofi"
_rofi_template.filename = "theme.rasi"

_rofi_template.gen = function(schema)
	local template = utils.template(
		[[
/* ${theme} colorscheme for Rofi */
/* ~/.config/awesome/externals/rofi/theme.rasi */

* {
  none:     #00000000;
  accent:   ${accent};
  bg0:      ${bg0};
  bg1:      ${bg1};
  bg2:      ${bg2};
  bg3:      ${bg3};
  bg4:      ${bg4};
  fg0:      ${fg0};
  fg1:      ${fg1};
  fg2:      ${fg2};
  fg3:      ${fg3};
  black:    ${black};
  red:      ${red};
  orange:   ${orange};
  yellow:   ${yellow};
  green:    ${green};
  teal:     ${teal};
  cyan:     ${cyan};
  blue:     ${blue};
  magenta:  ${magenta};
  purple:   ${purple};
  white:    ${white};
  gray:     ${gray};
}
    ]],
		schema
	)

	return template
end

return _rofi_template
