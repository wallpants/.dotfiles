#! /bin/bash

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
if [ $OSTYPE == "linux-gnu" ]
then
  ln -s ~/.dotfiles/kitty/linux.conf ~/.dotfiles/kitty/os_specific.conf
else
  ln -s ~/.dotfiles/kitty/mac.conf ~/.dotfiles/kitty/os_specific.conf
fi

# # # # # # # # # # # # # # # #
#                             #
#             Zsh             #
#                             #
# # # # # # # # # # # # # # # #
echo "linking ~/.zshrc"
rm ~/.zshrc
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
rm ~/.dotfiles/zsh/os_specific.zsh
if [ $OSTYPE == "linux-gnu" ]
then
  ln -s ~/.dotfiles/zsh/linux.zsh ~/.dotfiles/zsh/os_specific.zsh
else
  ln -s ~/.dotfiles/zsh/mac.zsh ~/.dotfiles/zsh/os_specific.zsh
fi
echo "linking ~/.oh-my-zsh/custom/themes/Chicago95.zsh-theme"
rm ~/.oh-my-zsh/custom/themes/Chicago95.zsh-theme
ln -s ~/.dotfiles/zsh/Chicago95.zsh-theme ~/.oh-my-zsh/custom/themes/Chicago95.zsh-theme
