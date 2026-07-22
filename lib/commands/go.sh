#!/usr/bin/env zsh
# lib/commands/go.sh - Jump directly to default workspace

cmd_go::run() {
  local idx
  idx=$(utils::get_default_index)

  if [[ "$idx" -gt 0 ]]; then
    local default_name="${_QL_WS_NAME[$idx]}"
    ui::ok "跳转至默认工作区: $default_name"
    cmd_attach::run "$default_name"
  else
    ui::warn "未设置默认工作区 (--default)，转至交互式选择列表："
    cmd_attach::run
  fi
}
