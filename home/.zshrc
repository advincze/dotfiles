# needed for zsh-completions
# compinit - function initializes Zsh’s completion system
# autoload - tells Zsh to load shell function on demand (-U means “do not try to alias or modify function names")
autoload -U compinit && compinit

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

# load theme
source ~/.theme.zsh

# load devbox managed tools
source ~/.devbox.zsh

# aliases
alias tf="terraform"
alias dk="docker"
alias vs="code"
alias dkc="docker compose"
alias dr="devbox run"
alias ur="uv run"
alias dur="devbox run uv run"
alias k="kubectl"

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
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
# Show/hide hidden files in the Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"


#keys
bindkey "\e\e[D" backward-word 			#option+left
bindkey "\e\e[C" forward-word 			#option+right
bindkey "^[[3~" backward-kill-word 		#fn+delete

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/a77055/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

function clone() {
  local git_url=$1
  local base_dir=~/src2

  if [[ -z "$git_url" ]]; then
    echo "Usage: git_clone_with_hierarchy <git_url>"
    return 1
  fi

  # Extract the host and path from the git URL
  if [[ $git_url =~ ^git@([^:]+):(.*)$ ]]; then
    local host=${match[1]}
    local repo_path=${match[2]}
    # Remove 'ssh.' prefix if it exists
    host=${host#ssh.}
  elif [[ $git_url =~ ^ssh://git@([^:/]+)(:[0-9]+)?/(.*)$ ]]; then
    local host=${match[1]}
    local repo_path=${match[3]}
    # Remove 'ssh.' prefix if it exists
    host=${host#ssh.}
  else
    echo "Unsupported git URL format: $git_url"
    return 1
  fi

  # Determine the full local path for cloning
  local full_path="$base_dir/$host/${repo_path%.*}"

  # Create the directory hierarchy if it doesn't exist
  mkdir -p "$(dirname "$full_path")"

  # Clone the repository
  git clone "$git_url" "$full_path"
}
