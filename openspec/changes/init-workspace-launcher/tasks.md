## 1. 基础架构与规则约束 (Setup & Engineering Boundaries)

- [ ] 1.1 创建 `bin/` 与 `lib/` 模块化目录结构（包含 `lib/commands/` 及公共组件）
- [ ] 1.2 编写 `lib/ui.sh` 渲染函数库（实现 `ui::header`, `ui::ok`, `ui::warn`, `ui::error`, `ui::table`）
- [ ] 1.3 实现 `lib/config.sh` 中的 `workspace` 函数式 Shell DSL 解析及 Parallel Arrays 数据处理
- [ ] 1.4 创建 `config/config.sh` 示例模版文件与自动生成初始化逻辑

## 2. 核心公共组件实现 (Core Shared Libraries)

- [ ] 2.1 编写 `lib/utils.sh`（提供路径展开、规范化与通用校验工具，单文件 < 150 行）
- [ ] 2.2 编写 `lib/tmux.sh`（封装 `has-session`, `new-session -d`, `list-sessions` 及 context-aware `attach`/`switch-client` 函数，单文件 < 150 行）

## 3. 规范化子命令实现 (Subcommand Implementations with `cmd_<subcommand>::run`)

- [ ] 3.1 编写 `bin/work` 路由器入口（解析命令并转派至 `cmd_<subcommand>::run`）
- [ ] 3.2 实现 `lib/commands/start.sh` -> `cmd_start::run` (默认静默恢复全部工作区 session)
- [ ] 3.3 实现 `lib/commands/ls.sh` -> `cmd_ls::run` (展示静态配置工作区列表)
- [ ] 3.4 实现 `lib/commands/status.sh` -> `cmd_status::run` (输出带 `★` 默认标记、Windows count, Attached 标记的仪表盘)
- [ ] 3.5 实现 `lib/commands/attach.sh` -> `cmd_attach::run` (交互式选择与切入，支持 `fzf`/`select` 降级)
- [ ] 3.6 实现 `lib/commands/go.sh` -> `cmd_go::run` (直接切入默认工作区)
- [ ] 3.7 实现 `lib/commands/doctor.sh` -> `cmd_doctor::run` (环境诊断命令：校验 tmux, zsh, PATH, editor, fzf, config 及工作区路径)
- [ ] 3.8 实现 `lib/commands/config.sh` -> `cmd_config::run` (使用 `${EDITOR:-vim}` 编辑配置文件)

## 4. 架构验证与软安装 (Verification & Deployment)

- [ ] 4.1 校验所有 `lib/` 下的脚本单文件行数均维持在 100–150 行以内的约束
- [ ] 4.2 校验 `cmd_<subcommand>::run` 调用的作用域隔离与独立可测性
- [ ] 4.3 验证 `work status` 动态仪表盘 `★` 标记与 `work doctor` 诊断报告展示
- [ ] 4.4 验证在 Ghostty 终端与 Tmux 内部的无缝 attach/switch 行为
- [ ] 4.5 将 `bin/work` 符号链接/安装至 `~/.local/bin/work` 并赋予 `chmod +x` 权限
