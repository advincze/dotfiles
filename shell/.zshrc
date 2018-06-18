# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# ZSH_THEME="awesomepanda"
ZSH_THEME="robbyrussell"

plugins=(autojump git brew sublime osx docker)

source $ZSH/oh-my-zsh.sh

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
PROMPT='${ret_status} %{$fg[cyan]%}%2~%{$reset_color%} $(git_prompt_info)'


if [ -e "$HOME/.secret" ]; then source "$HOME/.secret"; fi
# path
export PATH=$PATH:$HOME/bin:$HOME/go/bin

#aliases
alias ..="cd .."
alias g="git"
alias h="history"
alias oo="open ."
alias o="open"
alias ss="subl ."
alias dk="docker"
alias dkc="docker-compose"
alias mv='mv -v'
alias cp='cp -v'
# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"
alias tf=terraform
alias vs="code ."
alias uuid="uuidgen | tr '[:upper:]' '[:lower:]'"
alias goget="go get -u -v"
alias zk=zkubectl
alias k=kubectl



# Determine size of a file or total size of a directory
fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}

docker-cleanup() {
	docker rm $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
	docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

gotemp() {
  PKG_DIR="/tmp/go/src/test"$(date +%Y%m%d%H%M%S)
  GOPATH=${GOPATH}:/tmp/go
  mkdir -p $PKG_DIR
  cat>$PKG_DIR/main.go<<EOF
package main

import "fmt"

func main() {
  fmt.Println("tmp")
}
EOF

  cat>$PKG_DIR/main_test.go<<EOF
package main

import "testing"

func TestFoo(t *testing.T) {
  t.Errorf("test fail")
}
EOF

  cd $PKG_DIR
}

func s3cat() {
  TM=`mktemp -d` && aws s3 cp --recursive $1 $TM > /dev/null  && cat $TM/*
}

#keys
bindkey "\e\e[D" backward-word 			#option+left
bindkey "\e\e[C" forward-word 			#option+right
bindkey "^[[3~" backward-kill-word 		#fn+delete


#hub
command -v hub >/dev/null && eval "$(hub alias -s)" || echo "hub Not Found in \$PATH"
command -v hub >/dev/null && alias ghe="GITHUB_HOST=github.bus.zalan.do hub"

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

source /usr/local/bin/aws_zsh_completer.sh

eval "$(rbenv init -)"
