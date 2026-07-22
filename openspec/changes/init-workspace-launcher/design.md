## Context

为了将 Quicklaunch / Workspace Manager 打造成长期可维护、高模块化且高度适配 AI 智能体（Claude Code / Codex / Antigravity）协作演进的命令行工具，在现有架构的基础上引入**单入口函数标准（Single Entrypoint Function Standard）**与**严格的文件规模约束（Strict Module Size Boundary）**，进一步精细化 UI 渲染库与 Parallel Arrays 数据模型。

## Goals / Non-Goals

**Goals:**
- **单入口函数约束**：所有 `lib/commands/<subcommand>.sh` 模块仅暴露一个公共函数 `cmd_<subcommand>::run "$@"`，保护作用域隔离。
- **模块行数上限**：单个源文件严格限制在 100–150 行以内。若单个功能增长过大，须拆分为细粒度模块组件。
- **统一 UI 函数库 (`lib/ui.sh`)**：收拢所有终端打印与表格格式化逻辑（`ui::header`, `ui::ok`, `ui::warn`, `ui::error`, `ui::table`）。
- **Parallel Arrays 数据结构**：在 `lib/config.sh` 内使用并行的有序数组存储配置项（`_QL_WS_NAME`, `_QL_WS_PATH`, `_QL_WS_IS_DEFAULT`），易于索引且便于追加新参数。
- **状态面板美化**：`work status` 中为默认工作区添加专属图标标记（`★`）。

**Non-Goals:**
- v1 暂不解析 YAML / JSON 文件。
- v1 暂不做 Git 静默状态检查与拉取。
- v1 暂不触发 Xcode / AI 会话 Profile 组划分（留待 v2 演进）。

## Architecture & Code Boundaries

```
Quicklaunch/
├── bin/
│   └── work               # CLI 入口与 Command Router (调用 cmd_<subcommand>::run)
│
├── lib/
│   ├── commands/          # 子命令核心处理逻辑 (单个文件 < 150 行)
│   │   ├── attach.sh      # cmd_attach::run
│   │   ├── config.sh      # cmd_config::run
│   │   ├── doctor.sh      # cmd_doctor::run
│   │   ├── go.sh          # cmd_go::run
│   │   ├── ls.sh          # cmd_ls::run
│   │   ├── start.sh       # cmd_start::run
│   │   └── status.sh      # cmd_status::run
│   │
│   ├── config.sh          # DSL 解析引擎 & Parallel Arrays 管理
│   ├── tmux.sh            # Tmux 操作库 (has, new, switch/attach)
│   ├── ui.sh              # 统一 UI 库 (ui::header, ui::ok, ui::table ...)
│   └── utils.sh           # 通用路径扩展与基础工具
│
└── config/
    └── config.sh          # 用户配置文件模版
```

## Engineering Design & Refinements

### 1. 模块单公共入口规范 (Single Entrypoint Convention)
- **设计**：`bin/work` 解析完子命令（例如 `status`）后，`source "$LIB_DIR/commands/status.sh"` 并仅调用 `cmd_status::run "$@"`。
- **优势**：消除了局部变量污染主 Shell 环境的风险；使 AI Agent 和单元测试能极度精准地定位入口和上下文。

### 2. UI 渲染封装 (`lib/ui.sh`)
- **设计**：禁止在子命令逻辑中散落原始 `echo` / `printf`。统一通过 `ui::` 函数输出：
  - `ui::header "标题"`
  - `ui::ok "成功信息"`
  - `ui::warn "警告信息"`
  - `ui::error "错误信息"`
  - `ui::table "列名列表" "数据行列表"`

### 3. Parallel Arrays 配置结构
- **设计**：
  ```zsh
  typeset -g -a _QL_WS_NAME=()
  typeset -g -a _QL_WS_PATH=()
  typeset -g -a _QL_WS_IS_DEFAULT=()
  ```
  在 `workspace` 函数执行时追加数组项，遍历使用标准 `$i` 索引访问。

### 4. `work status` 增加默认工作区标记
- **设计**：在渲染状态表格时，若当前工作区为默认工作区（`_QL_WS_IS_DEFAULT[$i] == 1`），在 `NAME` 前自动附带 `★` 标识。

## Risks / Trade-offs

- **[Risk]** 行数限制导致模块过度拆分。
  - *Mitigation*: 100–150 行边界对目前各子命令已极其充裕；对于复杂辅助逻辑（如 tmux 命令包装），自然收拢于 `lib/tmux.sh`，保证各司其职。
