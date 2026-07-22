#!/usr/bin/env zsh
# lib/commands/config.sh - Open/edit configuration file

cmd_config::run() {
  if [[ ! -f "$_QL_CONFIG_FILE" ]]; then
    config::init_default
    ui::ok "初始化创建配置文件: $_QL_CONFIG_FILE"
  fi

  local editor="${EDITOR:-vim}"
  ui::ok "使用 $editor 打开配置文件..."
  "$editor" "$_QL_CONFIG_FILE"
}
