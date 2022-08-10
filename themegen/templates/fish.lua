local utils = require("themegen.utils")

local _fish_template = {}

_fish_template.name = "fish"

_fish_template.path = "fish/conf.d"
_fish_template.filename = "theme.fish"

_fish_template.gen = function(schema)
	local sch = utils.remove_hashtag_from_schema(schema)
	local template = utils.template(
		[[
# ${theme} colorscheme for Fish
# ~/.config/fish/conf.d/theme.fish

# --> special
set -l fg ${fg1}
set -l sel ${bg4}

# --> palette
set -l red ${red}
set -l green ${green}
set -l yellow ${yellow}
set -l orange ${orange}
set -l blue ${blue}
set -l magenta ${magenta}
set -l purple ${purple}
set -l cyan ${cyan}
set -l gray ${gray}

# Syntax Highlighting
set -g fish_color_normal $fg
set -g fish_color_command $green
set -g fish_color_param $fg
set -g fish_color_keyword $red
set -g fish_color_quote $green
set -g fish_color_redirection $purple
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_gray $gray
set -g fish_color_selection --background=$sel
set -g fish_color_search_match --background=$sel
set -g fish_color_operator $blue
set -g fish_color_escape $magenta
set -g fish_color_autosuggestion $gray
set -g fish_color_cancel $red

# Prompt
set -g fish_color_cwd $yellow
set -g fish_color_user $cyan
set -g fish_color_host $blue

# Completion Pager
set -g fish_pager_color_progress $gray
set -g fish_pager_color_prefix $purple
set -g fish_pager_color_completion $fg
set -g fish_pager_color_description $gray
    ]],
		sch
	)

	return template
end

return _fish_template
