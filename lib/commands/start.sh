#!/usr/bin/env zsh
# lib/commands/start.sh - Restore all configured workspace sessions

cmd_start::run() {
  local total=${#_QL_WS_NAME[@]}
  local created_count=0
  local existing_count=0
  local failed_count=0

  echo ""
  ui::header "正在恢复开发工作区..."
  echo ""

  if [[ $total -eq 0 ]]; then
    ui::warn "未找到任何工作区配置，请运行 'work config' 添加。"
    return 0
  fi

  for (( i=1; i<=total; i++ )); do
    local name="${_QL_WS_NAME[$i]}"
    local target_path="${_QL_WS_PATH[$i]}"

    if ! utils::dir_exists "$target_path"; then
      ui::warn "目录不存在，跳过：$target_path ($name)"
      ((failed_count++))
      continue
    fi

    if tmux::has_session "$name"; then
      ui::ok "已存在：$name"
      ((existing_count++))
    else
      if tmux::new_session "$name" "$target_path"; then
        ui::ok "🆕 已创建：$name"
        ((created_count++))
      else
        ui::error "创建失败：$name"
        ((failed_count++))
      fi
    fi
  done

  echo ""
  echo "----------------------------------------"
  echo "创建: ${created_count} | 已存在: ${existing_count} | 失败: ${failed_count}"
  echo "----------------------------------------"
  echo ""
}
