#!/bin/bash
# install.sh - 一键安装脚本
# 安装 git-workflow skill 到当前项目

set -e

# 颜色定义
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_RESET='\033[0m'

# 脚本参数
FORCE=false
VERBOSE=false

# 日志函数
log_info() {
    echo -e "${COLOR_CYAN}ℹ${COLOR_RESET} $*"
}

log_success() {
    echo -e "${COLOR_GREEN}✓${COLOR_RESET} $*"
}

log_warning() {
    echo -e "${COLOR_YELLOW}⚠${COLOR_RESET} $*"
}

log_error() {
    echo -e "${COLOR_RED}✗${COLOR_RESET} $*" >&2
}

log_verbose() {
    if [ "$VERBOSE" = true ]; then
        echo -e "${COLOR_BLUE}•${COLOR_RESET} $*"
    fi
}

log_step() {
    echo -e "${COLOR_BLUE}▸${COLOR_RESET} $*"
}

# 显示帮助信息
show_help() {
    cat << EOF
Git Workflow Skill - Installation Script

USAGE:
    bash install.sh [OPTIONS]

OPTIONS:
    --force, -f      Force overwrite existing files
    --verbose, -v    Show detailed installation progress
    --help, -h       Show this help message

DESCRIPTION:
    This script installs the git-workflow skill into your current project.
    It will create the following files and directories:
        - .opencode/skill/git-workflow/SKILL.md
        - scripts/setup.sh
        - scripts/lib/utils.sh
        - .github/ (optional)
        - .gitlab/ (optional)

EXAMPLES:
    bash install.sh
    bash install.sh --force
    bash install.sh --verbose

EOF
}

# 显示欢迎信息
show_welcome() {
    echo ""
    separator "="
    echo -e "  ${COLOR_CYAN}Git Workflow Skill${COLOR_RESET} - Installation"
    separator "="
    echo ""
}

# 显示分割线
separator() {
    local width=60
    local char="${1:-─}"
    printf "$(printf '%*s' "$width" | tr ' ' "$char")\n"
}

# 检测是否在 git 仓库中
check_git_repo() {
    if [ ! -d ".git" ] && ! git rev-parse --git-dir &>/dev/null; then
        log_error "Not in a git repository"
        log_info "Please run this script in a git repository"
        exit 1
    fi
    log_verbose "Git repository detected"
}

# 复制文件或目录
copy_file() {
    local src="$1"
    local dst="$2"
    
    if [ -e "$dst" ]; then
        if [ "$FORCE" = true ]; then
            log_warning "Overwriting: $dst"
            rm -rf "$dst"
            cp -r "$src" "$dst"
            log_success "Overwritten: $dst"
        else
            log_verbose "Skipping (already exists): $dst"
            return 1
        fi
    else
        cp -r "$src" "$dst"
        log_success "Created: $dst"
    fi
    
    return 0
}

# 安装核心文件
install_core_files() {
    separator "="
    log_info "Installing core files..."
    separator "="
    echo ""
    
    # 获取脚本所在目录
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    # 检查源文件是否存在 (Agent Skills 格式)
    if [ ! -f "$script_dir/skills/git-workflow/SKILL.md" ]; then
        log_error "Source files not found in: $script_dir"
        log_info "Please ensure you're running install.sh from the gitlab-skill-workflow directory"
        exit 1
    fi
    
    # 创建目录 (默认安装到 .opencode/skill/)
    mkdir -p .opencode/skill/git-workflow
    mkdir -p scripts/lib
    
    # 复制 SKILL.md
    copy_file "$script_dir/skills/git-workflow/SKILL.md" \
              ".opencode/skill/git-workflow/SKILL.md"
    
    # 复制 setup.sh 和 utils.sh
    copy_file "$script_dir/skills/git-workflow/scripts/setup.sh" "scripts/setup.sh"
    copy_file "$script_dir/skills/git-workflow/scripts/lib/utils.sh" "scripts/lib/utils.sh"
    
    # 设置可执行权限
    chmod +x scripts/setup.sh 2>/dev/null || true
    
    echo ""
}

# 询问是否复制平台模板
ask_templates() {
    separator "="
    log_info "Platform templates (optional)"
    separator "="
    echo ""
    
    log_info "Platform-specific templates for PR/MR descriptions:"
    echo "  • GitHub: .github/pull_request_template.md"
    echo "  • GitLab: .gitlab/merge_request_templates/default.md"
    echo ""
    
    # 检测是否已有模板
    local has_github=false
    local has_gitlab=false
    
    if [ -d ".github" ]; then
        has_github=true
        log_verbose "Found existing .github directory"
    fi
    if [ -d ".gitlab" ]; then
        has_gitlab=true
        log_verbose "Found existing .gitlab directory"
    fi
    
    if [ "$has_github" = false ] && [ "$has_gitlab" = false ]; then
        # 两个目录都不存在，询问是否创建
        if ask_yes_no "Copy platform templates?" "y"; then
            # 复制两个平台的模板
            copy_templates "true" "true"
            return 0
        else
            return 1
        fi
    else
        # 已有目录，详细询问
        local copy_github=false
        local copy_gitlab=false
        
        if [ "$has_github" = true ]; then
            if ask_yes_no "Copy GitHub templates (will skip existing files)?" "n"; then
                copy_github=true
            fi
        else
            if ask_yes_no "Copy GitHub templates?" "n"; then
                copy_github=true
            fi
        fi
        
        if [ "$has_gitlab" = true ]; then
            if ask_yes_no "Copy GitLab templates (will skip existing files)?" "n"; then
                copy_gitlab=true
            fi
        else
            if ask_yes_no "Copy GitLab templates?" "n"; then
                copy_gitlab=true
            fi
        fi
        
        if [ "$copy_github" = false ] && [ "$copy_gitlab" = false ]; then
            log_verbose "Skipping platform templates"
            return 1
        fi
        
        echo ""
        copy_templates "$copy_github" "$copy_gitlab"
        return 0
    fi
}

