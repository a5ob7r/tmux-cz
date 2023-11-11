#!/usr/bin/env bash

# Set useful shell options
set -Cueo pipefail

# shellcheck source=src/lib.sh
source "$CURRENT_DIR/src/lib.sh"

# Utilities {{{
strip_quotations () {
  case "$1" in
    \"*\" | \'*\')
      echo -n "${1:1:${#1} - 2}"
      ;;
    * )
      echo -n "$1"
      ;;
  esac
}

format_to_swap_foreground_background_color_by_client_prefix () {
  local foreground_color=$1
  local background_color=$2
  echo -n "#{?client_prefix,#[fg=$background_color]#[bg=$foreground_color],#[fg=$foreground_color]#[bg=$background_color]}"
}

format_to_toggle_foreground_color_by_client_prefix () {
  local client_prefix_on_foreground_color=$1
  local client_prefix_off_foreground_color=$2
  echo -n "#{?client_prefix,#[fg=$client_prefix_on_foreground_color],#[fg=$client_prefix_off_foreground_color]}"
}

format_to_toggle_background_color_by_client_prefix () {
  local client_prefix_on_background_color=$1
  local client_prefix_off_background_color=$2
  echo -n "#{?client_prefix,#[bg=$client_prefix_on_background_color],#[bg=$client_prefix_off_background_color]}"
}

format_to_toggle_bold_by_client_prefix () {
  echo -n "#[#{?client_prefix,bold,}]"
}

fetch_tmux_option () {
  local variable_name=$1

  tmux -gv "$variable_name" 2>/dev/null
}
# }}}

# {{{ color
readonly TMUX_CZ_BLACK=colour0
readonly TMUX_CZ_WHITE=colour15
readonly TMUX_CZ_GREEN=colour29
readonly TMUX_CZ_YELLOW_GREEN=colour108
readonly TMUX_CZ_ORANGE=colour202
readonly TMUX_CZ_DARK_ORANGE=colour208
readonly TMUX_CZ_NAVAJO_WHITE=colour223
readonly TMUX_CZ_LIGHT_BLACK=colour235
readonly TMUX_CZ_DARK_GRAY=colour237
readonly TMUX_CZ_LIGHT_GRAY=colour243
# }}}

# Left Decoration
readonly TMUX_CZ_LIGHT_BLACK_LIGHT_GRAY_LEFT_DECORATION_INFLATION=$(left_decoration_inflation "$TMUX_CZ_LIGHT_BLACK" "$TMUX_CZ_LIGHT_GRAY")
readonly TMUX_CZ_LIGHT_BLACK_YELLOW_GREEN_LEFT_DECORATION_INFLATION=$(left_decoration_inflation "$TMUX_CZ_LIGHT_BLACK" "$TMUX_CZ_YELLOW_GREEN")

# Left Separator
readonly TMUX_CZ_LIGHT_GRAY_DARK_GRAY_LEFT_SEPARATOR=$(left_separator "$TMUX_CZ_LIGHT_GRAY" "$TMUX_CZ_DARK_GRAY")
readonly TMUX_CZ_DARK_GRAY_LIGHT_BLACK_LEFT_SEPARATOR=$(left_separator "$TMUX_CZ_DARK_GRAY" "$TMUX_CZ_LIGHT_BLACK")
readonly TMUX_CZ_YELLOW_GREEN_NAVAJO_WHITE_LEFT_SEPARATOR=$(left_separator "$TMUX_CZ_YELLOW_GREEN" "$TMUX_CZ_NAVAJO_WHITE")
readonly TMUX_CZ_NAVAJO_WHITE_LIGHT_BLACK_LEFT_SEPARATOR=$(left_separator "$TMUX_CZ_NAVAJO_WHITE" "$TMUX_CZ_LIGHT_BLACK")
# }}}

# {{{ status
# base color
tmux set -g status-style "bg=$TMUX_CZ_LIGHT_BLACK,fg=$TMUX_CZ_DARK_ORANGE"
# }}}

