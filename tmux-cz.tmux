#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

main() {
  local theme='cz'

  # shellcheck source=/dev/null
  source "$CURRENT_DIR"/tmux-$theme.sh
}

main
