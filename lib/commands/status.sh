#!/usr/bin/env zsh
# lib/commands/status.sh - Operational status dashboard

cmd_status::run() {
  local total=${#_QL_WS_NAME[@]}
  local rows=()

  echo ""
  ui::header "工作区运行状态仪表盘 (${total} 个工作区)"
  echo ""

  if [[ $total -eq 0 ]]; then
    ui::warn "当前未配置任何工作区。"
    return 0
  fi

  for (( i=1; i<=total; i++ )); do
    local name="${_QL_WS_NAME[$i]}"
    local target_path="${_QL_WS_PATH[$i]}"
    local is_def="${_QL_WS_IS_DEFAULT[$i]}"
    local def_mark=" "
    local ws_status="Stopped"
    local win_count="-"
    local attached="-"

    if [[ "$is_def" -eq 1 ]]; then
      def_mark="★"
    fi

    if tmux::has_session "$name"; then
      ws_status="● Running"
      win_count=$(tmux::get_windows_count "$name")

      if tmux::is_current_session "$name"; then
        attached="(current)"
      elif tmux::is_attached "$name"; then
        attached="Attached"
      fi
    fi

    rows+=("${def_mark}\t${name}\t${target_path}\t${ws_status}\t${win_count}\t${attached}")
  done

  ui::table "DEFAULT\tNAME\tPATH\tSTATUS\tWINDOWS\tATTACHED" "${rows[@]}"
  echo ""
  ui::dim "提示: 运行 'work attach' 或 'work <name>' 可快速切入指定 Session。"
  echo ""
}