# {{{ window status
window_index="$TMUX_CZ_LIGHT_BLACK_LIGHT_GRAY_LEFT_DECORATION_INFLATION#[fg=$TMUX_CZ_WHITE]#[bg=$TMUX_CZ_LIGHT_GRAY] #{window_index}#{window_flags} $TMUX_CZ_LIGHT_GRAY_DARK_GRAY_LEFT_SEPARATOR"
window_name="#[fg=$TMUX_CZ_WHITE,bg=$TMUX_CZ_DARK_GRAY] #{window_name} $TMUX_CZ_DARK_GRAY_LIGHT_BLACK_LEFT_SEPARATOR"

cur_window_index="$TMUX_CZ_LIGHT_BLACK_YELLOW_GREEN_LEFT_DECORATION_INFLATION#[bg=$TMUX_CZ_YELLOW_GREEN]#[fg=$TMUX_CZ_BLACK] #{window_index}#{window_flags} $TMUX_CZ_YELLOW_GREEN_NAVAJO_WHITE_LEFT_SEPARATOR"
cur_window_name="#[fg=$TMUX_CZ_BLACK,bg=$TMUX_CZ_NAVAJO_WHITE] #{window_name} $TMUX_CZ_NAVAJO_WHITE_LIGHT_BLACK_LEFT_SEPARATOR"

tmux set -g window-status-format "${window_index}${window_name}"
tmux set -g window-status-current-format "${cur_window_index}${cur_window_name}"
# }}}

# {{{ pane
tmux set -g pane-border-style "fg=$TMUX_CZ_DARK_GRAY"
tmux set -g pane-active-border-style "fg=$TMUX_CZ_DARK_ORANGE"
# }}}

# {{{ mode
tmux set -g mode-style "bg=$TMUX_CZ_DARK_ORANGE,fg=$TMUX_CZ_LIGHT_BLACK"
# }}}

# {{{ message
tmux set -g message-style "bg=$TMUX_CZ_LIGHT_BLACK,fg=$TMUX_CZ_DARK_ORANGE"
# }}}

# {{{ display pane number
tmux set -g display-panes-colour "$TMUX_CZ_YELLOW_GREEN"
tmux set -g display-panes-active-colour "$TMUX_CZ_DARK_ORANGE"
# }}}

# overhaul {{{
# status-left / status-right {{{
status_left_elements=()
status_right_elements=()
clear_status_left_elements=0
clear_status_right_elements=0
enable_default_status_left_elements=1
enable_default_status_right_elements=1

