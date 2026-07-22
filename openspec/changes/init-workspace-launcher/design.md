## Context

针对原本缺乏模块化与配置可扩展性的单文件脚本方案，本设计提出了一个模块化、高可拓展且易于 AI / 人类维护的开发工作区管理架构（Quicklaunch / Workspace Manager）。通过拆分命令路由、基础设施组件与函数式 Shell DSL 配置，为长期演进至多项目组管理、IDE 联动及 AI 上下文恢复建立清晰的基础设施。

## Goals / Non-Goals

**Goals:**
- **模块化代码结构**：入口 `bin/work` 仅负责 Router 分发，各子命令拆分至 `lib/commands/`，核心抽象独立为 `lib/` 基础模块。
- **函数式 Shell DSL 配置**：采用 `workspace --name <name> --path <path> [--default]` 函数调用形式，具备极高的开闭原则（OCP）拓展性。
- **完善的命令体系**：包含 `start`, `status`, `ls`, `attach`, `go`, `doctor`, `config` 子命令。
- **环境诊断与自愈能力**：内置 `work doctor`，快速定位 `tmux`, `PATH`, 配置合法性与缺失路径。
- **平滑降级与无缝切换**：兼容 `fzf` 搜索与原生 `select` 菜单，处理 Tmux 嵌套切换（`switch-client` vs `attach-session`）。

**Non-Goals:**
- v1 暂不解析 YAML / JSON 配置。
- v1 暂不开启 Git 状态自动检查与静默拉取。
- v1 暂不自动化触发 Xcode / IDE / AI 会话启动 Hook。

## Architecture & Directory Structure

```
Quicklaunch/
├── bin/
│   └── work               # CLI 入口与 Command Router
│
├── lib/
│   ├── commands/          # 子命令独立处理逻辑
│   │   ├── attach.sh      # 交互式切换
│   │   ├── config.sh      # 打开/编辑配置
│   │   ├── doctor.sh      # 环境健康检查
│   │   ├── go.sh          # 进入默认工作区
│   │   ├── ls.sh          # 列出静态配置工作区
│   │   ├── start.sh       # 恢复/启动全部 session
│   │   └── status.sh      # 丰富运行仪表盘
│   │
│   ├── config.sh          # DSL 解析引擎与变量加载
│   ├── tmux.sh            # Tmux 交互封装 (has-session, new, switch/attach)
│   ├── ui.sh              # 终端表格渲染、颜色与 fzf/select 菜单
│   └── utils.sh           # 日志输出、路径处理与通用工具
│
└── config/
    └── config.sh          # 用户配置文件模版/预设配置
```

## Decisions

### 1. 升级为函数式 Shell DSL (`workspace --name ...`)
- **设计**：在 `lib/config.sh` 中定义 `workspace()` 函数，通过 `zparseopts` 或参数循环解析 `--name`, `--path`, `--default` 等 Flags，存储至结构化临时数组或关联数组中。
- **优势**：未来新增 `--group`, `--icon`, `--favorite`, `--note` 等字段时，无须修改核心 Parser 逻辑，保持向下兼容。

### 2. 解耦 Command Router 与子命令模块
- **设计**：`bin/work` 仅负责环境初始化、配置 `source` 加载与子命令匹配（如 `start`, `status`, `ls`, `attach`, `go`, `doctor`, `config`），然后将控制权交由对应 `lib/commands/<subcommand>.sh`。
- **优势**：任何子命令功能的修改均被限制在单独的小文件中，大大提高了代码可读性，并且极大方便了 AI agent（如 Claude Code, Codex）精准定位和微调代码。

### 3. 区分静态列表 `work ls` 与动态仪表盘 `work status`
- **设计**：
  - `work ls`：快速解析 `config.sh` 并打印配置的工作区名字、路径与默认标记（不查询 tmux 状态，零延迟）。
  - `work status`：整合配置与 `tmux list-sessions` 实时数据，打印包含 `NAME`, `PATH`, `STATUS`, `WINDOWS`, `ATTACHED` 的多列状态面板。

### 4. 引入 `work doctor` 环境诊断命令
- **设计**：依次检查：
  - `✓ tmux` (版本与命令可用性)
  - `✓ zsh` (当前 Shell 环境)
  - `✓ PATH` (是否注入 `~/.local/bin`)
  - `✓ config` (配置文件是否存在且可被正确加载)
  - `✓ workspaces` (每个工作区的目录是否存在)
  - `✓ fzf` (交互选择器可用性，不可用时提示将自动降级)
  - `✓ editor` (`$EDITOR` 变量状态)

## Risks / Trade-offs

- **[Risk]** 在 Zsh 中重重加载 `workspace` 函数定义可能污染全局 Shell 命名空间。
  - *Mitigation*: 限制所有全局辅助变量均添加 `_QL_` 或 `_QUICKLAUNCH_` 前缀，并在子 Shell 执行环境中隔离或清理。
- **[Risk]** 多文件拆分增加包含文件（`source`）的开销。
  - *Mitigation*: 仅在 CLI 运行时按需加载必要的 `lib/` 组件，保持总体启动时间 < 10ms。
