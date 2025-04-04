# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "click",
#     "pyyaml",
# ]
# ///

import shutil
import subprocess
import tempfile
from pathlib import Path

import click
import yaml

REPO_DIR = Path(__file__).parent.resolve()
HOME_DIR = Path.home()
HOME_SUBDIR = REPO_DIR / "home"
BREW_SUBDIR = REPO_DIR / "brew"
CONFIG_PATH = REPO_DIR / "config.yml"

with CONFIG_PATH.open() as f:
    config = yaml.safe_load(f)
DOTFILES = config["dotfiles"]

BREWFILE = BREW_SUBDIR / "Brewfile"


@click.group(help="Manage your dotfiles, devbox config, and Brewfile.")
def cli():
    HOME_SUBDIR.mkdir(exist_ok=True)
    BREW_SUBDIR.mkdir(exist_ok=True)


@cli.command(help="Copy local dotfiles to repo, devbox.json, and dump Brewfile.")
def backup():
    for path in DOTFILES:
        src = HOME_DIR / path
        dst = HOME_SUBDIR / path
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
    subprocess.run(
        ["brew", "bundle", "dump", "--force", "--file", str(BREWFILE)], check=True
    )


@cli.group(help="restore dotfiles, brew packages, devbox.json, or all at once.")
def restore():
    pass


@restore.command(help="restore dotfiles from repo back to your home directory.")
@click.option("--dry-run", is_flag=True, help="Show diff instead of restoring.")
def dotfiles(dry_run):
    for path in DOTFILES:
        src = HOME_SUBDIR / path
        dst = HOME_DIR / path
        if dry_run:
            diff = subprocess.run(
                ["diff", "-u", str(dst), str(src)], text=True, capture_output=True
            )
            if diff.returncode != 0:
                click.echo(path)
                click.echo()
                click.echo(diff.stdout)
        else:
            dst.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dst)


@restore.command(help="restore or update Homebrew packages from Brewfile.")
@click.option("--dry-run", is_flag=True, help="Show diff instead of restoring.")
def brew(dry_run):
    if dry_run:
        with tempfile.NamedTemporaryFile(delete_on_close=True) as tmp_file:
            subprocess.run(
                ["brew", "bundle", "dump", "--force", "--file", str(tmp_file.name)],
                check=True,
            )
            diff = subprocess.run(
                ["diff", "-u", str(tmp_file.name), str(BREWFILE)],
                text=True,
                capture_output=True,
            )
            if diff.returncode != 0:
                click.echo(diff.stdout)
    else:
        subprocess.run(["brew", "bundle", "--file", str(BREWFILE)], check=True)


@restore.command(
    name="all", help="restore dotfiles, brew packages, and devbox.json in sequence."
)
@click.option("--dry-run", is_flag=True, help="Show diff instead of restoring.")
def restore_all(dry_run):
    ctx = click.get_current_context()
    ctx.invoke(dotfiles, dry_run=dry_run)
    ctx.invoke(brew, dry_run=dry_run)


def main():
    cli()


if __name__ == "__main__":
    main()
