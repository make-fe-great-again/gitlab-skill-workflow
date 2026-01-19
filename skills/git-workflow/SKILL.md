---
name: git-workflow
description: Multi-platform Git workflow for GitHub and GitLab. Use when you need to review code changes, generate conventional commit messages, push to remote, and create or update Pull Requests (GitHub) or Merge Requests (GitLab). Triggers on tasks involving git commit, git push, PR creation, MR creation, code review, or workflow automation.
license: MIT
metadata:
  author: make-fe-great-again
  version: "1.0.0"
---

## What I do

- **Review Changes**: Analyze code changes for quality, potential bugs, and improvements
- **Generate Commit Messages**: Create conventional commit messages following best practices
- **Push to Remote**: Push changes to remote repository
- **Create/Update PRs/MRs**: Create or update GitHub Pull Requests or GitLab Merge Requests
- **Custom Templates**: Support platform-specific custom PR/MR description templates

## When to use me

Use when you need to:
- Complete a full git workflow from changes to PR/MR
- Ensure consistent commit message format
- Automate PR/MR creation with proper descriptions
- Apply code review best practices
- Work seamlessly with both GitHub and GitLab repositories

## How I work

### 1. Dependency Check

First, I'll check if required tools are installed:
- `git` - Required for all operations
- `gh` - Required for GitHub repositories (no push options alternative)
- `glab` - Optional for GitLab (can use `git push -o` instead)

**Platform differences:**
| Platform | CLI Tool | Required? | Alternative |
|----------|----------|-----------|-------------|
| GitHub | `gh` | Yes | None |
| GitLab | `glab` | No | `git push -o` |

If you need to install dependencies, run:
```bash
bash scripts/setup.sh
```

This will:
- Check installed dependencies
- Offer interactive installation options
- Guide you through platform authentication

### 2. Platform Detection

I automatically detect your platform by:
1. Checking git remote URL for `github.com` or `gitlab.com`
2. Checking for `.github/` or `.gitlab/` directories
3. Using active remote as primary if both platforms detected

### 3. Review Changes

Run `git status` and `git diff` to:
- Analyze changed files and their types
- Identify potential code quality issues
- Check for missing lint/typecheck commands
- Generate a review report

### 4. Generate Commit Message

Analyze changes to create a conventional commit message:
- Format: `<type>(<scope>): <description>`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- Identify scope based on changed files
- Generate concise, clear description

Example:
```
feat(auth): add JWT token validation
fix(api): handle null response in user endpoint
docs(readme): update installation instructions
```

### 5. Commit and Push

1. Ask for confirmation of commit message
2. Run `git commit` with the generated message
3. Run `git push` to remote repository
4. Handle upstream setup if needed

### 6. Create/Update PR or MR

**For GitHub:**
```bash
# Check for existing PR
gh pr list --head $CURRENT_BRANCH

# Create new PR
gh pr create --title "$TITLE" --body "$BODY" --base $BASE

# Update existing PR
gh pr edit $PR_NUMBER --body "$BODY"
```

**For GitLab (Method 1 - Push Options, no glab required):**
```bash
# Create MR with push options (uses existing SSH/Git auth)
git push -o merge_request.create \
         -o merge_request.target=$BASE \
         -o "merge_request.title=$TITLE" \
         -o "merge_request.description=$BODY" \
         origin $CURRENT_BRANCH

# Available push options:
# -o merge_request.create              - Create MR
# -o merge_request.target=<branch>     - Set target branch
# -o merge_request.title="<title>"     - Set MR title
# -o merge_request.description="<desc>"- Set MR description
# -o merge_request.draft               - Mark as draft
# -o merge_request.merge_when_pipeline_succeeds - Auto-merge on CI pass
# -o merge_request.remove_source_branch - Delete branch after merge
```

**For GitLab (Method 2 - glab CLI, more features):**
```bash
# Check for existing MR
glab mr list --source-branch $CURRENT_BRANCH

# Create new MR
glab mr create --title "$TITLE" --description "$BODY" --target-branch $BASE

# Update existing MR
glab mr edit $MR_NUMBER --description "$BODY"
```

### 7. Custom Templates

Support for platform-specific templates:

**GitHub** - Loads from:
1. `.github/pull_request_template.md` (recommended)
2. `.github/pr-template.md`

**GitLab** - Loads from:
1. `.gitlab/merge_request_templates/default.md` (recommended)
2. `.gitlab/mr-template.md`

**Template Variables:**
- `${title}` - PR/MR title
- `${description}` - Commit message description
- `${changed_files}` - List of changed files
- `${review_notes}` - Code review observations
- `${platform}` - Platform name (GitHub/GitLab)
- `${branch}` - Current branch name
- `${base_branch}` - Target base branch

## Prerequisites

1. **Git** - Version control system (required)
   ```bash
   # Check installation
   git --version
   
   # Install if needed
   # Ubuntu/Debian: sudo apt install git
   # macOS: brew install git
   ```

2. **GitHub CLI (gh)** - For GitHub repositories
   ```bash
   # Check installation
   gh --version
   
   # Install
   curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
   sudo apt update && sudo apt install -y gh
   
   # Authenticate
   gh auth login
   ```

