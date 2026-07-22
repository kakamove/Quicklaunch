## ADDED Requirements

### Requirement: Declarative Function-based Shell DSL
系统 SHALL 支持通过 Zsh 函数式 DSL（`workspace --name <name> --path <path> [--default]`）声明工作区，并在内部采用 Parallel Arrays 存储配置数据。

#### Scenario: 解析标准工作区 DSL
- **GIVEN** `~/.config/quicklaunch/config.sh` 中包含 `workspace --name petgugu --path ~/Developer/PetGuGu --default`
- **WHEN** 执行 `work` 或 `work ls` 加载配置
- **THEN** 系统 SHALL 解析并存储对应的名字、路径与默认标记，且展开相对路径为绝对路径

#### Scenario: 默认模版自动生成
- **GIVEN** `~/.config/quicklaunch/config.sh` 不存在
- **WHEN** 运行任意 `work` 命令
- **THEN** 系统 SHALL 在该路径下自动创建并初始化带有示例工作区的 `config.sh`

### Requirement: Modular Subcommand Routing with Single Entrypoint Functions
系统 `bin/work` SHALL 作为 Command Router 分发至 `lib/commands/<subcommand>.sh` 模块，且每个子命令脚本 MUST 仅暴露单一的公共入口函数（格式为 `cmd_<subcommand>::run`）。

#### Scenario: 路由至子命令模块
- **GIVEN** 用户输入 `work status`
- **WHEN** `bin/work` 分发请求
- **THEN** 系统 SHALL 加载 `lib/commands/status.sh` 并直接调用其公共入口函数 `cmd_status::run "$@"`

#### Scenario: 校验模块规模约束
- **GIVEN** 项目中的任何 `lib/` 模块文件
- **WHEN** 进行代码编写或重构
- **THEN** 任何单文件脚本的代码行数 MUST 保持在 150 行以内

### Requirement: Unified UI Abstraction and Visual Status Reporting
系统 SHALL 提供统一的 UI 渲染函数库（`lib/ui.sh`），且 `work status` 动态仪表盘 MUST 展示包含默认工作区图标（`★`）、`NAME`、`PATH`、`STATUS`、`WINDOWS` 数量与 `ATTACHED` 标记的列表。

#### Scenario: 显示包含默认工作区标记的状态仪表盘
- **GIVEN** `petgugu` 工作区被标记为 `--default` 且正在运行
- **WHEN** 执行 `work status`
- **THEN** 系统 SHALL 通过 `ui::table` 输出带有 `★` 标识的 `petgugu` 行信息

#### Scenario: 执行 work ls 静态查看
- **GIVEN** 已声明配置 4 个工作区
- **WHEN** 执行 `work ls`
- **THEN** 系统 SHALL 通过 `ui::` 工具快速打印配置名字与路径清单

### Requirement: Environment Health Diagnostics
系统 SHALL 提供 `work doctor` 命令，全面校验环境依赖与配置文件状态。

#### Scenario: 执行环境诊断
- **GIVEN** 用户运行 `work doctor`
- **WHEN** 系统通过 `doctor::run` 校验 `tmux`、`zsh`、`PATH`、`$EDITOR`、`config.sh` 及 `fzf`
- **THEN** 系统 SHALL 通过 `ui::ok` / `ui::warn` 输出带有对勾与警告排查提示的格式化检查报告

### Requirement: Idempotent Session Restoration & Context-Aware Attachment
系统 SHALL 支持后台静默（`-d`）创建 session 的幂等恢复，并依据 `$TMUX` 环境变量自动在 `tmux switch-client` 与 `tmux attach-session` 之间进行感知分发。

#### Scenario: 幂等恢复与路径容错
- **GIVEN** 配置文件包含有效与无效路径的工作区
- **WHEN** 执行 `work`
- **THEN** 系统 SHALL 对存在的 session 跳过，对未运行且有效的路径创建 session，对无效路径使用 `ui::warn` 输出提示

#### Scenario: Context-Aware Attachment 切换
- **GIVEN** 用户执行 `work attach` 或 `work go` 选中 target
- **WHEN** `$TMUX` 存在时调用 `tmux switch-client -t "$target"`，当 `$TMUX` 为空时调用 `tmux attach-session -t "$target"`
- **THEN** 系统 SHALL 正确进入目标工作区，无嵌套错误
