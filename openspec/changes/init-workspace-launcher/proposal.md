## Why

为了解决每日开发时手动切换多个项目目录、重复启动 tmux session 并通过快捷键挂起的繁琐流程，需要建立一个轻量级、零依赖、工程化且具备高扩展性的开发工作区管理工具（Workspace Manager / Quicklaunch）。

通过声明式 Shell DSL 配置、模块化 Command Router 以及严格的组件函数作用域与代码规模约束，不仅能够一键恢复与管理所有预设工作区，还能为长期维护与 AI 智能体协作建立稳定整洁的工程范式。

## What Changes

- **函数式 Shell DSL 与并行数组模型**：采用 `workspace --name <name> --path <path> [--default]` 声明式 DSL，内部采用高可读的 Parallel Arrays 存储配置数据。
- **模块化代码结构与单入口约束**：
  - `bin/work` 作为主 Router 调度入口。
  - 各子命令独立存在于 `lib/commands/`，且每个模块严格仅暴露单一主入口函数（如 `cmd_status::run`、`cmd_doctor::run`）。
  - **文件规模约束**：所有逻辑模块文件严格控制在 100–150 行以内，杜绝臃肿脚本。
- **统一 UI 库与状态美化**：
  - 封装 `lib/ui.sh` 提供统一渲染接口（`ui::header`, `ui::ok`, `ui::warn`, `ui::error`, `ui::table`）。
  - `work status` 动态仪表盘增加默认主工作区专属视觉标记（`★`）。
- **完善的子命令集**：支持 `work` (恢复), `work status` (仪表盘), `work ls` (静态配置), `work attach` (交互), `work go` (默认进入), `work doctor` (环境诊断), `work config` (编辑配置)。
- **Tmux Context Sensing**：自动感知 shell 环境，区分执行 `tmux switch-client` 或 `tmux attach-session`。

## Capabilities

### New Capabilities
- `workspace-launcher`: 提供基于 Shell DSL 函数式配置、模块化 Command Router、严格文件规模约束及环境诊断能力的开发工作区管理工具。

### Modified Capabilities

## Impact

- **代码规范与维护**：所有 CLI 逻辑解耦为模块化脚本，全局作用域受控，便于 AI Agent (Claude Code / Codex / Antigravity) 及开发者精准维护。
- **用户环境配置**：配置文件存放在 `~/.config/quicklaunch/config.sh`；CLI 工具安装至 `~/.local/bin/work`。
- **外部依赖**：原生依赖 macOS Zsh 与 tmux；可选依赖 `fzf`。
