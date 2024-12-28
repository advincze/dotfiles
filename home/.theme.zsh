# Enable extended globbing and prompt expansion features
autoload -U colors && colors
setopt prompt_subst

# === Colors ===
COLOR_RESET="%{$reset_color%}"
COLOR_BOLD_RED="%{$fg_bold[red]%}"
COLOR_BOLD_GREEN="%{$fg_bold[green]%}"
COLOR_BOLD_BLUE="%{$fg_bold[blue]%}"
COLOR_RED="%{$fg[red]%}"
COLOR_BLUE="%{$fg[blue]%}"
COLOR_YELLOW="%{$fg[yellow]%}"
COLOR_CYAN="%{$fg[cyan]%}"

# === Prompt Symbols ===
SYMBOL_PROMPT_OK="➜"
SYMBOL_PROMPT_ERROR="➜"
SYMBOL_GIT_DIRTY="✗"

# === Git Prompt Configuration ===
ZSH_THEME_GIT_PROMPT_PREFIX="${COLOR_BOLD_BLUE}(${COLOR_RED}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${COLOR_RESET}"
ZSH_THEME_GIT_PROMPT_DIRTY="${COLOR_BLUE}) ${COLOR_YELLOW}${SYMBOL_GIT_DIRTY}"
ZSH_THEME_GIT_PROMPT_CLEAN="${COLOR_BLUE})"

# === Git Prompt Function ===
git_prompt_info() {
  # Check if we're in a Git repo
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    # Get the current branch or tag
    local ref
    ref="$(git symbolic-ref HEAD 2>/dev/null)" \
      || ref="$(git describe --tags --exact-match HEAD 2>/dev/null)" \
      || ref="$(git describe --all HEAD 2>/dev/null)"
    ref="${ref#refs/heads/}"

    # Check for uncommitted changes
    if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
      # Dirty
      echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${ZSH_THEME_GIT_PROMPT_DIRTY}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
    else
      # Clean
      echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${ZSH_THEME_GIT_PROMPT_CLEAN}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
    fi
  fi
}

# === Main Prompt ===
# %(?...) checks exit status: if 0, use SYMBOL_PROMPT_OK; otherwise, SYMBOL_PROMPT_ERROR.
PROMPT='%(?:'
PROMPT+="${COLOR_BOLD_GREEN}${SYMBOL_PROMPT_OK}"
PROMPT+=' :'
PROMPT+="${COLOR_BOLD_RED}${SYMBOL_PROMPT_ERROR}"
PROMPT+=')'

# Add the current directory (truncated to 2 levels) in cyan and reset color.
PROMPT+="${COLOR_CYAN}%2~${COLOR_RESET}"

# Call our Git function
PROMPT+='$(git_prompt_info) '

# That's it! Reload your shell or source this file to see your new prompt.
