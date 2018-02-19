# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ZSH_THEME="awesomepanda"
ZSH_THEME="robbyrussell"

plugins=(autojump git brew sublime osx docker)

source $ZSH/oh-my-zsh.sh

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
PROMPT='${ret_status} %{$fg[cyan]%}%2~%{$reset_color%} $(git_prompt_info)'


# aliases
alias zshconfig="subl -n ~/.zshrc"
alias ohmyzsh="subl -n ~/.oh-my-zsh"

if [ -e "$HOME/.secret" ]; then source "$HOME/.secret"; fi
source "$HOME/.path"
source "$HOME/.aliases"
source "$HOME/.functions"
source "$HOME/.keys"

#hub
command -v hub >/dev/null && eval "$(hub alias -s)" || echo "hub Not Found in \$PATH"
command -v hub >/dev/null && alias ghe="GITHUB_HOST=github.bus.zalan.do hub"

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

source /usr/local/bin/aws_zsh_completer.sh

