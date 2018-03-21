
all: bin dotfiles

init: bin dotfiles
	cd init
	./init.sh
	
bin:
	#mkdir -p $(HOME)/bin && stow bin -t $(HOME)/bin

dotfiles:
	stow -R git -t $(HOME)
	stow -R curl -t $(HOME)
	stow -R shell -t $(HOME)

.PHONY: init bin dotfiles