# 复制平台模板
copy_templates() {
    local copy_github="$1"
    local copy_gitlab="$2"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [ "$copy_github" = true ]; then
        if [ ! -d "$script_dir/templates/github" ]; then
            log_warning "GitHub templates directory not found"
        else
            log_info "Copying GitHub templates..."
            
            # 创建目录
            mkdir -p .github
            mkdir -p .github/workflows
            
            # 复制文件（跳过已存在的）
            if [ -f "$script_dir/templates/github/pull_request_template.md" ]; then
                copy_file "$script_dir/templates/github/pull_request_template.md" \
                          ".github/pull_request_template.md" 2>/dev/null || true
            fi
            
            if [ -d "$script_dir/templates/github/workflows" ]; then
                for file in "$script_dir/templates/github/workflows"/*; do
                    if [ -f "$file" ]; then
                        copy_file "$file" ".github/workflows/$(basename "$file")" 2>/dev/null || true
                    fi
                done
            fi
        fi
    fi
    
    if [ "$copy_gitlab" = true ]; then
        if [ ! -d "$script_dir/templates/gitlab" ]; then
            log_warning "GitLab templates directory not found"
        else
            log_info "Copying GitLab templates..."
            
            # 创建目录
            mkdir -p .gitlab/merge_request_templates
            
            # 复制文件（跳过已存在的）
            if [ -d "$script_dir/templates/gitlab/merge_request_templates" ]; then
                for file in "$script_dir/templates/gitlab/merge_request_templates"/*; do
                    if [ -f "$file" ]; then
                        copy_file "$file" ".gitlab/merge_request_templates/$(basename "$file")" 2>/dev/null || true
                    fi
                done
            fi
        fi
    fi
    
    echo ""
}

# 检测是否为交互式终端
is_interactive() {
    [ -t 0 ]
}

# 是/否询问函数
ask_yes_no() {
    local prompt="$1"
    local default="${2:-n}"
    
    # 非交互式环境直接返回默认值
    if ! is_interactive; then
        if [ "$default" = "y" ]; then
            return 0
        else
            return 1
        fi
    fi
    
    local default_str
    if [ "$default" = "y" ]; then
        default_str="[Y/n]"
    else
        default_str="[y/N]"
    fi
    
    while true; do
        read -t 30 -p "$prompt $default_str: " response || {
            # 超时，使用默认值
            echo ""
            if [ "$default" = "y" ]; then
                return 0
            else
                return 1
            fi
        }
        response="${response:-$default}"
        
        case "$response" in
            [Yy]|[Yy][Ee][Ss])
                return 0
                ;;
            [Nn]|[Nn][Oo])
                return 1
                ;;
            *)
                log_error "Please answer yes or no"
                ;;
        esac
    done
}

# 显示安装完成信息
show_completion() {
    separator "="
    log_success "Installation complete!"
    separator "="
    echo ""
    
    log_info "The git-workflow skill has been installed."
    echo ""
}

# 运行 setup.sh 进行依赖安装和认证
run_setup() {
    if [ ! -f "scripts/setup.sh" ]; then
        log_warning "scripts/setup.sh not found, skipping setup"
        return 1
    fi
    
    echo ""
    log_info "Setup will check dependencies and guide you through authentication."
    log_info "This is required for full MR template support on GitLab."
    echo ""
    
    if ask_yes_no "Run setup now?" "y"; then
        echo ""
        bash scripts/setup.sh
        return 0
    else
        echo ""
        log_info "You can run setup later with:"
        echo "  ${COLOR_CYAN}bash scripts/setup.sh${COLOR_RESET}"
        echo ""
        return 1
    fi
}

# 显示使用说明
show_usage() {
    log_step "How to use:"
    echo "  ${COLOR_CYAN}skill({ name: 'git-workflow' })${COLOR_RESET}"
    echo ""
    
    log_info "For more information, see:"
    echo "  https://github.com/make-fe-great-again/gitlab-skill-workflow"
    echo ""
}

# 解析参数（必须在函数定义之后）
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo -e "${COLOR_RED}Error${COLOR_RESET}: Unknown option $1"
            echo "Use --help to see available options"
            exit 1
            ;;
    esac
done

# 主函数
main() {
    show_welcome
    check_git_repo
    install_core_files
    
    # 询问是否复制模板（如果 templates 目录存在）
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    if [ -d "$script_dir/templates" ]; then
        if ask_templates; then
            # templates 参数为 true，但需要在 ask_templates 内部处理复制逻辑
            # 这里简化处理，只调用函数
            true
        fi
    else
        log_verbose "Templates directory not found, skipping template installation"
    fi
    
    show_completion
    
    # 询问是否运行 setup.sh 进行依赖安装和认证
    run_setup
    
    # 显示使用说明
    show_usage
}

# 运行主函数
main "$@"
