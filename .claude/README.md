# Git Workflow Skill - Project Knowledge

## 项目概述

这是一个为 AI coding agents 设计的 **Git Workflow Skill**，遵循 [Agent Skills](https://github.com/vercel-labs/agent-skills) 规范。

### 核心功能

- 🔍 代码审查：分析变更质量、潜在 bug
- 📝 提交消息：自动生成 Conventional Commits 格式
- 🚀 推送代码：提交并推送到远程仓库
- 🔀 创建 PR/MR：自动创建或更新 GitHub PR / GitLab MR
- 🎨 自定义模板：支持平台特定的 PR/MR 描述模板

### 多平台支持

| 平台 | CLI 工具 | 认证命令 |
|------|----------|----------|
| GitHub | `gh` | `gh auth login` |
| GitLab | `glab` | `glab auth login` |

---

## 项目结构

```
gitlab-skill-workflow/
├── skills/                       # Agent Skills 规范目录 ⭐
│   └── git-workflow/
│       ├── SKILL.md              # AI Agent 指令文件
│       └── scripts/
│           ├── setup.sh          # 依赖安装脚本
│           └── lib/
│               └── utils.sh      # Shell 工具函数库
├── templates/                    # PR/MR 模板
│   ├── github/
│   │   └── pull_request_template.md
│   └── gitlab/
│       └── merge_request_templates/
│           └── default.md
├── install.sh                    # 手动安装脚本
├── .gitignore
├── README.md
├── UNINSTALL.md
└── LICENSE
```

---

## 安装方式

### 方式 1：使用 add-skill（推荐）

```bash
npx add-skill make-fe-great-again/gitlab-skill-workflow
```

### 方式 2：手动安装

```bash
git clone https://github.com/make-fe-great-again/gitlab-skill-workflow.git
cd gitlab-skill-workflow
bash install.sh
```

---

## 关键文件说明

### `skills/git-workflow/SKILL.md`

AI Agent 的核心指令文件，包含：
- YAML frontmatter：定义 skill 元数据（name, description, license）
- Markdown 正文：详细的工作流程指令

```yaml
---
name: git-workflow
description: Multi-platform Git workflow...
license: MIT
---
```

### `skills/git-workflow/scripts/setup.sh`

交互式依赖安装脚本，功能：
- 检测已安装的工具（git, gh, glab）
- 提供安装选项菜单
- 支持多种包管理器（apt, brew, yum, dnf）
- 引导用户完成平台认证

### `skills/git-workflow/scripts/lib/utils.sh`

Shell 工具函数库，提供：
- 日志函数：`log_info`, `log_success`, `log_error`, `log_warning`, `log_step`
- 交互函数：`ask_yes_no`, `ask_choice`
- 检测函数：`command_exists`, `get_version`, `detect_os`, `detect_package_manager`
- 格式函数：`format_status`, `separator`

### `install.sh`

手动安装脚本，将 skill 安装到用户项目：
- 复制 `SKILL.md` 到 `.opencode/skill/git-workflow/`
- 复制 `setup.sh` 和 `utils.sh` 到 `scripts/`
- 可选复制 PR/MR 模板

---

## 开发指南

### 修改 Skill 指令

编辑 `skills/git-workflow/SKILL.md`，修改后需要重新安装到测试项目。

### 修改安装脚本

编辑 `skills/git-workflow/scripts/setup.sh`，使用以下命令测试语法：

```bash
bash -n skills/git-workflow/scripts/setup.sh
```

### 测试安装流程

```bash
# 在测试项目中
bash /path/to/gitlab-skill-workflow/install.sh --verbose
```

---

## 代码规范

### Shell 脚本

- 使用 `set -e` 遇错即停
- 使用 `readonly` 定义常量
- 函数名使用 `snake_case`
- 变量使用 `local` 声明局部变量
- 使用 `$()` 而不是反引号进行命令替换

### Markdown

- 使用 ATX 风格标题（`#`）
- 代码块指定语言
- 使用表格展示对比信息

---

## 常见问题

### Q: 为什么使用 `skills/` 目录而不是 `.opencode/skill/`？

A: 遵循 [Agent Skills 规范](https://github.com/vercel-labs/agent-skills)，使得项目可以通过 `npx add-skill` 安装，兼容多种 AI agents（OpenCode, Cursor, Claude 等）。

### Q: `add-skill` 会复制哪些文件？

A: 会复制整个 `skills/git-workflow/` 目录到目标 agent 的 skills 目录。

### Q: 如何支持新的 AI agent？

A: Agent Skills 规范是通用的，新的 agent 只需支持读取 `SKILL.md` 格式即可。

---

## 相关链接

- [Agent Skills 规范](https://github.com/vercel-labs/agent-skills)
- [add-skill CLI](https://add-skill.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub CLI](https://cli.github.com/)
- [GitLab CLI](https://gitlab.com/gitlab-org/cli)
