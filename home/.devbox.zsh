# activate devbox global
eval "$(devbox global shellenv --init-hook)"

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
zstyle ':completion:*' menu yes select