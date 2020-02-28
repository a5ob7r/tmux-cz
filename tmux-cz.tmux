#!/usr/bin/env bash

readonly CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

main() {
  # shellcheck source=tmux-cz.sh
  source "${CURRENT_DIR}/tmux-cz.sh"
}

main
