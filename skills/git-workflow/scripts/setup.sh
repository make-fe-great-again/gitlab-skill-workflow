#!/bin/bash
# setup.sh - 交互式依赖设置脚本
# 检查并安装 Git、GitHub CLI (gh)、GitLab CLI (glab)

# 加载工具函数
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# 显示欢迎信息
show_welcome() {
    separator "="
    echo "  Git Workflow Skill - Dependency Setup"
    separator "="
    echo ""
}

# 检查依赖状态
check_dependencies() {
    log_step "Checking system dependencies..."
    echo ""
    
    local os
    os=$(detect_os)
    log_info "Platform: $(detect_os | tr '[:lower:]' '[:upper:]') ($(uname -r))"
    echo ""
    
    # 检查 Git
    if command_exists git; then
        local git_version
        git_version=$(get_version git)
        format_status "Git" "true" "$git_version"
    else
        format_status "Git" "false" ""
    fi
    
    # 检查 GitHub CLI
    if command_exists gh; then
        local gh_version
        gh_version=$(get_version gh)
        format_status "GitHub CLI (gh)" "true" "$gh_version"
    else
        format_status "GitHub CLI (gh)" "false" ""
    fi
    
    # 检查 GitLab CLI
    if command_exists glab; then
        local glab_version
        glab_version=$(get_version glab)
        format_status "GitLab CLI (glab)" "true" "$glab_version"
    else
        format_status "GitLab CLI (glab)" "false" ""
    fi
    
    echo ""
}

# 检测需要安装的工具
detect_missing_tools() {
    local missing=()
    
    if ! command_exists git; then
        missing+=("git")
    fi
    if ! command_exists gh; then
        missing+=("gh")
    fi
    if ! command_exists glab; then
        missing+=("glab")
    fi
    
    echo "${missing[@]}"
}

# 安装 Git
install_git() {
    log_step "Installing Git..."
    
    local pkg_manager
    pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        apt)
            log_info "Using apt to install Git..."
            sudo apt update && sudo apt install -y git
            ;;
        brew)
            log_info "Using Homebrew to install Git..."
            brew install git
            ;;
        yum|dnf)
            log_info "Using $pkg_manager to install Git..."
            sudo $pkg_manager install -y git
            ;;
        *)
            log_error "Unsupported package manager: $pkg_manager"
            log_info "Please install Git manually from: https://git-scm.com/downloads"
            return 1
            ;;
    esac
    
    if command_exists git; then
        log_success "Git installed successfully: $(get_version git)"
        return 0
    else
        log_error "Git installation failed"
        return 1
    fi
}

# 安装 GitHub CLI
install_gh() {
    log_step "Installing GitHub CLI..."
    
    local pkg_manager
    pkg_manager=$(detect_package_manager)
    
    case "$pkg_manager" in
        apt)
            log_info "Using apt to install GitHub CLI..."
            # 添加 GitHub CLI GPG key
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update && sudo apt install -y gh
            ;;
        brew)
            log_info "Using Homebrew to install GitHub CLI..."
            brew install gh
            ;;
        yum|dnf)
            log_info "Using $pkg_manager to install GitHub CLI..."
            sudo $pkg_manager install -y gh
            ;;
        *)
            log_error "Unsupported package manager: $pkg_manager"
            log_info "Please install GitHub CLI manually: https://cli.github.com/manual/installation"
            return 1
            ;;
    esac
    
    if command_exists gh; then
        log_success "GitHub CLI installed successfully: $(get_version gh)"
        return 0
    else
        log_error "GitHub CLI installation failed"
        log_info "Please install manually: https://cli.github.com/manual/installation"
        return 1
    fi
}

