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
    echo "#[default] "
    return
  fi

  echo "#[bg=$color] "
}
# }}}

# {{{ color block components
readonly TMUX_CZ_DEFAULT_BLOCK=$(block)$(block)
readonly TMUX_CZ_RED_BLOCK=$(block $TMUX_CZ_RED)
readonly TMUX_CZ_ORANGE_BLOCK=$(block $TMUX_CZ_ORANGE)
readonly TMUX_CZ_GREEN_BLOCK=$(block $TMUX_CZ_GREEN)
readonly TMUX_CZ_YELLOW_GREEN_BLOCK=$(block $TMUX_CZ_YELLOW_GREEN)
readonly TMUX_CZ_LIGHT_GRAY_BLOCK=$(block $TMUX_CZ_LIGHT_GRAY)
readonly TMUX_CZ_DARK_GRAY_BLOCK=$(block $TMUX_CZ_DARK_GRAY)

readonly TMUX_CZ_COLOR_BLOCKS="${TMUX_CZ_RED_BLOCK}${TMUX_CZ_ORANGE_BLOCK}${TMUX_CZ_GREEN_BLOCK}${TMUX_CZ_YELLOW_GREEN_BLOCK}${TMUX_CZ_LIGHT_GRAY_BLOCK}${TMUX_CZ_DARK_GRAY_BLOCK}"
readonly TMUX_CZ_COLOR_BLOCKS_REVERSE="${TMUX_CZ_DARK_GRAY_BLOCK}${TMUX_CZ_LIGHT_GRAY_BLOCK}${TMUX_CZ_YELLOW_GREEN_BLOCK}${TMUX_CZ_GREEN_BLOCK}${TMUX_CZ_ORANGE_BLOCK}${TMUX_CZ_RED_BLOCK}"
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
host_name="#{?client_prefix,#[fg=$TMUX_CZ_DARK_GRAY]#[bg=$TMUX_CZ_DARK_ORANGE]#[bold],#[bg=$TMUX_CZ_DARK_GRAY]} #H [#S] "
battery_status="${TMUX_CZ_DARK_GRAY_BLOCK}#{battery_status_fg}#{battery_icon} #{battery_percentage}${TMUX_CZ_DARK_GRAY_BLOCK}"
clock="#[bg=$TMUX_CZ_DARK_GRAY] %H:%M %Y-%m-%d(%a) "
status_right="${clock}${TMUX_CZ_DEFAULT_BLOCK}${TMUX_CZ_COLOR_BLOCKS_REVERSE}"

tmux set -g status-left-length 90
tmux set -g status-left "${TMUX_CZ_COLOR_BLOCKS}${TMUX_CZ_DEFAULT_BLOCK}${host_name}${TMUX_CZ_DEFAULT_BLOCK}"
tmux set -g status-right-length 90

# If 
tmux set -g status-right "${status_right}"
if tmux show-option -gqv @plugin | grep tmux-battery > /dev/null 2>&1; then
  tmux set -g status-right "${battery_status}${TMUX_CZ_DEFAULT_BLOCK}${status_right}"
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
