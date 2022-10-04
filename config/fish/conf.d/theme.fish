# Winterfell colorscheme for Fish
# ~/.config/fish/conf.d/theme.fish

# --> special
set -l fg 9ab3c1
set -l sel 334855

# --> palette
set -l red df6265
set -l green 8ed084
set -l yellow d9c57a
set -l orange ec9772
set -l blue 62a5fd
set -l magenta f474bc
set -l purple a47efd
set -l cyan 60b8d8
set -l gray 466272

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
    