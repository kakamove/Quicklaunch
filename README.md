# Quicklaunch

Quicklaunch 是一个基于 Zsh 与 Tmux 的轻量级多工作区管理与启动工具。通过简洁的 Shell DSL 配置，只需一条命令即可完成所有研发项目工作区（Tmux 会话）的开机恢复、快速跳转、交互筛选与健康诊断。

---

## 🌟 功能特性

- **一键恢复与启动 (Batch Restore & Start)**：一条命令批量为所有已配置的工作区创建并初始化独立的 Tmux 会话。
- **交互式切换 (Interactive Attach)**：集成 `fzf`，支持通过模糊匹配快速选择并附加到目标 Tmux 会话。
- **默认/命名直达 (Direct Navigation)**：支持 `work go` 一键附加到默认工作区，或 `work <name>` 直达指定工作区。
- **运行仪表盘 (Status Dashboard)**：可视化的工作区状态仪表盘，直观展示活跃会话、窗口数量及所在路径。
- **环境诊断 (Environment Doctor)**：包含内置的 `work doctor` 诊断检查，快速验证 `zsh`, `tmux`, `fzf`, `Ghostty` 等依赖环境。
- **声明式配置 (Shell DSL)**：通过简明而富有表达力的 Shell DSL 语法管理项目工作区列表。

---

## 🛠️ 依赖要求

使用 Quicklaunch 需要确保系统已安装以下基础环境与工具：

- **Zsh** (≥ 5.0)
- **Tmux** (≥ 3.0)
- **fzf** (用于交互筛选)
- *(可选/推荐)* **Ghostty** 终端模拟器

---

## 🚀 安装与配置

### 1. 将 `work` 命令添加到环境变量

修改你的 `~/.zshrc` 文件，将 Quicklaunch 的 `bin/` 目录加入到 `PATH` 中：

```zsh
export PATH="/path/to/Quicklaunch/bin:$PATH"
```

修改后重新加载 Zsh 配置：

```zsh
source ~/.zshrc
```

### 2. 配置工作区 (`config/config.sh`)

在 `config/config.sh` 文件中使用 Shell DSL 语法定义你的工作区：

```zsh
# config/config.sh
# 语法说明：
# workspace --name <名称> --path <绝对路径> [--default]

workspace --name okp-feat --path ~/Developer/Workspace/MainProjects/okp_ios-useeIot
workspace --name okp --path ~/Developer/Workspace/MainProjects/okp_ios
workspace --name petgugu --path ~/Developer/Workspace/MainProjects/PetGuGu
workspace --name petgugu-feat --path ~/Developer/Workspace/MainProjects/PetguguOKP-Feature --default
```

---

## 📖 命令指南

| 命令 | 别名 | 说明 |
| :--- | :--- | :--- |
| `work` / `work start` | `work restore` | 批量启动或恢复所有已配置的工作区 Tmux 会话 |
| `work status` | `work st` | 显示当前各工作区运行状态仪表盘 |
| `work ls` | `work list` | 列出已静态配置的所有工作区列表 |
| `work attach` | `work at` | 通过 `fzf` 交互式菜单选择并附加到指定工作区 |
| `work go` | - | 直接附加到带有 `--default` 标记的默认工作区 |
| `work <name>` | - | 直接附加到指定名称的工作区（例如 `work okp`） |
| `work doctor` | `work doc` | 运行系统及环境依赖健康诊断 |
| `work config` | `work cfg` | 使用默认编辑器打开配置文件 `config/config.sh` |
| `work help` | `-h`, `--help` | 查看详细命令行帮助信息 |

---

## 🔍 环境诊断示例

在配置或更新工具链后，可运行 `work doctor` 确认环境就绪情况：

```bash
work doctor
```

诊断日志将检查 Zsh、Tmux、fzf 核心组件以及 `config/config.sh` 的正确性。
