#! /bin/bash

# create ~/.config dir if missing
if [ ! -d ~/.config ]; then mkdir ~/.config; fi

# clone repo it missing
if [ ! -d ~/.dotfiles ]; then
  git clone https://github.com/gualcasas/.dotfiles.git ~/.dotfiles
fi

source ~/.dotfiles/scripts/utils.sh
source ~/.dotfiles/scripts/github-setup.sh
source ~/.dotfiles/scripts/homebrew-setup.sh
source ~/.dotfiles/scripts/neovim-setup.sh
source ~/.dotfiles/scripts/kitty-setup.sh
source ~/.dotfiles/scripts/zsh-setup.sh
