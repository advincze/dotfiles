
all: dotfiles

dotfiles:
	stow -R git -t $(HOME)
	stow -R curl -t $(HOME)
	stow -R shell -t $(HOME)

.PHONY: dotfiles