tmux_variable_value() {
  local -r TMUX_VARIABLE_NAME="${1}"

  tmux show -gqv "${TMUX_VARIABLE_NAME}"
}

color_font() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"
  local -r FONT="${3}"

  if [[ -z ${FG_COLOR} && -z ${BG_COLOR} ]]; then
    echo -e "#[default]${FONT}"
    return
  fi

  if [[ -z ${FG_COLOR} ]]; then
    echo -e "#[default]#[bg=${BG_COLOR}]${FONT}"
    return
  fi

  if [[ -z ${BG_COLOR} ]]; then
    echo -e "#[default]#[fg=${FG_COLOR}]${FONT}"
    return
  fi

  echo -e "#[fg=${FG_COLOR}]#[bg=${BG_COLOR}]${FONT}"
}

base_decoration() {
  local -r FG_COLOR="${1}"
  local BG_COLOR="${2}"
  local -r PRIORITY_COLOR="${3}"
  local -r TMUX_VARIABLE_NAME="${4}"
  local -r DEFAULT_FONT="${5}"

  local FONT
  FONT="$(tmux_variable_value "${TMUX_VARIABLE_NAME}")"

  if [[ -z "${FONT}" ]]; then
    FONT="${DEFAULT_FONT}"
    BG_COLOR="${PRIORITY_COLOR}"
  fi

  color_font "${FG_COLOR}" "${BG_COLOR}" "${FONT}"
}

decoration() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"
  local -r PRIORITY_COLOR="${3}"
  local -r TMUX_VARIABLE_NAME="${4}"

  local -r DEFAULT_FONT=' '

  base_decoration "${FG_COLOR}" "${BG_COLOR}" "${PRIORITY_COLOR}" "${TMUX_VARIABLE_NAME}" "${DEFAULT_FONT}"
}

left_decoration() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"
  local -r PRIORITY_COLOR="${3}"

  local -r TMUX_VARIABLE_NAME='@TMUX_CZ_LEFT_DECORATION'

  decoration "${FG_COLOR}" "${BG_COLOR}" "${PRIORITY_COLOR}" "${TMUX_VARIABLE_NAME}"
}

right_decoration() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"
  local -r PRIORITY_COLOR="${3}"

  local -r TMUX_VARIABLE_NAME='@TMUX_CZ_RIGHT_DECORATION'

  decoration "${FG_COLOR}" "${BG_COLOR}" "${PRIORITY_COLOR}" "${TMUX_VARIABLE_NAME}"
}

left_decoration_inflation() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"

  left_decoration "${FG_COLOR}" "${BG_COLOR}" "${FG_COLOR}"
}

right_decoration_inflation() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"

  right_decoration "${FG_COLOR}" "${BG_COLOR}" "${FG_COLOR}"
}

left_decoration_deflation() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"

  left_decoration "${FG_COLOR}" "${BG_COLOR}" "${BG_COLOR}"
}

right_decoration_deflation() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"

  right_decoration "${FG_COLOR}" "${BG_COLOR}" "${BG_COLOR}"
}

separator() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"
  local -r PRIORITY_COLOR="${3}"
  local -r TMUX_VARIABLE_NAME="${4}"

  local -r DEFAULT_FONT=''

  base_decoration "${FG_COLOR}" "${BG_COLOR}" "${PRIORITY_COLOR}" "${TMUX_VARIABLE_NAME}" "${DEFAULT_FONT}"
}

left_separator() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"

  separator "${FG_COLOR}" "${BG_COLOR}" "${BG_COLOR}" "@TMUX_CZ_LEFT_SEPARATOR"
}

right_separator() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"

  separator "${FG_COLOR}" "${BG_COLOR}" "${BG_COLOR}" "@TMUX_CZ_RIGHT_DECORATION"
}

subseparator() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"
  local -r PRIORITY_COLOR="${3}"
  local -r TMUX_VARIABLE_NAME="${4}"

  local -r DEFAULT_FONT='|'

  base_decoration "${FG_COLOR}" "${BG_COLOR}" "${PRIORITY_COLOR}" "${TMUX_VARIABLE_NAME}" "${DEFAULT_FONT}"
}

left_subseparator() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"

  subseparator "${FG_COLOR}" "${BG_COLOR}" "${BG_COLOR}" "@TMUX_CZ_LEFT_SUBSEPARATOR"
}

right_subseparator() {
  local -r FG_COLOR="${1}"
  local -r BG_COLOR="${2}"

  subseparator "${FG_COLOR}" "${BG_COLOR}" "${BG_COLOR}" "@TMUX_CZ_RIGHT_SUBSEPARATOR"
}
