# Set useful shell options
set -Cueo pipefail

source "${CURRENT_DIR}/src/lib.sh"

# {{{ color
readonly TMUX_CZ_BLACK="colour0"
readonly TMUX_CZ_WHITE="colour15"
readonly TMUX_CZ_GREEN="colour29"
readonly TMUX_CZ_YELLOW_GREEN="colour108"
readonly TMUX_CZ_ORANGE="colour202"
readonly TMUX_CZ_DARK_ORANGE="colour208"
readonly TMUX_CZ_NAVAJO_WHITE="colour223"
readonly TMUX_CZ_LIGHT_BLACK="colour235"
readonly TMUX_CZ_DARK_GRAY="colour237"
readonly TMUX_CZ_LIGHT_GRAY="colour243"
# }}}

# Left Decoration
readonly TMUX_CZ_ORANGE_GREEN_LEFT_DECORATION_INFLATION="$(left_decoration_inflation ${TMUX_CZ_ORANGE} ${TMUX_CZ_GREEN})"
readonly TMUX_CZ_GREEN_YELLOW_GREEN_LEFT_DECORATION_INFLATION="$(left_decoration_inflation ${TMUX_CZ_GREEN} ${TMUX_CZ_YELLOW_GREEN})"
readonly TMUX_CZ_YELLOW_GREEN_LIGHT_GRAY_LEFT_DECORATION_INFLATION="$(left_decoration_inflation ${TMUX_CZ_YELLOW_GREEN} ${TMUX_CZ_LIGHT_GRAY})"
readonly TMUX_CZ_LIGHT_GRAY_DARK_GRAY_LEFT_DECORATION_INFLATION="$(left_decoration_inflation ${TMUX_CZ_LIGHT_GRAY} ${TMUX_CZ_DARK_GRAY})"
readonly TMUX_CZ_LIGHT_GRAY_DARK_ORANGE_LEFT_DECORATION_INFLATION="$(left_decoration_inflation ${TMUX_CZ_LIGHT_GRAY} ${TMUX_CZ_DARK_ORANGE})"
readonly TMUX_CZ_LIGHT_BLACK_LIGHT_GRAY_LEFT_DECORATION_INFLATION="$(left_decoration_inflation ${TMUX_CZ_LIGHT_BLACK} ${TMUX_CZ_LIGHT_GRAY})"
readonly TMUX_CZ_LIGHT_BLACK_YELLOW_GREEN_LEFT_DECORATION_INFLATION="$(left_decoration_inflation ${TMUX_CZ_LIGHT_BLACK} ${TMUX_CZ_YELLOW_GREEN})"

# Right Decoration
readonly TMUX_CZ_ORANGE_GREEN_RIGHT_DECORATION_INFLATION="$(right_decoration_inflation ${TMUX_CZ_ORANGE} ${TMUX_CZ_GREEN})"
readonly TMUX_CZ_GREEN_YELLOW_GREEN_RIGHT_DECORATION_INFLATION="$(right_decoration_inflation ${TMUX_CZ_GREEN} ${TMUX_CZ_YELLOW_GREEN})"
readonly TMUX_CZ_YELLOW_GREEN_LIGHT_GRAY_RIGHT_DECORATION_INFLATION="$(right_decoration_inflation ${TMUX_CZ_YELLOW_GREEN} ${TMUX_CZ_LIGHT_GRAY})"
readonly TMUX_CZ_LIGHT_GRAY_DARK_GRAY_RIGHT_DECORATION_INFLATION="$(right_decoration_inflation ${TMUX_CZ_LIGHT_GRAY} ${TMUX_CZ_DARK_GRAY})"

# Left Separator
readonly TMUX_CZ_LIGHT_GRAY_DARK_GRAY_LEFT_SEPARATOR="$(left_separator ${TMUX_CZ_LIGHT_GRAY} ${TMUX_CZ_DARK_GRAY})"
readonly TMUX_CZ_DARK_GRAY_LIGHT_BLACK_LEFT_SEPARATOR="$(left_separator ${TMUX_CZ_DARK_GRAY} ${TMUX_CZ_LIGHT_BLACK})"
readonly TMUX_CZ_YELLOW_GREEN_NAVAJO_WHITE_LEFT_SEPARATOR="$(left_separator ${TMUX_CZ_YELLOW_GREEN} ${TMUX_CZ_NAVAJO_WHITE})"
readonly TMUX_CZ_NAVAJO_WHITE_LIGHT_BLACK_LEFT_SEPARATOR="$(left_separator ${TMUX_CZ_NAVAJO_WHITE} ${TMUX_CZ_LIGHT_BLACK})"
readonly TMUX_CZ_DARK_ORANGE_LIGHT_BLACK_LEFT_SEPARATOR="$(left_separator ${TMUX_CZ_DARK_ORANGE} ${TMUX_CZ_LIGHT_BLACK})"

# Right Separator
readonly TMUX_CZ_DARK_GRAY_LIGHT_BLACK_RIGHT_SEPARATOR="$(right_separator ${TMUX_CZ_DARK_GRAY} ${TMUX_CZ_LIGHT_BLACK})"

