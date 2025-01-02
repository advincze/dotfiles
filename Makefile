
.PHONY: test
test:
	devbox run zunit run tests

.PHONY: backup
backup:
	devbox run uv run dotfiles.py backup

.PHONY: restore
restore:
	devbox run uv run dotfiles.py restore all --dry-run
