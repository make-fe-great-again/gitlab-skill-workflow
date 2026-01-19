# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Git Workflow Skill** for AI coding agents, following the [Agent Skills](https://github.com/vercel-labs/agent-skills) specification.

**Purpose**: Automate the complete Git workflow from code review to PR/MR creation.

## Key Commands

```bash
# Install dependencies check
bash skills/git-workflow/scripts/setup.sh

# Test install script syntax
bash -n install.sh
bash -n skills/git-workflow/scripts/setup.sh

# Test installation (in another project)
bash /path/to/install.sh --verbose
```

## Architecture

```
skills/git-workflow/
├── SKILL.md          # AI agent instructions (YAML frontmatter + Markdown)
└── scripts/
    ├── setup.sh      # Interactive dependency installer
    └── lib/
        └── utils.sh  # Shell utility functions (logging, prompts, detection)
```

## Code Conventions

### Shell Scripts

- Use `set -e` for fail-fast behavior
- Use `readonly` for constants
- Use `local` for function variables
- Use `$()` for command substitution (not backticks)
- Function names: `snake_case`

### SKILL.md Format

```yaml
---
name: skill-name
description: One-line description
license: MIT
metadata:
  author: org-name
  version: "1.0.0"
---

# Markdown content with instructions for the AI agent
```

## File Purposes

| File | Purpose |
|------|---------|
| `skills/git-workflow/SKILL.md` | AI agent reads this for workflow instructions |
| `skills/git-workflow/scripts/setup.sh` | User runs to install git/gh/glab dependencies |
| `skills/git-workflow/scripts/lib/utils.sh` | Shell helpers used by setup.sh |
| `install.sh` | Manual installation script for users |
| `templates/` | PR/MR description templates |

## Testing Changes

1. **Syntax check**: `bash -n <script.sh>`
2. **Dry run**: Use `--verbose` flag with install.sh
3. **Full test**: Install in a test project, run the skill

## Dependencies

- **git**: Required for all operations
- **gh**: GitHub CLI for PR operations
- **glab**: GitLab CLI for MR operations