# 安装 GitLab CLI
install_glab() {
    log_step "Installing GitLab CLI..."
    
    local os
    os=$(detect_os)
    
    if [ "$os" = "linux" ]; then
        # 检测 CPU 架构
        local arch
        case "$(uname -m)" in
            x86_64)  arch="amd64" ;;
            aarch64|arm64) arch="arm64" ;;
            armv7l)  arch="armv6" ;;
            *)       arch="amd64" ;;
        esac
        
        log_info "Downloading GitLab CLI for Linux ($arch)..."
        local tmp_file="/tmp/glab.tar.gz"
        local tmp_dir="/tmp/glab_extract"
        
        curl -sL "https://gitlab.com/api/v4/projects/43644822/packages/generic/glab/latest/linux_${arch}.tar.gz" -o "$tmp_file"
        
        if [ -f "$tmp_file" ]; then
            # 清理并创建临时目录
            rm -rf "$tmp_dir"
            mkdir -p "$tmp_dir"
            tar -xzf "$tmp_file" -C "$tmp_dir"
            
            # 查找 glab 可执行文件（可能在根目录或 bin 子目录）
            local glab_bin
            if [ -f "$tmp_dir/bin/glab" ]; then
                glab_bin="$tmp_dir/bin/glab"
            elif [ -f "$tmp_dir/glab" ]; then
                glab_bin="$tmp_dir/glab"
            else
                # 递归查找
                glab_bin=$(find "$tmp_dir" -name "glab" -type f -executable 2>/dev/null | head -1)
            fi
            
            if [ -n "$glab_bin" ] && [ -f "$glab_bin" ]; then
                sudo mv "$glab_bin" /usr/local/bin/
                sudo chmod +x /usr/local/bin/glab
            fi
            
            # 清理
            rm -rf "$tmp_file" "$tmp_dir"
            
            if command_exists glab; then
                log_success "GitLab CLI installed successfully: $(get_version glab)"
                return 0
            else
                log_error "GitLab CLI installation failed"
                return 1
            fi
        else
            log_error "Failed to download GitLab CLI"
            return 1
        fi
    elif [ "$os" = "macos" ]; then
        log_info "Using Homebrew to install GitLab CLI..."
        brew install glab
        
        if command_exists glab; then
            log_success "GitLab CLI installed successfully: $(get_version glab)"
            return 0
        else
            log_error "GitLab CLI installation failed"
            return 1
        fi
    else
        log_error "Unsupported operating system: $os"
        log_info "Please install GitLab CLI manually: https://glab.readthedocs.io/en/latest/install"
        return 1
    fi
}

# 显示缺失依赖信息
show_missing_info() {
    local missing=("$@")
    
    separator "="
    log_warning "Missing dependencies: ${missing[*]}"
    separator "="
}

# 显示手动安装命令
show_manual_install() {
    separator "="
    echo "  Manual Installation Commands"
    separator "="
    echo ""
    
    echo "### Git"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  sudo apt update && sudo apt install -y git"
    echo ""
    echo "macOS:"
    echo "  brew install git"
    echo ""
    
    echo "### GitHub CLI (gh)"
    echo ""
    echo "Ubuntu/Debian:"
    echo "  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo "  echo \"deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
    echo "  sudo apt update && sudo apt install -y gh"
    echo ""
    echo "macOS:"
    echo "  brew install gh"
    echo ""
    
    echo "### GitLab CLI (glab)"
    echo ""
    echo "Linux:"
    echo "  curl -sL https://gitlab.com/api/v4/projects/43644822/packages/generic/glab/latest/linux_amd64.tar.gz -o /tmp/glab.tar.gz"
    echo "  tar -xzf /tmp/glab.tar.gz -C /tmp"
    echo "  sudo mv /tmp/glab /usr/local/bin/"
    echo ""
    echo "macOS:"
    echo "  brew install glab"
    echo ""
}

# 检查 GitHub 认证状态
check_gh_auth() {
    if command_exists gh; then
        gh auth status &>/dev/null
        return $?
    fi
    return 1
}

# 检查 GitLab 认证状态
check_glab_auth() {
    if command_exists glab; then
        glab auth status &>/dev/null
        return $?
    fi
    return 1
}

# 检测平台类型
detect_platform() {
    local remote="$1"
    
    if [[ "$remote" == *"github.com"* ]]; then
        echo "github"
    elif [[ "$remote" == *"gitlab.com"* ]]; then
        echo "gitlab"
    elif [[ "$remote" == *"gitlab."* ]]; then
        # 自托管 GitLab 实例 (gitlab.example.com)
        echo "gitlab"
    else
        echo "unknown"
    fi
}

