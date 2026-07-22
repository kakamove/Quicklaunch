#!/usr/bin/env zsh
# lib/ui.sh - Terminal formatting & UI helpers

# ANSI Color codes
_QL_COLOR_RESET="\033[0m"
_QL_COLOR_BOLD="\033[1m"
_QL_COLOR_GREEN="\033[32m"
_QL_COLOR_YELLOW="\033[33m"
_QL_COLOR_RED="\033[31m"
_QL_COLOR_CYAN="\033[36m"
_QL_COLOR_DIM="\033[2m"

ui::header() {
  local msg="$1"
  echo -e "${_QL_COLOR_BOLD}${_QL_COLOR_CYAN}🚀 ${msg}${_QL_COLOR_RESET}"
}

ui::ok() {
  local msg="$1"
  echo -e "${_QL_COLOR_GREEN}✅ ${msg}${_QL_COLOR_RESET}"
}

ui::warn() {
  local msg="$1"
  echo -e "${_QL_COLOR_YELLOW}⚠️  ${msg}${_QL_COLOR_RESET}"
}

ui::error() {
  local msg="$1"
  echo -e "${_QL_COLOR_RED}❌ ${msg}${_QL_COLOR_RESET}"
}

ui::dim() {
  local msg="$1"
  echo -e "${_QL_COLOR_DIM}${msg}${_QL_COLOR_RESET}"
}

# Simple table formatter using column or printf
# Arguments: headers_string, rows_array_ref
ui::table() {
  local headers="$1"
  shift
  local rows=("$@")

  {
    echo -e "${_QL_COLOR_BOLD}${headers}${_QL_COLOR_RESET}"
    for row in "${rows[@]}"; do
      echo -e "$row"
    done
  } | column -t -s $'\t' 2>/dev/null || {
    # Fallback if column command fails
    echo "$headers"
    for row in "${rows[@]}"; do
      echo "$row"
    done
  }
}
