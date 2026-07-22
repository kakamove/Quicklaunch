#!/usr/bin/env zsh
# lib/tmux.sh - Tmux wrapper functions and context awareness

tmux::has_session() {
  local session_name="$1"
  tmux has-session -t "=$session_name" 2>/dev/null
}

tmux::new_session() {
  local session_name="$1"
  local target_path="$2"
  tmux new-session -d -s "$session_name" -c "$target_path" 2>/dev/null
}

tmux::attach_or_switch() {
  local session_name="$1"
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$session_name"
  else
    tmux attach-session -t "$session_name"
  fi
}

tmux::get_windows_count() {
  local session_name="$1"
  local count
  count=$(tmux list-windows -t "=$session_name" 2>/dev/null | wc -l | tr -d ' ')
  if [[ -n "$count" && "$count" -gt 0 ]]; then
    echo "$count"
  else
    echo "0"
  fi
}

tmux::is_attached() {
  local session_name="$1"
  local attached_info
  attached_info=$(tmux list-sessions 2>/dev/null | grep "^${session_name}:" | grep "(attached)")
  if [[ -n "$attached_info" ]]; then
    return 0
  else
    return 1
  fi
}

tmux::is_current_session() {
  local session_name="$1"
  if [[ -n "${TMUX:-}" ]]; then
    local current_session
    current_session=$(tmux display-message -p '#S' 2>/dev/null)
    [[ "$current_session" == "$session_name" ]]
  else
    return 1
  fi
}
