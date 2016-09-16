
all: bin dotfiles

init: bin dotfiles
	cd init
	./init.sh
	
bin:
	#mkdir -p $(HOME)/bin && stow bin -t $(HOME)/bin

dotfiles:
	stow git -t $(HOME)
	stow curl -t $(HOME)
	stow shell -t $(HOME)

.PHONY: init bin dotfiles