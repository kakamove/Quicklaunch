#!/usr/bin/env zsh
# lib/config.sh - Shell DSL Parser and Configuration Manager

typeset -g -a _QL_WS_NAME=()
typeset -g -a _QL_WS_PATH=()
typeset -g -a _QL_WS_IS_DEFAULT=()
typeset -g _QL_CONFIG_FILE="${HOME}/.config/quicklaunch/config.sh"

# Shell DSL Function: workspace --name <name> --path <path> [--default]
workspace() {
  local name=""
  local ws_path=""
  local is_default=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --name)
        name="$2"
        shift 2
        ;;
      --path)
        ws_path="$2"
        shift 2
        ;;
      --default)
        is_default=1
        shift 1
        ;;
      *)
        shift 1
        ;;
    esac
  done

  if [[ -n "$name" && -n "$ws_path" ]]; then
    ws_path="${ws_path/#\~/$HOME}"
    _QL_WS_NAME+=("$name")
    _QL_WS_PATH+=("$ws_path")
    _QL_WS_IS_DEFAULT+=("$is_default")
  fi
}

config::load() {
  _QL_WS_NAME=()
  _QL_WS_PATH=()
  _QL_WS_IS_DEFAULT=()

  if [[ ! -f "$_QL_CONFIG_FILE" ]]; then
    config::init_default
  fi

  if [[ -f "$_QL_CONFIG_FILE" ]]; then
    source "$_QL_CONFIG_FILE"
  fi
}

config::init_default() {
  local config_dir="${_QL_CONFIG_FILE:h}"
  mkdir -p "$config_dir" 2>/dev/null

  if [[ -f "${_QL_APP_ROOT}/config/config.sh" ]]; then
    cp "${_QL_APP_ROOT}/config/config.sh" "$_QL_CONFIG_FILE"
  fi
}
