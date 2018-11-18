#!/usr/bin/env bash

# {{{ color
black="colour0"
white="colour15"
green="colour29"
yellow_green="colour108"
red="colour160"
orange="colour202"
dark_orange="colour208"
navajo_white="colour223"
light_black="colour235"
dark_gray="colour237"
light_gray="colour243"
# }}}

# {{{ status
# options
tmux set -g status-interval 1
tmux set -g status-justify left

# base color
tmux set -g status-style bg=$light_black,fg=$dark_orange
# }}}

# {{{ window status
window_index="#[fg=$white]#[bg=$light_gray] #{window_index}#{window_flags} "
window_name="#[bg=$dark_gray] #{window_name} "

cur_window_index="#[bg=$yellow_green]#[fg=$black] #{window_index}#{window_flags} "
cur_window_name="#[bg=$navajo_white] #{window_name} "

tmux set -g window-status-format "${window_index}${window_name}"
tmux set -g window-status-current-format "${cur_window_index}${cur_window_name}"
# }}}

# {{{ left and right status
# color block
default_block="#[default]  "
red_block="#[bg=$red] "
orange_block="#[bg=$orange] "
green_block="#[bg=$green] "
yellow_green_block="#[bg=$yellow_green] "
light_gray_block="#[bg=$light_gray] "
dark_gray_block="#[bg=$dark_gray] "

color_blocks="${red_block}${orange_block}${green_block}${yellow_green_block}${light_gray_block}${dark_gray_block}"
color_blocks_reverse="${dark_gray_block}${light_gray_block}${yellow_green_block}${green_block}${orange_block}${red_block}"

host_name="#{?client_prefix,#[fg=$dark_gray]#[bg=$dark_orange]#[bold],#[bg=$dark_gray]} #H [#S] "
battery_status="${dark_gray_block}#{battery_status_fg}#{battery_icon} #{battery_percentage}${dark_gray_block}"
clock="#[bg=$dark_gray] %H:%M %Y-%m-%d(%a) "
status_right="${clock}${default_block}${color_blocks_reverse}"

tmux set -g status-left-length 90
tmux set -g status-left "${color_blocks}${default_block}${host_name}${default_block}"
tmux set -g status-right-length 90

# If 
tmux set -g status-right "${status_right}"
if tmux show-option -gqv @plugin | grep tmux-battery > /dev/null 2>&1; then
  tmux set -g status-right "${battery_status}${default_block}${status_right}"
fi
# }}}

# {{{ pane
tmux set -g pane-border-style fg=$dark_gray
tmux set -g pane-active-border-style fg=$dark_orange
# }}}

# {{{ mode
tmux set -g mode-style bg=$dark_orange,fg=$light_black
# }}}

# {{{ message
tmux set -g message-style bg=$light_black,fg=$dark_orange
# }}}

# {{{ display pane number
tmux set -g display-panes-colour $yellow_green
tmux set -g display-panes-active-colour $dark_orange
# }}}
