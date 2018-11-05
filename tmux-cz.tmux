#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

main() {
  local theme='cz'
  tmux source-file "$CURRENT_DIR"/tmux.$theme.conf
}

main
