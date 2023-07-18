#! /bin/bash

source utils.sh

# Ensure brew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval_if_os "linux" "sudo dnf groupinstall 'Development Tools'"
fi

brew_ensure_installed "viu"
brew_ensure_installed "rg" "brew install ripgrep"
eval_if_os "darwin" "brew_ensure_installed 'gsed' 'brew install gnu-sed'"

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
eval_if_os "darwin" "ln -s ~/.dotfiles/kitty/mac.conf ~/.dotfiles/kitty/os_specific.conf"

# # # # # # # # # # # # # # # #
#                             #
#             Zsh             #
#                             #
# # # # # # # # # # # # # # # #
echo "linking ~/.zshrc"
rm ~/.zshrc
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
rm ~/.dotfiles/zsh/os_specific.zsh
eval_if_os "linux" "ln -s ~/.dotfiles/zsh/linux.zsh ~/.dotfiles/zsh/os_specific.zsh"
eval_if_os "darwin" "ln -s ~/.dotfiles/zsh/mac.zsh ~/.dotfiles/zsh/os_specific.zsh"
echo "linking ~/.oh-my-zsh/custom/themes/Chicago95.zsh-theme"
rm ~/.oh-my-zsh/custom/themes/Chicago95.zsh-theme
ln -s ~/.dotfiles/zsh/Chicago95.zsh-theme ~/.oh-my-zsh/custom/themes/Chicago95.zsh-theme
