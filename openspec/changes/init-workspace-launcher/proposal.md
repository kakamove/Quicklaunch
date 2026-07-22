## Why

为了解决每日开发时手动切换多个项目目录、重复启动 tmux session 并通过快捷键挂起的繁琐流程，需要建立一个轻量级、零依赖、模块化且具备幂等性的开发工作区管理工具（Workspace Manager / Quicklaunch）。

通过声明式 Shell DSL 配置与模块化 CLI 命令路由，不仅能一键恢复与管理所有预设的工作区 session，还能为未来拓展项目组、IDE 与 AI 上下文恢复奠定清晰坚固的架构基础。

## What Changes

- **函数式 Shell DSL 配置**：将配置提升为声明式 `workspace` 函数调用语法，支持 `--name`, `--path`, `--default` 等扩展参数，为未来扩展 `--group`, `--icon` 等属性预留结构空间。
- **模块化 CLI 目录结构与 Command Router**：
  - `bin/work` 作为主入口与 Command Router。
  - `lib/commands/` 下拆分子命令独立脚本（`start`, `status`, `ls`, `attach`, `go`, `doctor`, `config`）。
  - `lib/` 下拆分基础组件（`config.sh`, `tmux.sh`, `ui.sh`, `utils.sh`），便于 AI 与人类开发者精确定位与维护。
- **子命令能力增强与扩充**：
  - `work` / `work start`：静默恢复全部工作区 session。
  - `work ls`：列出声明配置的工作区清单。
  - `work status`：输出包含运行状态、窗口数量（Windows Count）、Attach 标志的高级状态面板。
  - `work attach`：交互式进入 session（内置 `fzf` 搜索与 Zsh `select` 原生菜单平滑降级）。
  - `work go`：直接进入标记为 `--default` 的主工作区。
  - `work doctor`：提供环境诊断能力（校验 tmux, zsh, PATH, editor, fzf, config 及工作区目录有效性）。
  - `work config`：通过 `${EDITOR:-vim}` 编辑配置文件。
- **Tmux Context Sensing**：自动处理 tmux 内部（`switch-client`）与外部（`attach-session`）的进入逻辑。

## Capabilities

### New Capabilities
- `workspace-launcher`: 提供基于 Shell DSL 函数式配置、模块化 Command Router 及环境诊断功能的开发工作区管理工具。

### Modified Capabilities

## Impact

- **项目目录结构**：创建包含 `bin/work` 和 `lib/`（`commands/` 与核心公共组件）的模块化源码目录。
- **用户环境配置**：配置文件存放在 `~/.config/quicklaunch/config.sh`，可加载 `workspace` 函数 DSL；CLI 挂载至 `~/.local/bin/work`。
- **外部依赖**：原生依赖 macOS Zsh 与 tmux；可选依赖 `fzf`。
