# Git Workflow Skill

Multi-platform Git workflow for GitHub and GitLab: review changes, generate commit messages, push to remote, and create/update PRs/MRs with custom templates.

## Features

- 🚀 **Complete Workflow**: From code review to PR/MR creation in one go
- 🔍 **Code Review**: Analyze changes for quality, bugs, and improvements
- 📝 **Commit Messages**: Generate conventional commit messages automatically
- 🌐 **Multi-Platform**: Supports both GitHub and GitLab repositories
- 🎨 **Custom Templates**: Platform-specific PR/MR description templates
- 🤖 **Interactive Setup**: Easy installation and dependency management

## Quick Start

### 1. Install the Skill

**Method 1: Using add-skill (Recommended)** ⭐

```bash
npx add-skill make-fe-great-again/gitlab-skill-workflow
```

This works with multiple AI agents:
- ✅ OpenCode
- ✅ Cursor
- ✅ Claude Code

**Method 2: Clone and Install**
```bash
git clone https://github.com/make-fe-great-again/gitlab-skill-workflow.git
cd gitlab-skill-workflow
bash install.sh
```

**Method 3: Online Installation**
```bash
curl -fsSL https://github.com/make-fe-great-again/gitlab-skill-workflow/raw/main/install.sh | bash
```

### 2. Setup Dependencies

```bash
bash scripts/setup.sh
```

This will:
- Check for installed tools (git, gh, glab)
- Offer to install missing dependencies interactively
- Guide you through platform authentication

### 3. Use the Skill

In OpenCode/Cursor/Claude:
```
skill({ name: "git-workflow" })
```

## How It Works

1. **Platform Detection**: Automatically detects GitHub or GitLab from remote URL
2. **Review Changes**: Analyzes code changes for quality issues
3. **Generate Message**: Creates conventional commit messages
4. **Commit & Push**: Commits changes and pushes to remote
5. **Create/Update PR/MR**: Creates or updates Pull Request/Merge Request
6. **Custom Templates**: Uses platform-specific templates for descriptions

## Requirements

### Essential
- **Git** - Version control system

### Platform-Specific
- **GitHub CLI (gh)** - For GitHub repositories
- **GitLab CLI (glab)** - For GitLab repositories

The `scripts/setup.sh` script will help you install any missing dependencies.

## Installation Options

### Force Overwrite

```bash
bash install.sh --force
```

Overwrites existing files without asking.

### Verbose Mode

```bash
bash install.sh --verbose
```

Shows detailed installation progress.

### Help

```bash
bash install.sh --help
```

Shows all available options.

## Platform Support

### GitHub

- Pull Request creation and updates
- GitHub Actions integration
- Custom PR templates (`.github/pull_request_template.md`)
- Authentication via `gh auth login`

### GitLab

- Merge Request creation and updates
- GitLab CI/CD integration
- Custom MR templates (`.gitlab/merge_request_templates/default.md`)
- Authentication via `glab auth login`

### Custom GitLab Instances

For self-hosted GitLab:
```bash
glab auth login --hostname gitlab.example.com
```

## Examples

### Example 1: New Feature

```bash
# Make your changes
vim src/auth.js

# Use the skill
skill({ name: "git-workflow" })
```

The skill will:
1. Review your changes
2. Generate: `feat(auth): add JWT token validation`
3. Commit and push
4. Create a PR with your custom template

### Example 2: Bug Fix

```bash
# Fix the bug
vim src/api/user.js

# Use the skill
skill({ name: "git-workflow" })
```

The skill will:
1. Review the fix
2. Generate: `fix(api): handle null response in user endpoint`
3. Update existing PR with the fix

### Example 3: Documentation

```bash
# Update docs
vim README.md

# Use the skill
skill({ name: "git-workflow" })
```

The skill will:
1. Review the documentation changes
2. Generate: `docs(readme): update installation instructions`
3. Create a PR for documentation review

## Custom Templates

### GitHub Template

Create `.github/pull_request_template.md`:

```markdown
## Changes
${description}

## Files Changed
${changed_files}

## Review Notes
${review_notes}

## Checklist
- [ ] Tests pass
- [ ] Linting passes
- [ ] Documentation updated
```

### GitLab Template

Create `.gitlab/merge_request_templates/default.md`:

