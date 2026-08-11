#! /bin/bash

# create ~/.config dir if missing
if [ ! -d ~/.config ]; then mkdir ~/.config; fi

# clone repo if missing, otherwise update it
if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/wallpants/.dotfiles.git ~/.dotfiles
else
  echo "~/.dotfiles already exists, updating..."
  if ! git -C ~/.dotfiles pull --ff-only; then
    echo "Could not fast-forward ~/.dotfiles (local changes or diverged branch)."
    echo "Resolve manually, then re-run."
    exit 1
  fi
fi

source ~/.dotfiles/scripts/utils.sh
source ~/.dotfiles/scripts/github-setup.sh
source ~/.dotfiles/scripts/install-fonts.sh
source ~/.dotfiles/scripts/homebrew-setup.sh
source ~/.dotfiles/scripts/docker-setup.sh
source ~/.dotfiles/scripts/neovim-setup.sh
source ~/.dotfiles/scripts/kitty-setup.sh
source ~/.dotfiles/scripts/zsh-setup.sh
source ~/.dotfiles/scripts/claude-setup.sh
source ~/.dotfiles/scripts/nvim-sync.sh
