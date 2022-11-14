# Winterfell colorscheme for Fish
# ~/.config/fish/conf.d/theme.fish

# --> special
set -l fg a0b4c1
set -l sel 32434d

# --> palette
set -l red e86a6f
set -l green 8ccf7e
set -l yellow d8ce91
set -l orange d4a36d
set -l blue 709ad2
set -l magenta d076b9
set -l purple ad8bee
set -l cyan 70d8ca
set -l gray 547182

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
    