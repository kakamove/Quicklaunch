## 1. 项目基础与目录结构搭建 (Setup & Modular Architecture)

- [ ] 1.1 创建 `bin/` 与 `lib/` 模块化目录结构（`lib/commands/` 及核心库组件文件骨架）
- [ ] 1.2 实现 `lib/config.sh` 中的 `workspace` 函数式 Shell DSL 解析逻辑（支持 `--name`, `--path`, `--default`）
- [ ] 1.3 创建 `config/config.sh` 示例模版文件并实现自动初始化生成逻辑

## 2. 核心公共组件实现 (Core Shared Libraries)

- [ ] 2.1 编写 `lib/utils.sh` (提供日志颜色格式化、路径展开及辅助校验工具)
- [ ] 2.2 编写 `lib/tmux.sh` (封装 `has-session`, `new-session -d`, `list-sessions` 及 context-aware `attach`/`switch-client` 函数)
- [ ] 2.3 编写 `lib/ui.sh` (实现终端状态表格绘制，以及 `fzf` 搜索与 Zsh 原生 `select` 菜单的降级交互)

## 3. 命令行 Router 与子命令模块实现 (Subcommand Implementations)

- [ ] 3.1 编写 `bin/work` 路由器入口，实现子命令分发与未匹配工作区名自动识别机制
- [ ] 3.2 实现 `lib/commands/start.sh` (默认静默恢复全部工作区 session)
- [ ] 3.3 实现 `lib/commands/ls.sh` (输出静态配置的工作区列表)
- [ ] 3.4 实现 `lib/commands/status.sh` (输出包含 Status, Windows count, Attached 标记的运行仪表盘)
- [ ] 3.5 实现 `lib/commands/attach.sh` (交互式工作区选择与切入)
- [ ] 3.6 实现 `lib/commands/go.sh` (直接进入默认 `--default` 工作区)
- [ ] 3.7 实现 `lib/commands/doctor.sh` (环境诊断命令：校验 tmux, zsh, PATH, editor, fzf, config 及工作区路径)
- [ ] 3.8 实现 `lib/commands/config.sh` (使用 `${EDITOR:-vim}` 编辑配置文件)

## 4. 验证、测试与软安装 (Verification & Installation)

- [ ] 4.1 验证 DSL 函数解析容错性与路径扩展正确性
- [ ] 4.2 验证 `work doctor` 环境诊断的对勾/警告展示与错误排查提示
- [ ] 4.3 验证 `work status` 动态仪表盘与 `work ls` 列表的正确性
- [ ] 4.4 验证在 Ghostty 终端与 Tmux 内部的无缝 attach/switch 行为
- [ ] 4.5 将 `bin/work` 符号链接/安装至 `~/.local/bin/work` 并赋予可执行权限
