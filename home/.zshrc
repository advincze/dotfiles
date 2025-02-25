# needed for zsh-completions
# compinit - function initializes Zsh’s completion system
# autoload - tells Zsh to load shell function on demand (-U means “do not try to alias or modify function names")
autoload -U compinit && compinit

export LC_ALL=en_US.utf-8
export LANG=en_US.utf-8

# load theme
source ~/.config/theme.zsh

# load devbox managed tools
source ~/.config/devbox.zsh

# functions and aliases
source ~/.config/functions.zsh
source ~/.config/aliases.zsh

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
export DOCKER_HOST=unix://$HOME/.rd/docker.sock
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
# export TESTCONTAINERS_HOST_OVERRIDE=$(rdctl shell ip a show vznat | awk '/inet / {sub("/.*",""); print $2}')
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
