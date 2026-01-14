# Uninstallation Guide

To uninstall the git-workflow skill from your project, follow these steps:

## Quick Uninstall

```bash
# Remove skill files
rm -rf .opencode/skill/git-workflow
rm -rf scripts
rm -rf .github
rm -rf .gitlab
```

## Step-by-Step Guide

### 1. Verify Current Installation

Check what files will be removed:

```bash
ls -la .opencode/skill/git-workflow/
ls -la scripts/
ls -la .github/
ls -la .gitlab/
```

### 2. Remove Skill Definition

Remove the OpenCode skill definition:

```bash
rm -rf .opencode/skill/git-workflow
```

### 3. Remove Scripts

Remove the setup scripts and utilities:

```bash
rm -rf scripts/
```

### 4. Remove Platform Templates (Optional)

Remove GitHub and GitLab templates:

**GitHub templates:**
```bash
rm -rf .github/
```

**GitLab templates:**
```bash
rm -rf .gitlab/
```

> **Note**: Only remove `.github/` and `.gitlab/` if they were created by this skill installation. If your project already had these directories with your own configuration files, you should only remove the files added by this skill.

### 5. Verify Uninstallation

Check that all files have been removed:

```bash
# Should not exist
[ ! -d ".opencode/skill/git-workflow" ] && echo "✓ Skill definition removed" || echo "✗ Skill definition still exists"
[ ! -d "scripts" ] && echo "✓ Scripts removed" || echo "✗ Scripts still exist"
[ ! -d ".github" ] && echo "✓ GitHub templates removed" || echo "ℹ .github still exists (may have other files)"
[ ! -d ".gitlab" ] && echo "✓ GitLab templates removed" || echo "ℹ .gitlab still exists (may have other files)"
```

## Selective Uninstall

If you want to keep some components while removing others:

### Keep Templates, Remove Skill

```bash
# Remove only skill and scripts, keep templates
rm -rf .opencode/skill/git-workflow
rm -rf scripts
```

### Keep Skill, Remove Templates

```bash
# Remove only templates, keep skill
rm -rf .github
rm -rf .gitlab
```

## Troubleshooting

### File Permission Errors

If you encounter permission errors:

```bash
# Use sudo if necessary
sudo rm -rf .opencode/skill/git-workflow
sudo rm -rf scripts
```

### Files Not Removed

If files persist after removal:

```bash
# Check for hidden files
ls -la .opencode/skill/git-workflow/
ls -la scripts/

# Force remove if necessary
rm -rf .opencode/skill/git-workflow/
rm -rf scripts/
```

### Templates Have Other Files

If your `.github/` or `.gitlab/` directories contain other files:

```bash
# List files to identify skill-added files
ls -la .github/
ls -la .gitlab/

# Remove only skill-added files
rm .github/pull_request_template.md
rm .gitlab/merge_request_templates/default.md
```

## Reinstallation

If you want to reinstall the skill after uninstalling:

```bash
# Method 1: Clone and reinstall
git clone https://github.com/make-fe-great-again/gitlab-skill-workflow.git
cd gitlab-skill-workflow
bash install.sh

# Method 2: Online installation
curl -fsSL https://github.com/make-fe-great-again/gitlab-skill-workflow/raw/main/install.sh | bash
```

## Clean Up

If you cloned the repository and want to remove it:

```bash
# Remove cloned repository
cd ..
rm -rf gitlab-skill-workflow
```

## Feedback

If you encounter issues during uninstallation or have suggestions for improvement:

- GitHub Issues: https://github.com/make-fe-great-again/gitlab-skill-workflow/issues
- Documentation: https://github.com/make-fe-great-again/gitlab-skill-workflow

---

Thank you for trying git-workflow skill!
