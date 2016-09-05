
all: bin dotfiles

init:
	cd init
	./init.sh
	
bin:
	stow bin -t $(HOME)/bin

dotfiles:
	stow git -t $(HOME)
	stow curl -t $(HOME)
	stow shell -t $(HOME)

.PHONY: init bin dotfiles