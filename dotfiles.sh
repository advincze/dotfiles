#!/usr/bin/env bash
#
# A script for a more structured dotfiles repo:
#  - home/    : mirrors your $HOME structure (e.g., .config/karabiner/karabiner.json)
#  - devbox/  : holds devbox.json
#  - brew/    : holds Brewfile
#
# Subcommands:
#   backup         - Copy local dotfiles from $HOME into home/, dump Brewfile, etc.
#   install        - Copy dotfiles from home/ back into $HOME.
#   install-brew   - Install or update Homebrew packages from brew/Brewfile.
#   install-devbox - Copy devbox/devbox.json into global Devbox path (if Devbox installed).
#
# This script does NOT automatically perform any 'git pull', 'git add', 'git commit',
# or 'git push'. That’s up to you.

set -euo pipefail

#######################################
# Repository Structure
#######################################

# Where this script lives (root of the dotfiles repo)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Subfolders under the repo
HOME_SUBDIR="$DOTFILES_DIR/home"
DEVBOX_SUBDIR="$DOTFILES_DIR/devbox"
BREW_SUBDIR="$DOTFILES_DIR/brew"

# Ensure subfolders exist
mkdir -p "$HOME_SUBDIR" "$DEVBOX_SUBDIR" "$BREW_SUBDIR"

#######################################
# Files We Manage
#######################################
# These are paths *relative* to $HOME. For example:
#   .zshrc                => $HOME/.zshrc
#   .config/karabiner/karabiner.json => $HOME/.config/karabiner/karabiner.json
DOTFILES=(
  ".zshrc"
  ".devbox.zsh"
  ".theme.zsh"
  ".gitignore_global"
  ".config/karabiner/karabiner.json"
)

# Devbox setup
if command -v devbox &>/dev/null; then
  DEVBOX_INSTALLED=true
  DEVBOX_GLOBAL_JSON="$(devbox global path)/devbox.json"
else
  DEVBOX_INSTALLED=false
fi

# We'll store devbox.json in devbox/devbox.json
DEVBOX_REPO_JSON="$DEVBOX_SUBDIR/devbox.json"

# Homebrew Brewfile location in the repo
BREWFILE="$BREW_SUBDIR/Brewfile"

#######################################
# Helper: show usage
#######################################
usage() {
  cat <<-EOF
Usage: $(basename "$0") [backup|install|install-brew|install-devbox]

Commands:
  backup         Copy local dotfiles from \$HOME into home/, also copy devbox.json
                 if present, and dump Homebrew packages into brew/Brewfile.
  install        Copy dotfiles from home/ back to \$HOME (mirroring the structure).
  install-brew   Install or update Homebrew packages from brew/Brewfile.
  install-devbox Copy devbox/devbox.json to your global Devbox path (if Devbox installed).

No Git commands are run automatically—commit/push/pull as needed.
EOF
  exit 1
}

#######################################
# backup: from $HOME => repo
#######################################
backup_changes() {
  echo "=== BACKUP: Copying dotfiles from \$HOME into '$HOME_SUBDIR' ==="
  for rel_path in "${DOTFILES[@]}"; do
    local_path="$HOME/$rel_path"
    repo_path="$HOME_SUBDIR/$rel_path"
    if [[ -f "$local_path" ]]; then
      echo "  Copying $local_path -> $repo_path"
      mkdir -p "$(dirname "$repo_path")"
      cp "$local_path" "$repo_path"
    else
      echo "  Warning: '$local_path' not found. Skipping..."
    fi
  done

  echo
  echo "=== BACKUP: Copying devbox.json (if Devbox is installed) ==="
  if [[ "$DEVBOX_INSTALLED" == true && -f "$DEVBOX_GLOBAL_JSON" ]]; then
    mkdir -p "$DEVBOX_SUBDIR"
    cp "$DEVBOX_GLOBAL_JSON" "$DEVBOX_REPO_JSON"
    echo "  Copied $DEVBOX_GLOBAL_JSON -> $DEVBOX_REPO_JSON"
  else
    echo "  Warning: devbox not installed or no devbox.json found. Skipping..."
  fi

  echo
  echo "=== BACKUP: Dumping installed Homebrew packages into '$BREWFILE' ==="
  brew bundle dump --force --file="$BREWFILE"

  echo
  echo "=== Backup complete! (Manually git add/commit/push if desired.) ==="
}

#######################################
# install: from repo => $HOME
#######################################
install_changes() {
  echo "=== INSTALL: Copying dotfiles from '$HOME_SUBDIR' back to \$HOME ==="
  for rel_path in "${DOTFILES[@]}"; do
    repo_path="$HOME_SUBDIR/$rel_path"
    local_path="$HOME/$rel_path"
    if [[ -f "$repo_path" ]]; then
      echo "  Copying $repo_path -> $local_path"
      mkdir -p "$(dirname "$local_path")"
      cp "$repo_path" "$local_path"
    else
      echo "  Warning: '$repo_path' not found. Skipping..."
    fi
  done

  echo
  echo "=== INSTALL complete! (For Brew, run 'install-brew'. For Devbox, run 'install-devbox'.) ==="
}

#######################################
# install-brew: from brew/Brewfile => local Homebrew
#######################################
install_brew_changes() {
  echo "=== INSTALL-BREW: Installing or updating Homebrew packages from '$BREWFILE' ==="
  if [[ -f "$BREWFILE" ]]; then
    brew bundle --file="$BREWFILE"
  else
    echo "  Warning: Brewfile not found at '$BREWFILE'. Skipping..."
  fi
  echo "=== Done installing Homebrew packages! ==="
}

#######################################
# install-devbox: from devbox/devbox.json => global devbox path
#######################################
install_devbox_changes() {
  if [[ "$DEVBOX_INSTALLED" != true ]]; then
    echo "Error: Devbox is not installed or not found in PATH."
    exit 1
  fi

  echo "=== INSTALL-DEVBOX: Copying devbox.json from '$DEVBOX_REPO_JSON' to '$DEVBOX_GLOBAL_JSON' ==="
  if [[ -f "$DEVBOX_REPO_JSON" ]]; then
    mkdir -p "$(devbox global path)"
    cp "$DEVBOX_REPO_JSON" "$DEVBOX_GLOBAL_JSON"
    echo "  Copied $DEVBOX_REPO_JSON -> $DEVBOX_GLOBAL_JSON"
  else
    echo "  Warning: '$DEVBOX_REPO_JSON' not found. Skipping..."
  fi

  echo "=== Done installing devbox.json! ==="
}

#######################################
# Main: parse subcommand
#######################################
if [[ $# -lt 1 ]]; then
  usage
fi

case "$1" in
  backup)
    backup_changes
    ;;
  install)
    install_changes
    ;;
  install-brew)
    install_brew_changes
    ;;
  install-devbox)
    install_devbox_changes
    ;;
  *)
    usage
    ;;
esac
