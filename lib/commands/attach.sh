#!/usr/bin/env zsh
# lib/commands/attach.sh - Interactive or direct session attachment

cmd_attach::run() {
  local target="${1:-}"

  # If target session specified directly
  if [[ -n "$target" ]]; then
    _attach_to_named_session "$target"
    return $?
  fi

  # Interactive selection
  local total=${#_QL_WS_NAME[@]}
  if [[ $total -eq 0 ]]; then
    ui::warn "没有可用的工作区配置。"
    return 1
  fi

  local selected=""
  if utils::command_exists fzf; then
    selected=$(_select_with_fzf)
  else
    selected=$(_select_with_shell_select)
  fi

  if [[ -n "$selected" ]]; then
    _attach_to_named_session "$selected"
  else
    ui::dim "未选中任何工作区。"
  fi
}

_select_with_fzf() {
  local items=()
  local total=${#_QL_WS_NAME[@]}
  for (( i=1; i<=total; i++ )); do
    local name="${_QL_WS_NAME[$i]}"
    local target_path="${_QL_WS_PATH[$i]}"
    local ws_status="Stopped"
    if tmux::has_session "$name"; then
      ws_status="Running"
    fi
    items+=("${name}\t[${ws_status}]\t${target_path}")
  done

  printf "%s\n" "${items[@]}" | fzf --height 40% --reverse --prompt="Select Workspace > " | awk '{print $1}'
}

_select_with_shell_select() {
  ui::header "请选择要切入的工作区："
  local options=("${_QL_WS_NAME[@]}")
  local opt
  PS3="输入序号 [1-${#options[@]}]: "
  select opt in "${options[@]}"; do
    if [[ -n "$opt" ]]; then
      echo "$opt"
      return 0
    fi
  done
}

_attach_to_named_session() {
  local name="$1"
  local idx
  idx=$(utils::find_index_by_name "$name")

  if [[ "$idx" -eq 0 ]]; then
    # Try direct attach if session exists anyway
    if tmux::has_session "$name"; then
      tmux::attach_or_switch "$name"
      return 0
    fi
    ui::error "未知的工作区名称或 Session: $name"
    return 1
  fi

  local target_path="${_QL_WS_PATH[$idx]}"

  if ! tmux::has_session "$name"; then
    if ! utils::dir_exists "$target_path"; then
      ui::error "工作区目录不存在：$target_path"
      return 1
    fi
    ui::ok "正在自动创建并开启 Session: $name"
    tmux::new_session "$name" "$target_path"
  fi

  tmux::attach_or_switch "$name"
}
