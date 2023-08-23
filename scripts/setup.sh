#! /bin/bash

source utils.sh

# create ~/.config dir if missing
if [ ! -d ~/.config ]; then mkdir ~/.config; fi

# source .zsh files in case brew is installed
eval_if_os "linux" "source zsh/linux.zsh"
eval_if_os "macos" "source zsh/mac.zsh"

# Ensure brew is installed
if ! command -v brew &>/dev/null; then
  eval_if_os "fedora" "sudo dnf update"
  eval_if_os "fedora" "sudo dnf groupinstall 'Development Tools' -y"
  eval_if_os "fedora" "sudo dnf install zsh"

  eval_if_os "ubuntu" "sudo apt update"
  eval_if_os "ubuntu" "sudo apt install build-essential -y"
  eval_if_os "ubuntu" "sudo apt install zsh"

  echo "Homebrew is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # source .zsh files again to load brew if newly installed
  eval_if_os "linux" "source zsh/linux.zsh"
  eval_if_os "macos" "source zsh/mac.zsh"
fi

brew_ensure_installed "go"
brew_ensure_installed "viu"
brew_ensure_installed "lazygit"
brew_ensure_installed "nvim" "brew install neovim"
brew_ensure_installed "doctl"
brew_ensure_installed "frpc"
brew_ensure_installed "unzip"
brew_ensure_installed "pnpm"
brew_ensure_installed "fd"
brew_ensure_installed "rg" "brew install ripgrep"
eval_if_os "macos" "brew_ensure_installed 'gsed' 'brew install gnu-sed'"
brew_ensure_installed "supabase" "brew install supabase/tap/supabase"

brew_ensure_installed "nvm"
# source .zsh files again to load nvm
eval_if_os "linux" "source zsh/linux.zsh"
eval_if_os "macos" "source zsh/mac.zsh"
brew_ensure_installed "node" "nvm install 18"

# # # # # # # # # # # # # # # #
#                             #
#          Neovim             #
#                             #
# # # # # # # # # # # # # # # #

echo "linking ~/.config/nvim"
rm -rf ~/.config/nvim
ln -s ~/.dotfiles/nvim ~/.config/nvim

# # # # # # # # # # # # # # # #
#                             #
#           Kitty             #
#                             #
# # # # # # # # # # # # # # # #

echo "linking ~/.config/kitty"
rm -rf ~/.config/kitty
ln -s ~/.dotfiles/kitty ~/.config/kitty
rm ~/.dotfiles/kitty/os_specific.conf
eval_if_os "linux" "ln -s ~/.dotfiles/kitty/linux.conf ~/.dotfiles/kitty/os_specific.conf"
eval_if_os "macos" "ln -s ~/.dotfiles/kitty/mac.conf ~/.dotfiles/kitty/os_specific.conf"

# # # # # # # # # # # # # # # #
#                             #
#             Zsh             #
#                             #
# # # # # # # # # # # # # # # #

# Ensure oh-my-zsh is installed
if [ ! -d ~/.oh-my-zsh ]; then
  echo "Oh my zsh is not installed. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "linking ~/.zshrc"
rm ~/.zshrc
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
rm ~/.dotfiles/zsh/os_specific.zsh
eval_if_os "linux" "ln -s ~/.dotfiles/zsh/linux.zsh ~/.dotfiles/zsh/os_specific.zsh"
eval_if_os "macos" "ln -s ~/.dotfiles/zsh/mac.zsh ~/.dotfiles/zsh/os_specific.zsh"
rm ~/.oh-my-zsh/custom/themes/leite.zsh-theme
echo "linking ~/.oh-my-zsh/custom/themes/leite.zsh-theme"
ln -s ~/.dotfiles/zsh/leite.zsh-theme ~/.oh-my-zsh/custom/themes/leite.zsh-theme