# 获取仓库 URL（用于浏览器创建 PR/MR）
get_repo_url() {
    local remote="$1"
    # 转换 SSH URL 为 HTTPS URL
    if [[ "$remote" == git@* ]]; then
        # git@github.com:user/repo.git -> https://github.com/user/repo
        echo "$remote" | sed -E 's|git@([^:]+):|https://\1/|; s|\.git$||'
    else
        # 已经是 HTTPS URL
        echo "$remote" | sed 's|\.git$||'
    fi
}

# 引导 GitHub 认证
guide_github_auth() {
    local remote="$1"
    local repo_url
    repo_url=$(get_repo_url "$remote")
    
    log_info "Detected GitHub repository"
    echo ""
    
    if ! command_exists gh; then
        log_warning "GitHub CLI (gh) not installed"
        echo ""
        log_info "Without gh CLI, you need to create PRs manually in browser:"
        echo "  $repo_url/pull/new/BRANCH_NAME"
        echo ""
        return
    fi
    
    if check_gh_auth; then
        log_success "Already authenticated with GitHub"
        echo ""
        return
    fi
    
    log_warning "Not authenticated with GitHub"
    echo ""
    
    ask_choice "How would you like to create Pull Requests?" \
        "Login with gh CLI (recommended)" \
        "Create PRs manually in browser" \
        "Skip for now"
    
    local choice=$?
    echo ""
    
    case $choice in
        1)
            log_step "Starting GitHub authentication..."
            gh auth login
            if check_gh_auth; then
                log_success "GitHub authentication successful!"
            else
                log_warning "Authentication was not completed"
                log_info "You can run 'gh auth login' later"
            fi
            ;;
        2)
            log_info "To create PRs manually:"
            echo "  1. Push your branch: git push origin BRANCH_NAME"
            echo "  2. Visit: $repo_url/pull/new/BRANCH_NAME"
            ;;
        3)
            log_info "Skipped. Run 'gh auth login' when ready"
            ;;
    esac
    echo ""
}

# 引导 GitLab 认证
guide_gitlab_auth() {
    local remote="$1"
    local repo_url
    repo_url=$(get_repo_url "$remote")
    local hostname
    hostname=$(echo "$remote" | sed -E 's|.*@([^:/]+)[:/].*|\1|; s|.*://([^/]+)/.*|\1|')
    
    log_info "Detected GitLab repository"
    if [[ "$hostname" != "gitlab.com" ]]; then
        log_info "Self-hosted instance: $hostname"
    fi
    echo ""
    
    # GitLab 有 git push -o 替代方案，所以即使没有 glab 也可以
    if ! command_exists glab; then
        log_info "GitLab CLI (glab) not installed"
        echo ""
        log_info "You can create MRs without glab using git push options:"
        echo "  git push -o merge_request.create -o merge_request.target=main origin BRANCH"
        echo ""
        log_info "Or create MRs manually in browser:"
        echo "  $repo_url/-/merge_requests/new"
        echo ""
        return
    fi
    
    if check_glab_auth; then
        log_success "Already authenticated with GitLab"
        echo ""
        return
    fi
    
    log_warning "Not authenticated with GitLab"
    echo ""
    
    ask_choice "How would you like to create Merge Requests?" \
        "Login with glab CLI (full features)" \
        "Use git push -o (no auth needed)" \
        "Create MRs manually in browser" \
        "Skip for now"
    
    local choice=$?
    echo ""
    
    case $choice in
        1)
            log_step "Starting GitLab authentication..."
            if [[ "$hostname" != "gitlab.com" ]]; then
                glab auth login --hostname "$hostname"
            else
                glab auth login
            fi
            if check_glab_auth; then
                log_success "GitLab authentication successful!"
            else
                log_warning "Authentication was not completed"
                log_info "You can run 'glab auth login' later"
            fi
            ;;
        2)
            log_success "Great choice! No additional setup needed."
            echo ""
            log_info "To create MRs with push options:"
            echo "  git push -o merge_request.create \\"
            echo "           -o merge_request.target=main \\"
            echo "           -o \"merge_request.title=Your MR Title\" \\"
            echo "           origin BRANCH_NAME"
            echo ""
            log_info "Available options:"
            echo "  -o merge_request.create              - Create MR"
            echo "  -o merge_request.target=<branch>     - Target branch"
            echo "  -o merge_request.title=\"<title>\"     - MR title"
            echo "  -o merge_request.description=\"<desc>\"- MR description"
            echo "  -o merge_request.draft               - Mark as draft"
            echo "  -o merge_request.merge_when_pipeline_succeeds"
            echo "  -o merge_request.remove_source_branch"
            ;;
        3)
            log_info "To create MRs manually:"
            echo "  1. Push your branch: git push origin BRANCH_NAME"
            echo "  2. Visit: $repo_url/-/merge_requests/new"
            ;;
        4)
            log_info "Skipped. You can use 'git push -o' or 'glab auth login' later"
            ;;
    esac
    echo ""
}

