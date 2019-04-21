#!/usr/bin/env bash

# {{{ color
readonly TMUX_CZ_BLACK="colour0"
readonly TMUX_CZ_WHITE="colour15"
readonly TMUX_CZ_GREEN="colour29"
readonly TMUX_CZ_YELLOW_GREEN="colour108"
readonly TMUX_CZ_RED="colour160"
readonly TMUX_CZ_ORANGE="colour202"
readonly TMUX_CZ_DARK_ORANGE="colour208"
readonly TMUX_CZ_NAVAJO_WHITE="colour223"
readonly TMUX_CZ_LIGHT_BLACK="colour235"
readonly TMUX_CZ_DARK_GRAY="colour237"
readonly TMUX_CZ_LIGHT_GRAY="colour243"
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
tmux set -g status-style bg=$TMUX_CZ_LIGHT_BLACK,fg=$TMUX_CZ_DARK_ORANGE
# }}}

# {{{ window status
window_index="#[fg=$TMUX_CZ_WHITE]#[bg=$TMUX_CZ_LIGHT_GRAY] #{window_index}#{window_flags} "
window_name="#[bg=$TMUX_CZ_DARK_GRAY] #{window_name} "

cur_window_index="#[bg=$TMUX_CZ_YELLOW_GREEN]#[fg=$TMUX_CZ_BLACK] #{window_index}#{window_flags} "
cur_window_name="#[bg=$TMUX_CZ_NAVAJO_WHITE] #{window_name} "

tmux set -g window-status-format "${window_index}${window_name}"
tmux set -g window-status-current-format "${cur_window_index}${cur_window_name}"
# }}}

# {{{ left and right status
# color block
default_block=$(block)$(block)
red_block=$(block $TMUX_CZ_RED)
orange_block=$(block $TMUX_CZ_ORANGE)
green_block=$(block $TMUX_CZ_GREEN)
yellow_green_block=$(block $TMUX_CZ_YELLOW_GREEN)
light_gray_block=$(block $TMUX_CZ_LIGHT_GRAY)
dark_gray_block=$(block $TMUX_CZ_DARK_GRAY)

color_blocks="${red_block}${orange_block}${green_block}${yellow_green_block}${light_gray_block}${dark_gray_block}"
color_blocks_reverse="${dark_gray_block}${light_gray_block}${yellow_green_block}${green_block}${orange_block}${red_block}"

host_name="#{?client_prefix,#[fg=$TMUX_CZ_DARK_GRAY]#[bg=$TMUX_CZ_DARK_ORANGE]#[bold],#[bg=$TMUX_CZ_DARK_GRAY]} #H [#S] "
battery_status="${dark_gray_block}#{battery_status_fg}#{battery_icon} #{battery_percentage}${dark_gray_block}"
clock="#[bg=$TMUX_CZ_DARK_GRAY] %H:%M %Y-%m-%d(%a) "
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
tmux set -g pane-border-style fg=$TMUX_CZ_DARK_GRAY
tmux set -g pane-active-border-style fg=$TMUX_CZ_DARK_ORANGE
# }}}

# {{{ mode
tmux set -g mode-style bg=$TMUX_CZ_DARK_ORANGE,fg=$TMUX_CZ_LIGHT_BLACK
# }}}

# {{{ message
tmux set -g message-style bg=$TMUX_CZ_LIGHT_BLACK,fg=$TMUX_CZ_DARK_ORANGE
# }}}

# {{{ display pane number
tmux set -g display-panes-colour $TMUX_CZ_YELLOW_GREEN
tmux set -g display-panes-active-colour $TMUX_CZ_DARK_ORANGE
# }}}