3. **GitLab CLI (glab)** - Optional for GitLab repositories
   ```bash
   # Check installation
   glab --version
   
   # Install (Linux)
   curl -sL https://gitlab.com/api/v4/projects/43644822/packages/generic/glab/latest/linux_amd64.tar.gz -o /tmp/glab.tar.gz
   tar -xzf /tmp/glab.tar.gz -C /tmp
   sudo mv /tmp/glab /usr/local/bin/
   
   # Install (macOS)
   brew install glab
   
   # Authenticate
   glab auth login
   ```

   > **Note**: For GitLab, you can use `git push -o` instead of `glab` CLI. See [Create/Update PR or MR](#6-createupdate-pr-or-mr) section.

## Quick Start

### Install the Skill

```bash
# Method 1: Clone and install
git clone https://github.com/make-fe-great-again/gitlab-skill-workflow.git
cd gitlab-skill-workflow
bash install.sh

# Method 2: Online installation
curl -fsSL https://raw.githubusercontent.com/make-fe-great-again/gitlab-skill-workflow/main/install.sh | bash
```

### Setup Dependencies

```bash
# Run interactive setup
bash scripts/setup.sh

# Follow the prompts to:
# 1. Check installed tools
# 2. Install missing dependencies
# 3. Authenticate with your platform
```

### Use the Skill

```bash
# In OpenCode conversation
skill({ name: "git-workflow" })
```

## Examples

### Example 1: Simple Feature

```
User: I just implemented user authentication
Agent: [Loads git-workflow skill]
     1. Review changes...
     2. Generate commit message: feat(auth): add JWT token validation
     3. Commit and push...
     4. Create PR with custom template...
```

### Example 2: Bug Fix

```
User: Fixed the null pointer exception in user service
Agent: [Loads git-workflow skill]
     1. Review changes...
     2. Generate commit message: fix(user-service): handle null response in user endpoint
     3. Commit and push...
     4. Update existing PR with new changes...
```

### Example 3: Documentation Update

```
User: Updated the README with installation instructions
Agent: [Loads git-workflow skill]
     1. Review changes...
     2. Generate commit message: docs(readme): update installation instructions
     3. Commit and push...
     4. Create PR with description from template...
```

## Platform-Specific Notes

### GitHub
- Uses `gh` CLI for all operations
- Supports GitHub Actions workflows
- PR templates should be in `.github/pull_request_template.md`
- Authentication: `gh auth login`

### GitLab
Two methods available for creating MRs:

**Method 1: `git push -o` (no extra tools needed)**
- Uses existing SSH/HTTPS authentication
- One command for push + MR creation
- Supported options: create, target, title, description, draft, auto-merge, etc.

**Method 2: `glab` CLI (more features)**
- Can manage MRs, view status, add comments, assign reviewers
- Requires separate API authentication: `glab auth login`
- Better for complex MR management workflows

MR templates should be in `.gitlab/merge_request_templates/default.md`

### Custom GitLab Instances
If using a self-hosted GitLab instance:
```bash
# For glab CLI
glab auth login --hostname gitlab.example.com

# For git push -o (works automatically with SSH/HTTPS auth)
git push -o merge_request.create origin $BRANCH
```

## Troubleshooting

**Issue: gh/glab command not found**
- Run `bash scripts/setup.sh` to install missing dependencies
- For GitLab, you can use `git push -o` instead of `glab`

**Issue: Authentication failed**
- Ensure you're logged in: `gh auth status` or `glab auth status`
- Re-authenticate if needed

**Issue: PR/MR creation failed**
- Check if branch is pushed to remote
- Verify base branch exists
- Ensure you have proper permissions

**Issue: Templates not loading**
- Verify template files exist in correct locations
- Check file permissions
- Ensure templates are markdown format

## Best Practices

1. **Commit Messages**: Follow conventional commits format
2. **Branch Names**: Use descriptive names (e.g., `feature/user-auth`, `fix/api-bug`)
3. **PR/MR Descriptions**: Use clear, detailed descriptions
4. **Code Review**: Always review changes before committing
5. **Testing**: Ensure tests pass before pushing

## Customization

### Modify Commit Message Format

The skill generates conventional commits by default. To customize:
1. Edit the skill instructions
2. Add your preferred format rules
3. Test with a small change first

### Custom PR/MR Templates

Create custom templates in your project:

**GitHub** - `.github/pull_request_template.md`:
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

**GitLab** - `.gitlab/merge_request_templates/default.md`:
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

## Integration

### With CI/CD

This skill integrates seamlessly with:
- GitHub Actions (GitHub)
- GitLab CI/CD (GitLab)
- Jenkins
- Any CI/CD system that supports git hooks

### With Git Hooks

Add pre-commit hooks to enforce quality:
```bash
# .git/hooks/pre-commit
#!/bin/bash
npm run lint
npm test
```

## Support

For issues, questions, or contributions:
- GitHub: https://github.com/make-fe-great-again/gitlab-skill-workflow
- Documentation: https://github.com/make-fe-great-again/gitlab-skill-workflow

## License

MIT License - See LICENSE file for details