# 引导用户认证
guide_authentication() {
    separator "="
    log_step "Authentication Setup"
    separator "="
    echo ""
    
    local remote
    remote=$(get_active_remote)
    local platform
    platform=$(detect_platform "$remote")
    
    case "$platform" in
        github)
            guide_github_auth "$remote"
            ;;
        gitlab)
            guide_gitlab_auth "$remote"
            ;;
        *)
            log_info "Platform not detected from remote URL"
            echo ""
            log_info "Please authenticate with your platform when needed:"
            echo "  - GitHub: gh auth login"
            echo "  - GitLab: glab auth login (or use git push -o)"
            echo ""
            ;;
    esac
}

# 显示完成信息
show_completion() {
    separator "="
    log_success "Setup Complete!"
    separator "="
    echo ""
    
    log_info "You're all set to use the git-workflow skill."
    echo ""
    
    log_step "Quick reference:"
    echo ""
    echo "  GitHub PRs:"
    echo "    gh pr create --title \"...\" --body \"...\" --base main"
    echo ""
    echo "  GitLab MRs (Option 1 - push options):"
    echo "    git push -o merge_request.create -o merge_request.target=main origin BRANCH"
    echo ""
    echo "  GitLab MRs (Option 2 - glab CLI):"
    echo "    glab mr create --title \"...\" --target-branch main"
    echo ""
    
    log_info "For more information, see the documentation:"
    echo "  https://github.com/make-fe-great-again/gitlab-skill-workflow"
    echo ""
}

# 主函数
main() {
    show_welcome
    check_dependencies
    
    local missing
    IFS=' ' read -r -a missing <<< "$(detect_missing_tools)"
    
    if [ ${#missing[@]} -eq 0 ]; then
        log_success "All dependencies are already installed!"
        echo ""
        guide_authentication
        show_completion
        exit 0
    fi
    
    show_missing_info "${missing[@]}"
    
    ask_choice "What would you like to do?" \
        "Install all missing dependencies" \
        "Install Git only" \
        "Install GitHub CLI only" \
        "Install GitLab CLI only" \
        "Show manual installation commands" \
        "Skip installation"
    
    local choice=$?
    
    case $choice in
        1) # Install all
            for tool in "${missing[@]}"; do
                echo ""
                case "$tool" in
                    git) install_git ;;
                    gh) install_gh ;;
                    glab) install_glab ;;
                esac
            done
            ;;
        2) # Install Git
            echo ""
            install_git
            ;;
        3) # Install GitHub CLI
            echo ""
            install_gh
            ;;
        4) # Install GitLab CLI
            echo ""
            install_glab
            ;;
        5) # Show manual commands
            echo ""
            show_manual_install
            exit 0
            ;;
        6) # Skip
            echo ""
            log_warning "Skipping installation. Some dependencies may be missing."
            echo ""
            ;;
    esac
    
    echo ""
    
    # 检查安装结果
    local still_missing=()
    IFS=' ' read -r -a still_missing <<< "$(detect_missing_tools)"
    
    if [ ${#still_missing[@]} -gt 0 ]; then
        log_warning "Some dependencies are still missing: ${still_missing[*]}"
        echo ""
        log_info "You can run this script again later: bash scripts/setup.sh"
        exit 1
    fi
    
    guide_authentication
    show_completion
}

# 运行主函数
main "$@"
