#!/usr/bin/env bash

# Set useful shell options
set -Cueo pipefail

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

fetch_tmux_option () {
  local variable_name=$1

  tmux show-options -gv "$variable_name" 2>/dev/null
}
# }}}

# {{{ colors
# constants
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

# options
TMUX_CZ_STATUS_BACKGROUND_COLOUR=$(fetch_tmux_option @TMUX_CZ_STATUS_BACKGROUND_COLOUR || echo -n default)
# }}}

# {{{ status
# base color
tmux set -g status-style "bg=$TMUX_CZ_STATUS_BACKGROUND_COLOUR" || { tmux set -g status-bg "$TMUX_CZ_STATUS_BACKGROUND_COLOUR"; }
# }}}

# {{{ pane
tmux set -g pane-border-style "fg=$TMUX_CZ_DARK_GRAY" || { tmux set -g pane-border-fg "$TMUX_CZ_DARK_GRAY"; }
tmux set -g pane-active-border-style "fg=$TMUX_CZ_DARK_ORANGE" || { tmux set -g pane-active-border-fg "$TMUX_CZ_DARK_ORANGE"; }
# }}}

# {{{ mode
tmux set -g mode-style "fg=$TMUX_CZ_LIGHT_BLACK,bg=$TMUX_CZ_DARK_ORANGE" || { tmux set -g mode-fg "$TMUX_CZ_LIGHT_BLACK"; tmux set -g mode-bg "$TMUX_CZ_DARK_ORANGE"; }
# }}}

# {{{ message
tmux set -g message-command-style "fg=$TMUX_CZ_DARK_ORANGE" || { tmux set -g message-command-fg "$TMUX_CZ_DARK_ORANGE"; }
tmux set -g message-style "fg=$TMUX_CZ_DARK_ORANGE" || { tmux set -g message-fg "$TMUX_CZ_DARK_ORANGE"; }
# }}}

# {{{ display pane number
tmux set -g display-panes-colour "$TMUX_CZ_YELLOW_GREEN"
tmux set -g display-panes-active-colour "$TMUX_CZ_DARK_ORANGE"
# }}}

# parse user options {{{
# window-status / window-status-current
window_status_main_elements=()
window_status_sub_elements=()
window_status_current_main_elements=()
window_status_current_sub_elements=()
enable_default_window_status_main_elements=1
enable_default_window_status_sub_elements=1
enable_default_window_status_current_main_elements=1
enable_default_window_status_current_sub_elements=1

# status-left / status-right
status_left_elements=()
status_right_elements=()
enable_default_status_left_elements=1
enable_default_status_right_elements=1

left_decoration_format=$(fetch_tmux_option @TMUX_CZ_STATUS_LEFT_DECORATION || echo -n '#[reverse] #[noreverse]')
left_separator_format=$(fetch_tmux_option @TMUX_CZ_LEFT_SEPARATOR || echo -n '')
left_subseparator_format=$(fetch_tmux_option @TMUX_CZ_LEFT_SUBSEPARATOR || echo -n '|')
right_decoration_format=$(fetch_tmux_option @TMUX_CZ_STATUS_RIGHT_DECORATION || echo -n '#[reverse] #[noreverse]')
right_separator_format=$(fetch_tmux_option @TMUX_CZ_RIGHT_SEPARATOR || echo -n '')
right_subseparator_format=$(fetch_tmux_option @TMUX_CZ_RIGHT_SUBSEPARATOR || echo -n '|')

