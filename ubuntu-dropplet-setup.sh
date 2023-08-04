#! /bin/bash

source utils.sh

# Ensure brew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(sudo apt-get install build-essential procps curl file git)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval_if_os "linux" "sudo dnf groupinstall 'Development Tools'"
fi

brew_ensure_installed "caddy"
brew_ensure_installed "frps"
brew_ensure_installed "node" "brew install node@18"
brew_ensure_installed "pnpm"
brew_ensure_installed "lazygit"

echo "linking ~/.zshrc"
rm ~/.zshrc
ln -s ~/.dotfiles/zsh/ubuntu-dropplet-zshrc ~/.zshrc
