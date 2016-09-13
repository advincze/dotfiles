#!/bin/bash

# ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh


# brew
# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle


#node 

# fancy git diff
npm install -g diff-so-fancy


#golang
go get -u -v github.com/hirokidaichi/goviz
go get -u -v github.com/nsf/gocode
go get -u -v golang.org/x/tools/...
go get -u -v github.com/gorilla/mux
go get -u -v github.com/kardianos/govendor
go get -u -v github.com/cespare/reflex
go get -u -v github.com/davecgh/go-spew/spew #golang struct pretty printer lib
go get -u -v github.com/pkg/errors

./osx.sh