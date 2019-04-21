#!/usr/bin/env bash

# {{{ color
readonly BLACK="colour0"
readonly WHITE="colour15"
readonly GREEN="colour29"
readonly YELLOW_GREEN="colour108"
readonly RED="colour160"
readonly ORANGE="colour202"
readonly DARK_ORANGE="colour208"
readonly NAVAJO_WHITE="colour223"
readonly LIGHT_BLACK="colour235"
readonly DARK_GRAY="colour237"
readonly LIGHT_GRAY="colour243"
# }}}

# {{{ function
block() {
  local color=$1

  if [[ -z $color ]]; then
    color=default
  fi

  echo "#[bg=$color] "
}
# }}}

# {{{ status
# options
tmux set -g status-interval 1
tmux set -g status-justify left

# base color
tmux set -g status-style bg=$LIGHT_BLACK,fg=$DARK_ORANGE
# }}}

# {{{ window status
window_index="#[fg=$WHITE]#[bg=$LIGHT_GRAY] #{window_index}#{window_flags} "
window_name="#[bg=$DARK_GRAY] #{window_name} "

cur_window_index="#[bg=$YELLOW_GREEN]#[fg=$BLACK] #{window_index}#{window_flags} "
cur_window_name="#[bg=$NAVAJO_WHITE] #{window_name} "

tmux set -g window-status-format "${window_index}${window_name}"
tmux set -g window-status-current-format "${cur_window_index}${cur_window_name}"
# }}}

# {{{ left and right status
# color block
default_block=$(block)$(block)
red_block=$(block $RED)
orange_block=$(block $ORANGE)
green_block=$(block $GREEN)
yellow_green_block=$(block $YELLOW_GREEN)
light_gray_block=$(block $LIGHT_GRAY)
dark_gray_block=$(block $DARK_GRAY)

color_blocks="${red_block}${orange_block}${green_block}${yellow_green_block}${light_gray_block}${dark_gray_block}"
color_blocks_reverse="${dark_gray_block}${light_gray_block}${yellow_green_block}${green_block}${orange_block}${red_block}"

host_name="#{?client_prefix,#[fg=$DARK_GRAY]#[bg=$DARK_ORANGE]#[bold],#[bg=$DARK_GRAY]} #H [#S] "
battery_status="${dark_gray_block}#{battery_status_fg}#{battery_icon} #{battery_percentage}${dark_gray_block}"
clock="#[bg=$DARK_GRAY] %H:%M %Y-%m-%d(%a) "
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
tmux set -g pane-border-style fg=$DARK_GRAY
tmux set -g pane-active-border-style fg=$DARK_ORANGE
# }}}

# {{{ mode
tmux set -g mode-style bg=$DARK_ORANGE,fg=$LIGHT_BLACK
# }}}

# {{{ message
tmux set -g message-style bg=$LIGHT_BLACK,fg=$DARK_ORANGE
# }}}

# {{{ display pane number
tmux set -g display-panes-colour $YELLOW_GREEN
tmux set -g display-panes-active-colour $DARK_ORANGE
# }}}
