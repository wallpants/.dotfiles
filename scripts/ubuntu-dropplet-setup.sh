#! /bin/bash

# adduser remotito
# usermod -aG sudo remotito
# su remotito
# ssh-keygen -t ed25519 -C "gual.casas@gmail.com"

source utils.sh

sudo apt update
sudo apt upgrade
sudo apt install build-essential procps curl file zsh

# Ensure brew is installed
if ! command -v brew &>/dev/null; then
  echo "Homebrew is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# make brew available in current session
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew_ensure_installed "caddy"
brew_ensure_installed "frps"
brew_ensure_installed "lazygit"
brew_ensure_installed "pnpm"
brew_ensure_installed "node"

# ensure oh-my-zsh is installed
if ! command -v omz &>/dev/null; then
  echo "Oh-my-zsh is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "linking ~/.zshrc"
rm ~/.zshrc
ln -s ~/.dotfiles/zsh/ubuntu-dropplet-zshrc ~/.zshrc
