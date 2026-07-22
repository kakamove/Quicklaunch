#!/usr/bin/env zsh
# lib/commands/ls.sh - List static workspace configuration

cmd_ls::run() {
  local total=${#_QL_WS_NAME[@]}
  local rows=()

  echo ""
  ui::header "工作区静态配置列表 (${total} 个)"
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

    if [[ "$is_def" -eq 1 ]]; then
      def_mark="★"
    fi

    rows+=("${def_mark}\t${name}\t${target_path}")
  done

  ui::table "DEFAULT\tNAME\tPATH" "${rows[@]}"
  echo ""
}