```markdown
## Description
${description}

## Related Issues
${review_notes}

## Checklist
- [ ] Tests pass
- [ ] Pipeline passed
- [ ] Code review approved
```

## Project Structure

### Repository Structure (Agent Skills Format)

This repository follows the [Agent Skills](https://github.com/vercel-labs/agent-skills) specification:

```
gitlab-skill-workflow/
├── skills/
│   └── git-workflow/
│       ├── SKILL.md              # Skill instructions
│       └── scripts/
│           ├── setup.sh          # Dependency setup
│           └── lib/
│               └── utils.sh      # Utility functions
├── templates/
│   ├── github/
│   │   └── pull_request_template.md
│   └── gitlab/
│       └── merge_request_templates/
│           └── default.md
├── install.sh                    # Manual installation script
└── README.md
```

### After Installation

Your project will have:

```
your-project/
├── .opencode/skill/          # or .cursor/skills/ or .claude/skills/
│   └── git-workflow/
│       └── SKILL.md
├── scripts/
│   ├── setup.sh
│   └── lib/
│       └── utils.sh
├── .github/                  # Optional: GitHub templates
│   └── pull_request_template.md
└── .gitlab/                  # Optional: GitLab templates
    └── merge_request_templates/
        └── default.md
```

## Troubleshooting

### "Command not found: gh/glab"

**Solution**: Run the setup script
```bash
bash scripts/setup.sh
```

Choose option to install the missing CLI tool.

### "Authentication failed"

**For GitHub**:
```bash
gh auth login
```

**For GitLab**:
```bash
glab auth login
```

For self-hosted GitLab:
```bash
glab auth login --hostname gitlab.example.com
```

### "PR/MR creation failed"

**Checklist**:
- [ ] Branch is pushed to remote (`git push`)
- [ ] Base branch exists
- [ ] You have proper permissions
- [ ] CLI is authenticated (`gh auth status` or `glab auth status`)

### "Templates not loading"

**Checklist**:
- [ ] Template file exists in correct location
- [ ] File is in markdown format (`.md`)
- [ ] File has proper permissions

## Best Practices

1. **Commit Messages**: Follow conventional commits format
   ```
   <type>(<scope>): <description>
   
   Types: feat, fix, docs, style, refactor, test, chore
   ```

2. **Branch Names**: Use descriptive names
   ```
   feature/user-auth
   fix/api-bug
   docs/update-readme
   ```

3. **Code Quality**: Review changes before committing
   - Run linters: `npm run lint`
   - Run tests: `npm test`
   - Check for potential issues

4. **PR/MR Descriptions**: Use clear, detailed descriptions
   - Explain what changed and why
   - Link to related issues
   - Include testing instructions

## Advanced Usage

### Custom Commit Message Format

The skill generates conventional commits by default. To customize:

1. Edit `.opencode/skill/git-workflow/SKILL.md`
2. Modify the commit message generation instructions
3. Test with a small change first

### Integration with CI/CD

This skill integrates with:
- GitHub Actions (GitHub)
- GitLab CI/CD (GitLab)
- Any CI/CD system supporting git hooks

Example pre-commit hook (`.git/hooks/pre-commit`):
```bash
#!/bin/bash
npm run lint
npm test
```

## Updating

To update to the latest version:

```bash
# Re-download and reinstall
curl -fsSL https://github.com/make-fe-great-again/gitlab-skill-workflow/raw/main/install.sh | bash
```

Or if you cloned the repository:
```bash
cd gitlab-skill-workflow
git pull
bash install.sh
```

## Uninstallation

To remove the skill from your project:

```bash
# Remove skill files
rm -rf .opencode/skill/git-workflow
rm -rf scripts

# Remove templates (if desired)
rm -rf .github
rm -rf .gitlab
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Support

- **GitHub**: https://github.com/make-fe-great-again/gitlab-skill-workflow
- **Issues**: https://github.com/make-fe-great-again/gitlab-skill-workflow/issues
- **Documentation**: See [skills/git-workflow/SKILL.md](skills/git-workflow/SKILL.md)

## Acknowledgments

Built following the [Agent Skills](https://github.com/vercel-labs/agent-skills) specification.

Compatible with:
- [OpenCode](https://opencode.ai)
- [Cursor](https://cursor.com)
- [Claude Code](https://claude.ai)

Inspired by best practices in:
- Conventional Commits
- GitHub/GitLab workflows
- Code review automation
