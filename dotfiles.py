# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "click",
#     "pyyaml",
# ]
# ///

import click
import yaml
import shutil
import subprocess
from pathlib import Path

REPO_DIR = Path(__file__).parent.resolve()
HOME_DIR = Path.home()
HOME_SUBDIR = REPO_DIR / "home"
DEVBOX_SUBDIR = REPO_DIR / "devbox"
BREW_SUBDIR = REPO_DIR / "brew"
CONFIG_PATH = REPO_DIR / "config.yml"

with CONFIG_PATH.open() as f:
    config = yaml.safe_load(f)
DOTFILES = config["dotfiles"]

BREWFILE = BREW_SUBDIR / "Brewfile"
DEVBOX_GLOBAL_JSON = Path(
    subprocess.check_output(["devbox", "global", "path"], text=True).strip()
) / "devbox.json"
DEVBOX_REPO_JSON = DEVBOX_SUBDIR / "devbox.json"


@click.group(help="Manage your dotfiles, devbox config, and Brewfile.")
def cli():
    HOME_SUBDIR.mkdir(exist_ok=True)
    DEVBOX_SUBDIR.mkdir(exist_ok=True)
    BREW_SUBDIR.mkdir(exist_ok=True)


@cli.command(help="Copy local dotfiles to repo, devbox.json, and dump Brewfile.")
def backup():
    for path in DOTFILES:
        src = HOME_DIR / path
        dst = HOME_SUBDIR / path
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
    shutil.copy2(DEVBOX_GLOBAL_JSON, DEVBOX_REPO_JSON)
    subprocess.run(["brew", "bundle", "dump", "--force", "--file", str(BREWFILE)], check=True)


@cli.group(help="Install dotfiles, brew packages, devbox.json, or all at once.")
def install():
    pass


@install.command(help="Install dotfiles from repo back to your home directory.")
def dotfiles():
    for path in DOTFILES:
        src = HOME_SUBDIR / path
        dst = HOME_DIR / path
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)


@install.command(help="Install or update Homebrew packages from Brewfile.")
def brew():
    subprocess.run(["brew", "bundle", "--file", str(BREWFILE)], check=True)


@install.command(help="Install devbox.json to devbox global path.")
def devbox():
    DEVBOX_GLOBAL_JSON.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(DEVBOX_REPO_JSON, DEVBOX_GLOBAL_JSON)


@install.command(name="all", help="Install dotfiles, brew packages, and devbox.json in sequence.")
def install_all():
    dotfiles()
    brew()
    devbox()


def main():
    cli()


if __name__ == "__main__":
    main()
