#!/usr/bin/env bash
#
# A dotfiles management script where 'install' has subcommands:
#   install dotfiles   - Install dotfiles from home/ to $HOME
#   install brew       - Install Homebrew packages from brew/Brewfile
#   install devbox     - Copy devbox/devbox.json to global devbox path
#   install all        - Do all of the above in sequence
#
# Other Commands:
#   backup             - Copy local dotfiles ($HOME) into home/, plus dump Brewfile, copy devbox.json, etc.
#
# Git is NOT automatic. Pull before install, and add/commit/push after backup.

set -euo pipefail

#######################################
# 1. Load config.sh (Defines DOTFILES array)
#######################################
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -f "$DOTFILES_DIR/config.sh" ]]; then
  echo "Error: config.sh not found. Please create config.sh with a DOTFILES array."
  exit 1
fi
# shellcheck disable=SC1091
source "$DOTFILES_DIR/config.sh"

#######################################
# 2. Subfolders
#######################################
HOME_SUBDIR="$DOTFILES_DIR/home"
DEVBOX_SUBDIR="$DOTFILES_DIR/devbox"
BREW_SUBDIR="$DOTFILES_DIR/brew"

mkdir -p "$HOME_SUBDIR" "$DEVBOX_SUBDIR" "$BREW_SUBDIR"

#######################################
# 3. Devbox Setup
#######################################
if command -v devbox &>/dev/null; then
  DEVBOX_INSTALLED=true
  DEVBOX_GLOBAL_JSON="$(devbox global path)/devbox.json"
else
  DEVBOX_INSTALLED=false
fi
DEVBOX_REPO_JSON="$DEVBOX_SUBDIR/devbox.json"

#######################################
# 4. Homebrew Brewfile
#######################################
BREWFILE="$BREW_SUBDIR/Brewfile"

#######################################
# Usage
#######################################
usage() {
  cat <<EOF
Usage: $(basename "$0") <command> [subcommand]

Commands:
  backup
    Copy local dotfiles from \$HOME into home/, copy devbox.json, dump Brewfile.

  install <subcommand>
    Subcommands:
      dotfiles  - Copy dotfiles from home/ -> \$HOME
      brew      - Install or update Homebrew packages (brew/Brewfile)
      devbox    - Copy devbox/devbox.json -> global devbox path
      all       - Do dotfiles, brew, devbox in sequence

Example:
  ./sync-dotfiles.sh backup
  ./sync-dotfiles.sh install dotfiles
  ./sync-dotfiles.sh install all

No Git commands are run automatically.
EOF
  exit 1
}

#######################################
# backup: from $HOME => home/
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
  echo "=== BACKUP: Copying devbox.json if devbox is installed ==="
  if [[ "$DEVBOX_INSTALLED" == true && -f "$DEVBOX_GLOBAL_JSON" ]]; then
    cp "$DEVBOX_GLOBAL_JSON" "$DEVBOX_REPO_JSON"
    echo "  Copied $DEVBOX_GLOBAL_JSON -> $DEVBOX_REPO_JSON"
  else
    echo "  Warning: devbox not installed or devbox.json not found. Skipping..."
  fi

  echo
  echo "=== BACKUP: Dumping installed Homebrew packages into '$BREWFILE' ==="
  brew bundle dump --force --file="$BREWFILE"

  echo
  echo "=== Backup complete! (You may now git add/commit/push.) ==="
}

#######################################
# install_changes: DOTFILES from home/ => $HOME
#######################################
install_dotfiles() {
  echo "=== INSTALL: DOTFILES from '$HOME_SUBDIR' to \$HOME ==="
  for rel_path in "${DOTFILES[@]}"; do
    repo_path="$HOME_SUBDIR/$rel_path"
    local_path="$HOME/$rel_path"
    if [[ -f "$repo_path" ]]; then
      echo "  Copying $repo_path -> $local_path"
      mkdir -p "$(dirname "$local_path")"
      cp "$repo_path" "$local_path"
    else
      echo "  Warning: '$repo_path' not found in repo. Skipping..."
    fi
  done
  echo "=== Dotfiles install complete! ==="
}

#######################################
# install_brew: from brew/Brewfile => local Homebrew
#######################################
install_brew() {
  echo "=== INSTALL: BREW packages from '$BREWFILE' ==="
  if [[ -f "$BREWFILE" ]]; then
    brew bundle --file="$BREWFILE"
  else
    echo "  Warning: Brewfile not found at '$BREWFILE'. Skipping..."
  fi
  echo "=== Brew packages install complete! ==="
}

#######################################
# install_devbox: from devbox/devbox.json => global devbox path
#######################################
install_devbox() {
  if [[ "$DEVBOX_INSTALLED" != true ]]; then
    echo "Error: Devbox is not installed or not found in PATH."
    exit 1
  fi

  echo "=== INSTALL: DEVBOX config from '$DEVBOX_REPO_JSON' => '$DEVBOX_GLOBAL_JSON' ==="
  if [[ -f "$DEVBOX_REPO_JSON" ]]; then
    mkdir -p "$(devbox global path)"
    cp "$DEVBOX_REPO_JSON" "$DEVBOX_GLOBAL_JSON"
    echo "  Copied $DEVBOX_REPO_JSON -> $DEVBOX_GLOBAL_JSON"
  else
    echo "  Warning: '$DEVBOX_REPO_JSON' not found. Skipping..."
  fi
  echo "=== Devbox install complete! ==="
}

#######################################
# dispatch_install: calls subcommands
#######################################
dispatch_install() {
  if [[ $# -lt 2 ]]; then
    usage
  fi

  local subcommand="$2"
  case "$subcommand" in
    dotfiles)
      install_dotfiles
      ;;
    brew)
      install_brew
      ;;
    devbox)
      install_devbox
      ;;
    all)
      install_dotfiles
      install_brew
      install_devbox
      ;;
    *)
      usage
      ;;
  esac
}

#######################################
# Main CLI
#######################################
if [[ $# -lt 1 ]]; then
  usage
fi

case "$1" in
  backup)
    backup_changes
    ;;
  install)
    # Delegates to dispatch_install to handle "dotfiles", "brew", "devbox", or "all"
    dispatch_install "$@"
    ;;
  *)
    usage
    ;;
esac
