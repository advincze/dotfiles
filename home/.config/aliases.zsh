
alias tf="terraform"
alias dk="docker"
alias dkc="docker compose"
alias dr="devbox run"
alias ur="uv run"
alias dur="devbox run uv run"
alias k="kubectl"
alias j="__zoxide_z"

alias reload="source ~/.zshrc"
alias o="open"
alias oo="open ."
alias mv='mv -v'
alias cp='cp -v'

# directories
alias -g ..='cd ..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'
alias -- -='cd -'

alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls -G'
alias md='mkdir -p'
alias gss='git status --short'
alias gco='git checkout '
alias gcb='git checkout -b'
alias gcam='git commit -am'
alias gd='git diff'
alias gnuke='git clean -fdx -e .env -e .envrc'
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
# Show/hide hidden files in the Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