while read -r; do
  case "$REPLY" in
    @TMUX_CZ_LEFT_ELEMENT_\ * )
      clear_status_left_elements=1
      ;;
    @TMUX_CZ_LEFT_ELEMENT_* )
      status_left_elements+=("$(strip_quotations "${REPLY#@TMUX_CZ_LEFT_ELEMENT_* }")")
      enable_default_status_left_elements=0
      ;;
    @TMUX_CZ_RIGHT_ELEMENT_\ * )
      clear_status_right_elements=1
      ;;
    @TMUX_CZ_RIGHT_ELEMENT_* )
      status_right_elements+=("$(strip_quotations "${REPLY#@TMUX_CZ_RIGHT_ELEMENT_* }")")
      enable_default_status_right_elements=0
      ;;
    * )
      ;;
  esac
done < <(tmux show-options -g || true)

if (( enable_default_status_left_elements )); then
  status_left_elements=(
    TMUX_CZ_LEFT_DECORATION
    ' #H [#S] '
  )
fi

if (( enable_default_status_right_elements )); then
  status_right_elements=(
    ' %H:%M '
    ' %Y-%m-%d(%a) '
    TMUX_CZ_RIGHT_DECORATION
  )
fi

if (( clear_status_left_elements )); then
  status_left_elements=()
fi

if (( clear_status_right_elements )); then
  status_right_elements=()
fi

tmux set -g status-left ''
tmux set -g status-right ''

left_separator_glyph=$(fetch_tmux_option @TMUX_CZ_LEFT_SEPARATOR || echo -n '█')
left_subseparator_glyph=$(fetch_tmux_option @TMUX_CZ_LEFT_SUBSEPARATOR || echo -n '|')
right_separator_glyph=$(fetch_tmux_option @TMUX_CZ_RIGHT_SEPARATOR || echo -n '█')
right_subseparator_glyph=$(fetch_tmux_option @TMUX_CZ_RIGHT_SUBSEPARATOR || echo -n '|')

for (( i = 0; i < ${#status_left_elements[@]}; i++ )); do
  case "${status_left_elements[$i]}" in
    TMUX_CZ_LEFT_DECORATION )
      tmux set -ga status-left "#[fg=$TMUX_CZ_ORANGE,bg=$TMUX_CZ_GREEN]$left_separator_glyph#[none]"
      tmux set -ga status-left "#[fg=$TMUX_CZ_GREEN,bg=$TMUX_CZ_YELLOW_GREEN]$left_separator_glyph#[none]"
      tmux set -ga status-left "#[fg=$TMUX_CZ_YELLOW_GREEN,bg=$TMUX_CZ_LIGHT_GRAY]$left_separator_glyph#[none]"
      tmux set -ga status-left "#[fg=$TMUX_CZ_LIGHT_GRAY]$(format_to_toggle_background_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)$left_separator_glyph#[none]"
      ;;
    * )
      tmux set -ga status-left "$({ format_to_swap_foreground_background_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY"; format_to_toggle_bold_by_client_prefix; } || true)${status_left_elements[$i]}#[none]"

      if (( i != ${#status_left_elements[@]} - 1 )); then
        tmux set -ga status-left "$({ format_to_toggle_foreground_color_by_client_prefix "$TMUX_CZ_DARK_GRAY" "$TMUX_CZ_LIGHT_GRAY"; format_to_toggle_background_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY"; } || true)$left_subseparator_glyph#[none]"
      fi
      ;;
  esac

  if (( i == ${#status_left_elements[@]} - 1 )); then
    tmux set -ga status-left "#[bg=$TMUX_CZ_LIGHT_BLACK]$(format_to_toggle_foreground_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)$left_separator_glyph#[none]"
  fi
done

for (( i = 0; i < ${#status_right_elements[@]}; i++ )); do
  if (( i == 0 )); then
    tmux set -ga status-right "#[fg=$TMUX_CZ_DARK_GRAY,bg=$TMUX_CZ_LIGHT_BLACK]$right_separator_glyph#[none]"
  fi

  case "${status_right_elements[$i]}" in
    TMUX_CZ_RIGHT_DECORATION )
      tmux set -ga status-right "#[fg=$TMUX_CZ_LIGHT_GRAY,bg=$TMUX_CZ_DARK_GRAY]$right_separator_glyph#[none]"
      tmux set -ga status-right "#[fg=$TMUX_CZ_YELLOW_GREEN,bg=$TMUX_CZ_LIGHT_GRAY]$right_separator_glyph#[none]"
      tmux set -ga status-right "#[fg=$TMUX_CZ_GREEN,bg=$TMUX_CZ_YELLOW_GREEN]$right_separator_glyph#[none]"
      tmux set -ga status-right "#[fg=$TMUX_CZ_ORANGE,bg=$TMUX_CZ_GREEN]$right_separator_glyph#[none]"
      ;;
    * )
      if (( i != 0 )); then
        tmux set -ga status-right "#[fg=$TMUX_CZ_LIGHT_GRAY,bg=$TMUX_CZ_DARK_GRAY]$right_subseparator_glyph#[none]"
      fi

      tmux set -ga status-right "#[fg=$TMUX_CZ_DARK_ORANGE,bg=$TMUX_CZ_DARK_GRAY]${status_right_elements[$i]}#[none]"
      ;;
  esac
done

# Set a large enough value to show all of contents of left and right status bars.
tmux set -g status-left-length 255
tmux set -g status-right-length 255
# }}}
# }}}
