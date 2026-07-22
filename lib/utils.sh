#!/usr/bin/env zsh
# lib/utils.sh - Path and Utility Functions

utils::expand_path() {
  local target="$1"
  echo "${target/#\~/$HOME}"
}

utils::dir_exists() {
  local target="$1"
  [[ -d "$target" ]]
}

utils::command_exists() {
  local cmd="$1"
  command -v "$cmd" >/dev/null 2>&1
}

utils::find_index_by_name() {
  local search_name="$1"
  local total=${#_QL_WS_NAME[@]}
  for (( i=1; i<=total; i++ )); do
    if [[ "${_QL_WS_NAME[$i]}" == "$search_name" ]]; then
      echo "$i"
      return 0
    fi
  done
  echo "0"
  return 1
}

utils::get_default_index() {
  local total=${#_QL_WS_IS_DEFAULT[@]}
  for (( i=1; i<=total; i++ )); do
    if [[ "${_QL_WS_IS_DEFAULT[$i]}" -eq 1 ]]; then
      echo "$i"
      return 0
    fi
  done
  echo "0"
  return 1
}