while read -r; do
  case "$REPLY" in
    @TMUX_CZ_WINDOW_STATUS_MAIN_ELEMENT_\ * )
      enable_default_window_status_main_elements=0
      ;;
    @TMUX_CZ_WINDOW_STATUS_MAIN_ELEMENT_* )
      window_status_main_elements+=("$(strip_quotations "${REPLY#@TMUX_CZ_WINDOW_STATUS_MAIN_ELEMENT_* }")")
      enable_default_window_status_main_elements=0
      ;;
    @TMUX_CZ_WINDOW_STATUS_SUB_ELEMENT_\ * )
      enable_default_window_status_sub_elements=0
      ;;
    @TMUX_CZ_WINDOW_STATUS_SUB_ELEMENT_* )
      window_status_sub_elements+=("$(strip_quotations "${REPLY#@TMUX_CZ_WINDOW_STATUS_SUB_ELEMENT_* }")")
      enable_default_window_status_sub_elements=0
      ;;
    @TMUX_CZ_WINDOW_STATUS_CURRENT_MAIN_ELEMENT_\ * )
      enable_default_window_status_current_main_elements=0
      ;;
    @TMUX_CZ_WINDOW_STATUS_CURRENT_MAIN_ELEMENT_* )
      window_status_current_main_elements+=("$(strip_quotations "${REPLY#@TMUX_CZ_WINDOW_STATUS_CURRENT_MAIN_ELEMENT_* }")")
      enable_default_window_status_current_main_elements=0
      ;;
    @TMUX_CZ_WINDOW_STATUS_CURRENT_SUB_ELEMENT_\ * )
      enable_default_window_status_current_sub_elements=0
      ;;
    @TMUX_CZ_WINDOW_STATUS_CURRENT_SUB_ELEMENT_* )
      window_status_current_sub_elements+=("$(strip_quotations "${REPLY#@TMUX_CZ_WINDOW_STATUS_CURRENT_SUB_ELEMENT_* }")")
      enable_default_window_status_current_sub_elements=0
      ;;
    @TMUX_CZ_STATUS_LEFT_ELEMENT_\ * )
      enable_default_status_left_elements=0
      ;;
    @TMUX_CZ_STATUS_LEFT_ELEMENT_* )
      status_left_elements+=("$(strip_quotations "${REPLY#@TMUX_CZ_STATUS_LEFT_ELEMENT_* }")")
      enable_default_status_left_elements=0
      ;;
    @TMUX_CZ_STATUS_RIGHT_ELEMENT_\ * )
      enable_default_status_right_elements=0
      ;;
    @TMUX_CZ_STATUS_RIGHT_ELEMENT_* )
      status_right_elements+=("$(strip_quotations "${REPLY#@TMUX_CZ_STATUS_RIGHT_ELEMENT_* }")")
      enable_default_status_right_elements=0
      ;;
    * )
      ;;
  esac
done < <(tmux show-options -g || true)

if (( enable_default_window_status_main_elements )); then
  window_status_main_elements=(
    ' #{window_name} '
  )
fi

if (( enable_default_window_status_sub_elements )); then
  window_status_sub_elements=(
    ' #{window_index}#{window_flags} '
  )
fi

if (( enable_default_window_status_current_main_elements )); then
  window_status_current_main_elements=(
    ' #{window_name} '
  )
fi

if (( enable_default_window_status_current_sub_elements )); then
  window_status_current_sub_elements=(
    ' #{window_index}#{window_flags} '
  )
fi

if (( enable_default_status_left_elements )); then
  status_left_elements=(
    TMUX_CZ_STATUS_LEFT_DECORATION
    ' #H [#S] '
  )
fi

if (( enable_default_status_right_elements )); then
  status_right_elements=(
    ' %H:%M '
    ' %Y-%m-%d(%a) '
    TMUX_CZ_STATUS_RIGHT_DECORATION
  )
fi
# }}}

# window-status-format {{{
tmux set -g window-status-format ''

if (( ${#window_status_sub_elements[@]} )); then
  tmux set -ga window-status-format "#[fg=$TMUX_CZ_LIGHT_GRAY,bg=default,reverse]$left_separator_format#[noreverse]#[none]"
fi

for (( i = 0; i < ${#window_status_sub_elements[@]}; i++ )); do
  if (( i != 0 )); then
    tmux set -ga window-status-format "#[fg=$TMUX_CZ_LIGHT_GRAY,bg=default,reverse]$left_subseparator_format#[noreverse]#[none]"
  fi

  tmux set -ga window-status-format "#[fg=$TMUX_CZ_WHITE,bg=$TMUX_CZ_LIGHT_GRAY]${window_status_sub_elements[i]}#[none]"
done

if (( ${#window_status_sub_elements[@]} && ${#window_status_main_elements[@]} )); then
  tmux set -ga window-status-format "#[fg=$TMUX_CZ_LIGHT_GRAY,bg=$TMUX_CZ_DARK_GRAY]$left_separator_format#[none]"
elif (( ${#window_status_sub_elements[@]} )); then
  tmux set -ga window-status-format "#[fg=$TMUX_CZ_LIGHT_GRAY,bg=default]$left_separator_format#[none]"
elif (( ${#window_status_main_elements[@]} )); then
  tmux set -ga window-status-format "#[fg=$TMUX_CZ_DARK_GRAY,bg=default,reverse]$left_separator_format#[noreverse]#[none]"
fi

for (( i = 0; i < ${#window_status_main_elements[@]}; i++ )); do
  if (( i != 0 )); then
    tmux set -ga window-status-format "#[fg=$TMUX_CZ_DARK_GRAY,bg=default,reverse]$left_subseparator_format#[noreverse]#[none]"
  fi

  tmux set -ga window-status-format "#[fg=$TMUX_CZ_WHITE,bg=$TMUX_CZ_DARK_GRAY]${window_status_main_elements[i]}#[none]"
done

if (( ${#window_status_main_elements[@]} )); then
  tmux set -ga window-status-format "#[fg=$TMUX_CZ_DARK_GRAY,bg=default]$left_separator_format#[none]"
fi
# }}}

# window-status-current-format {{{
tmux set -g window-status-current-format ''

if (( ${#window_status_current_sub_elements[@]} )); then
  tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_YELLOW_GREEN,bg=default,reverse]$left_separator_format#[noreverse]#[none]"
fi

for (( i = 0; i < ${#window_status_current_sub_elements[@]}; i++ )); do
  if (( i != 0 )); then
    tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_YELLOW_GREEN,bg=default,reverse]$left_subseparator_format#[noreverse]#[none]"
  fi

  tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_BLACK,bg=$TMUX_CZ_YELLOW_GREEN]${window_status_current_sub_elements[i]}#[none]"
done

if (( ${#window_status_current_sub_elements[@]} && ${#window_status_current_main_elements[@]} )); then
  tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_YELLOW_GREEN,bg=$TMUX_CZ_NAVAJO_WHITE]$left_separator_format#[none]"
elif (( ${#window_status_current_sub_elements[@]} )); then
  tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_YELLOW_GREEN,bg=default]$left_separator_format#[none]"
elif (( ${#window_status_current_main_elements[@]} )); then
  tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_NAVAJO_WHITE,bg=default,reverse]$left_separator_format#[noreverse]#[none]"
fi

for (( i = 0; i < ${#window_status_current_main_elements[@]}; i++ )); do
  if (( i != 0 )); then
    tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_NAVAJO_WHITE,bg=default,reverse]$left_subseparator_format#[noreverse]#[none]"
  fi

  tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_BLACK,bg=$TMUX_CZ_NAVAJO_WHITE]${window_status_current_main_elements[i]}#[none]"
done

if (( ${#window_status_current_main_elements[@]} )); then
  tmux set -ga window-status-current-format "#[fg=$TMUX_CZ_NAVAJO_WHITE,bg=default]$left_separator_format#[none]"
fi
# }}}

# status-left / status-right {{{
tmux set -g status-left ''
tmux set -g status-right ''

for (( i = 0; i < ${#status_left_elements[@]}; i++ )); do
  case "${status_left_elements[i]}" in
    TMUX_CZ_STATUS_LEFT_DECORATION )
      if (( i != 0 )); then
        tmux set -ga status-left "#[bg=$TMUX_CZ_ORANGE]$(format_to_toggle_foreground_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)$left_separator_format#[none]"
      fi

      tmux set -ga status-left "#[fg=$TMUX_CZ_ORANGE,bg=$TMUX_CZ_GREEN]$left_decoration_format#[none]"
      tmux set -ga status-left "#[fg=$TMUX_CZ_GREEN,bg=$TMUX_CZ_YELLOW_GREEN]$left_decoration_format#[none]"
      tmux set -ga status-left "#[fg=$TMUX_CZ_YELLOW_GREEN,bg=$TMUX_CZ_LIGHT_GRAY]$left_decoration_format#[none]"
      tmux set -ga status-left "#[fg=$TMUX_CZ_LIGHT_GRAY]$(format_to_toggle_background_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)$left_decoration_format#[none]"
      ;;
    * )
      if (( i != 0 )) && [[ ${status_left_elements[i - 1]} != TMUX_CZ_STATUS_LEFT_DECORATION ]]; then
        tmux set -ga status-left "$(format_to_toggle_foreground_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)#[bg=default,reverse]$left_subseparator_format#[noreverse]#[none]"
      fi

      tmux set -ga status-left "#[fg=$TMUX_CZ_DARK_ORANGE,bg=$TMUX_CZ_DARK_GRAY]#{?client_prefix,#[reverse]#[bold],}${status_left_elements[i]}#[noreverse]#[none]"
      ;;
  esac

  if (( i == ${#status_left_elements[@]} - 1 )); then
    tmux set -ga status-left "#[bg=default]$(format_to_toggle_foreground_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)$left_separator_format#[none]"
  fi
done

# status-left paddings
if (( ${#status_left_elements[@]} != 0 )); then
  if [[ -z $left_separator_format ]]; then
    tmux set -ga status-left '  '
  else
    tmux set -ga status-left ' '
  fi
fi

# status-right paddings
if (( ${#status_right_elements[@]} != 0 )); then
  if [[ -z $right_separator_format ]]; then
    tmux set -ga status-right '  '
  else
    tmux set -ga status-right ' '
  fi
fi

for (( i = 0; i < ${#status_right_elements[@]}; i++ )); do
  if (( i == 0 )); then
    tmux set -ga status-right "#[bg=default]$(format_to_toggle_foreground_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)$right_separator_format#[none]"
  fi

  case "${status_right_elements[i]}" in
    TMUX_CZ_STATUS_RIGHT_DECORATION )
      tmux set -ga status-right "#[fg=$TMUX_CZ_LIGHT_GRAY]$(format_to_toggle_background_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)$right_decoration_format#[none]"
      tmux set -ga status-right "#[fg=$TMUX_CZ_YELLOW_GREEN,bg=$TMUX_CZ_LIGHT_GRAY]$right_decoration_format#[none]"
      tmux set -ga status-right "#[fg=$TMUX_CZ_GREEN,bg=$TMUX_CZ_YELLOW_GREEN]$right_decoration_format#[none]"
      tmux set -ga status-right "#[fg=$TMUX_CZ_ORANGE,bg=$TMUX_CZ_GREEN]$right_decoration_format#[none]"

      if (( i != ${#status_right_elements[@]} - 1 )); then
        tmux set -ga status-right "#[bg=$TMUX_CZ_ORANGE]$(format_to_toggle_foreground_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)$right_separator_format#[none]"
      fi
      ;;
    * )
      if (( i != 0 )) && [[ ${status_right_elements[i - 1]} != TMUX_CZ_STATUS_RIGHT_DECORATION ]]; then
        tmux set -ga status-right "$(format_to_toggle_foreground_color_by_client_prefix "$TMUX_CZ_DARK_ORANGE" "$TMUX_CZ_DARK_GRAY" || true)#[bg=default,reverse]$right_subseparator_format#[noreverse]#[none]"
      fi

      tmux set -ga status-right "#[fg=$TMUX_CZ_DARK_ORANGE,bg=$TMUX_CZ_DARK_GRAY]#{?client_prefix,#[reverse]#[bold],}${status_right_elements[i]}#[none]"
      ;;
  esac
done

# Set a large enough value to show all of contents of left and right status bars.
tmux set -g status-left-length 255
tmux set -g status-right-length 255
# }}}
