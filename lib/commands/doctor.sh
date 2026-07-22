#!/usr/bin/env zsh
# lib/commands/doctor.sh - Environment Health Diagnostics

cmd_doctor::run() {
  local warnings_count=0

  echo ""
  ui::header "Quicklaunch (Workspace Manager) 环境健康诊断"
  echo "--------------------------------------------------------"

  # 1. Check tmux
  if utils::command_exists tmux; then
    local tmux_ver
    tmux_ver=$(tmux -V 2>/dev/null)
    ui::ok "tmux: $tmux_ver 已安装"
  else
    ui::error "tmux: 未安装。请运行 'brew install tmux' 安装。"
    ((warnings_count++))
  fi

  # 2. Check Zsh
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    ui::ok "zsh: 版本 $ZSH_VERSION"
  else
    ui::warn "zsh: 未检测到 Zsh 环境 (当前 SHELL: ${SHELL:-unknown})"
  fi

  # 3. Check PATH
  if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
    ui::ok "PATH: 已注入 $HOME/.local/bin"
  else
    ui::warn "PATH: 环境变量未包含 $HOME/.local/bin (建议加入 ~/.zshrc)"
    ((warnings_count++))
  fi

  # 4. Check Config file
  if [[ -f "$_QL_CONFIG_FILE" ]]; then
    ui::ok "config: 配置文件正常 ($_QL_CONFIG_FILE)"
  else
    ui::warn "config: 配置文件尚未创建，执行 'work' 将自动生成模版"
  fi

  # 5. Check Workspaces directories
  local total=${#_QL_WS_NAME[@]}
  local missing_dirs=0
  for (( i=1; i<=total; i++ )); do
    local target_path="${_QL_WS_PATH[$i]}"
    if ! utils::dir_exists "$target_path"; then
      ui::warn "  - 缺失工作区目录: ${_QL_WS_NAME[$i]} -> $target_path"
      ((missing_dirs++))
    fi
  done
  if [[ $missing_dirs -eq 0 && $total -gt 0 ]]; then
    ui::ok "workspaces: 所有已声明的 $total 个工作区目录全员有效"
  elif [[ $missing_dirs -gt 0 ]]; then
    ((warnings_count++))
  fi

  # 6. Check fzf
  if utils::command_exists fzf; then
    ui::ok "fzf: 已安装 (支持交互模糊搜索)"
  else
    ui::warn "fzf: 未安装 (将自动平滑降级为 Zsh 原生 select 菜单)"
  fi

  # 7. Check Editor
  local editor="${EDITOR:-vim}"
  if utils::command_exists "$editor"; then
    ui::ok "editor: \$EDITOR 已设为 $editor"
  else
    ui::warn "editor: 默认编辑器 $editor 命令不存在"
  fi

  echo "--------------------------------------------------------"
  if [[ $warnings_count -eq 0 ]]; then
    ui::ok "所有核心项健康度良好！随时可以开启流畅工作体验。"
  else
    ui::warn "检测到 $warnings_count 项可优化警告，可根据排查提示进行微调。"
  fi
  echo ""
}
