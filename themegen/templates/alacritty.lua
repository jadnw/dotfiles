local utils = require("themegen.utils")

local _alacritty_template = {}

_alacritty_template.name = "alacritty"

_alacritty_template.path = "alacritty"
_alacritty_template.filename = "theme.yml"

_alacritty_template.gen = function(schema)
	local template = utils.template(
		[[
# ${theme} for Alacritty
# ~/.config/alacritty/theme.yml
colors:
  primary:
    background: '${bg1}'
    foreground: '${fg1}'
    dim_foreground: '${fg3}'
    bright_foreground: '${fg0}'
  cursor:
    text: '${bg1}'
    cursor: '${accent}'
  vi_mode_cursor:
    text: '${bg1}'
    cursor: '${accent}'
  search:
    matches:
      foreground: '${bg3}'
      background: '${purple}'
    focused_match:
      foreground: '${purple}'
      background: '${bg3}'
  hints:
    start:
      foreground: '${bg3}'
      background: '${yellow}'
    end:
      foreground: '${yellow}'
      background: '${bg3}'
  line_indicator:
    foreground: None
    background: None
  footer_bar:
    foreground: '${bg3}'
    background: '${purple}'
  selection:
    text: '${fg1}'
    background: '${bg4}'
  normal:
    black: '${black}'
    red: '${red}'
    green: '${green}'
    yellow: '${yellow}'
    blue: '${blue}'
    magenta: '${magenta}'
    cyan: '${cyan}'
    white: '${white}'
  bright:
    black: '${black}'
    red: '${red}'
    green: '${green}'
    yellow: '${yellow}'
    blue: '${blue}'
    magenta: '${magenta}'
    cyan: '${cyan}'
    white: '${white}'
    ]],
		schema
	)

	return template
end

return _alacritty_template
