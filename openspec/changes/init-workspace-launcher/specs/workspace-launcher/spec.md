## ADDED Requirements

### Requirement: Declarative Function-based Shell DSL
系统 SHALL 支持通过 Zsh 函数式 DSL（`workspace --name <name> --path <path> [--default]`）解析与存储工作区配置，并预留未定义参数的解析容错性。

#### Scenario: 解析标准工作区 DSL
- **GIVEN** `~/.config/quicklaunch/config.sh` 中包含 `workspace --name petgugu --path ~/Developer/PetGuGu --default`
- **WHEN** 执行 `work` 或 `work ls` 加载配置
- **THEN** 系统 SHALL 识别 `name` 为 `petgugu`、`path` 为展开后的绝对路径，并将该工作区标记为默认工作区

#### Scenario: 未指定配置文件时自动创建模板
- **GIVEN** `~/.config/quicklaunch/config.sh` 不存在
- **WHEN** 运行任意 `work` 命令
- **THEN** 系统 SHALL 在该路径下生成带有 `workspace` 函数定义与示例配置的默认模版

### Requirement: Modular Subcommand Dispatching
系统 `bin/work` 必须作为轻量 Command Router，将子命令解耦分发至 `lib/commands/` 目录下的独立脚本文件。

#### Scenario: 路由至已知子命令
- **GIVEN** 用户输入 `work status`
- **WHEN** `bin/work` 路由解析命令
- **THEN** 系统 SHALL 调度加载 `lib/commands/status.sh` 执行逻辑

#### Scenario: 未知子命令处理
- **GIVEN** 用户输入未定义的子命令（如 `work foo`）
- **WHEN** `bin/work` 尝试路由
- **THEN** 系统 SHALL 匹配是否为已定义的工作区名称；若非工作区名称，则输出帮助信息与有效命令列表

### Requirement: Idempotent Session Restoration
系统 SHALL 遍历解析后的工作区定义，使用 `tmux new-session -d -s "$name" -c "$path"` 静默恢复不存在的 session，对已存在的 session 保持幂等跳过。

#### Scenario: 静默创建新 Session
- **GIVEN** 配置中声明了 `petgugu` 且对应 tmux session 未运行
- **WHEN** 执行 `work` 或 `work start`
- **THEN** 系统 SHALL 后台静默创建 session 并在终端提示 "🆕 已创建：petgugu"

#### Scenario: 存在 Session 跳过
- **GIVEN** `petgugu` session 已处于运行状态
- **WHEN** 执行 `work` 或 `work start`
- **THEN** 系统 SHALL 保持 session 运行不变，并提示 "✅ 已存在：petgugu"

#### Scenario: 路径无效处理
- **GIVEN** 配置的工作区路径在文件系统中不存在
- **WHEN** 执行 `work`
- **THEN** 系统 SHALL 输出警告 "⚠️  目录不存在：<path>" 并跳过创建

### Requirement: Separate Workspace Listing and Rich Status Reporting
系统 SHALL 提供 `work ls` 用于展示静态声明配置，并提供 `work status` 用于展示包含 Tmux 窗口数（Windows count）、运行状态与 Attach 标记的动态运行仪表盘。

#### Scenario: 执行 work ls
- **GIVEN** 配置文件定义了 4 个工作区
- **WHEN** 执行 `work ls`
- **THEN** 系统 SHALL 输出名称、映射路径及是否为默认工作区的声明列表

#### Scenario: 执行 work status
- **GIVEN** 已恢复工作区且部分 session 正在运行
- **WHEN** 执行 `work status`
- **THEN** 系统 SHALL 查询 `tmux list-sessions` 并格式化输出包含 `NAME`、`PATH`、`STATUS`（Running/Stopped）、`WINDOWS` 数量与 `ATTACHED` 标志的表格

### Requirement: Environment Health Diagnostics
系统 SHALL 提供 `work doctor` 命令，全面校验环境依赖与配置文件状态。

#### Scenario: 执行环境诊断
- **GIVEN** 用户运行 `work doctor`
- **WHEN** 系统逐项校验 `tmux`、`zsh`、`PATH`、`$EDITOR`、配置文件合法性、工作区路径存在性及 `fzf`
- **THEN** 系统 SHALL 输出结构化的绿色对勾 `✓` 与警告 `⚠️` 检查列表，并在有异常时提示修复建议

### Requirement: Context-Aware Attachment and Selector Fallback
系统 SHALL 依据 `$TMUX` 环境变量区分切换方式，并支持 `fzf` 优先与 Zsh `select` 降级的交互体验。

#### Scenario: Tmux 内部环境中切换
- **GIVEN** 环境变量 `$TMUX` 非空
- **WHEN** 执行 `work attach` 或 `work go` 选中 target session
- **THEN** 系统 SHALL 调用 `tmux switch-client -t "$target"`

#### Scenario: Tmux 外部环境中进入
- **GIVEN** 环境变量 `$TMUX` 为空
- **WHEN** 执行 `work attach` 或 `work go` 选中 target session
- **THEN** 系统 SHALL 调用 `tmux attach-session -t "$target"`

#### Scenario: Selector 交互降级
- **GIVEN** 用户环境中未安装 `fzf`
- **WHEN** 执行 `work attach`
- **THEN** 系统 SHALL 自动降级展示数字编号的 Zsh `select` 原生选择菜单