# Right Subseparator
readonly TMUX_CZ_LIGHT_GRAY_DARK_GRAY_RIGHT_SUBSEPARATOR="$(right_subseparator ${TMUX_CZ_LIGHT_GRAY} ${TMUX_CZ_DARK_GRAY})"
# }}}

# {{{ status
# options
tmux set -g status-interval 1
tmux set -g status-justify left

# base color
tmux set -g status-style bg=$TMUX_CZ_LIGHT_BLACK,fg=$TMUX_CZ_DARK_ORANGE
# }}}

# {{{ window status
window_index="${TMUX_CZ_LIGHT_BLACK_LIGHT_GRAY_LEFT_DECORATION_INFLATION}#[fg=$TMUX_CZ_WHITE]#[bg=$TMUX_CZ_LIGHT_GRAY] #{window_index}#{window_flags} ${TMUX_CZ_LIGHT_GRAY_DARK_GRAY_LEFT_SEPARATOR}"
window_name="#[fg=${TMUX_CZ_WHITE},bg=$TMUX_CZ_DARK_GRAY] #{window_name} ${TMUX_CZ_DARK_GRAY_LIGHT_BLACK_LEFT_SEPARATOR}"

cur_window_index="${TMUX_CZ_LIGHT_BLACK_YELLOW_GREEN_LEFT_DECORATION_INFLATION}#[bg=$TMUX_CZ_YELLOW_GREEN]#[fg=$TMUX_CZ_BLACK] #{window_index}#{window_flags} ${TMUX_CZ_YELLOW_GREEN_NAVAJO_WHITE_LEFT_SEPARATOR}"
cur_window_name="#[fg=${TMUX_CZ_BLACK},bg=$TMUX_CZ_NAVAJO_WHITE] #{window_name} ${TMUX_CZ_NAVAJO_WHITE_LIGHT_BLACK_LEFT_SEPARATOR}"

tmux set -g window-status-format "${window_index}${window_name}"
tmux set -g window-status-current-format "${cur_window_index}${cur_window_name}"
# }}}

# {{{ left and right status
host_name="#{?client_prefix,${TMUX_CZ_LIGHT_GRAY_DARK_ORANGE_LEFT_DECORATION_INFLATION}#[fg=$TMUX_CZ_DARK_GRAY]#[bg=$TMUX_CZ_DARK_ORANGE]#[bold],${TMUX_CZ_LIGHT_GRAY_DARK_GRAY_LEFT_DECORATION_INFLATION}#[fg=${TMUX_CZ_DARK_ORANGE},bg=$TMUX_CZ_DARK_GRAY]} #H [#S] #{?client_prefix,${TMUX_CZ_DARK_ORANGE_LIGHT_BLACK_LEFT_SEPARATOR},${TMUX_CZ_DARK_GRAY_LIGHT_BLACK_LEFT_SEPARATOR}}"

readonly CLOCK="#[fg=${TMUX_CZ_DARK_ORANGE}]#[bg=${TMUX_CZ_DARK_GRAY}] %H:%M "
readonly CALENDAR="#[fg=${TMUX_CZ_DARK_ORANGE}]#[bg=${TMUX_CZ_DARK_GRAY}] %Y-%m-%d(%a) "

if is_plugin_enabled 'tmux-plugins/tmux-battery'; then
  readonly BATTERY_STATUS="#[fg=${TMUX_CZ_DARK_ORANGE}]#[bg=${TMUX_CZ_DARK_GRAY}] #{battery_status_fg}#{battery_icon} #{battery_percentage} ${TMUX_CZ_LIGHT_GRAY_DARK_GRAY_RIGHT_SUBSEPARATOR}"
else
  readonly BATTERY_STATUS=''
fi

readonly STATUS_LEFT="${TMUX_CZ_ORANGE_GREEN_LEFT_DECORATION_INFLATION}${TMUX_CZ_GREEN_YELLOW_GREEN_LEFT_DECORATION_INFLATION}${TMUX_CZ_YELLOW_GREEN_LIGHT_GRAY_LEFT_DECORATION_INFLATION}${host_name} "
readonly STATUS_RIGHT="${TMUX_CZ_DARK_GRAY_LIGHT_BLACK_RIGHT_SEPARATOR}${BATTERY_STATUS}${CLOCK}${TMUX_CZ_LIGHT_GRAY_DARK_GRAY_RIGHT_SUBSEPARATOR}${CALENDAR}${TMUX_CZ_LIGHT_GRAY_DARK_GRAY_RIGHT_DECORATION_INFLATION}${TMUX_CZ_YELLOW_GREEN_LIGHT_GRAY_RIGHT_DECORATION_INFLATION}${TMUX_CZ_GREEN_YELLOW_GREEN_RIGHT_DECORATION_INFLATION}${TMUX_CZ_ORANGE_GREEN_RIGHT_DECORATION_INFLATION}"

tmux set -g status-left-length 90
tmux set -g status-left "${STATUS_LEFT}"
tmux set -g status-right-length 90
tmux set -g status-right "${STATUS_RIGHT}"
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
