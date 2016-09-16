# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ZSH_THEME="awesomepanda"
ZSH_THEME="robbyrussell"

plugins=(autojump git brew sublime osx docker)

source $ZSH/oh-my-zsh.sh

# aliases
alias zshconfig="subl -n ~/.zshrc"
alias ohmyzsh="subl -n ~/.oh-my-zsh"

source "$HOME/.path"
source "$HOME/.aliases"
source "$HOME/.functions"
source "$HOME/.keys"

#hub
command -v hub >/dev/null && eval "$(hub alias -s)" || echo "hub Not Found in \$PATH"

#fuck
command -v thefuck >/dev/null && eval $(thefuck --alias) || echo "thefuck Not Found in \$PATH"
