
all: bin dotfiles

init:

bin:
	mkdir -p $(HOME)/bin
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f ); do \
		f=$$(basename $$file); \
		ln -sf $$file $(HOME)/bin/$$f; \
	done

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -depth 1 -not -name ".*" -type f ); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/.$$f; \
	done; \

.PHONY: init bin dotfiles