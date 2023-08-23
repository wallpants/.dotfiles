source ~/.dotfiles/scripts/utils.sh

echo "linking ~/.config/kitty"
rm -rf ~/.config/kitty
ln -s ~/.dotfiles/kitty ~/.config/kitty
rm ~/.dotfiles/kitty/os_specific.conf
eval_if_os "linux" "ln -s ~/.dotfiles/kitty/linux.conf ~/.dotfiles/kitty/os_specific.conf"
eval_if_os "macos" "ln -s ~/.dotfiles/kitty/mac.conf ~/.dotfiles/kitty/os_specific.conf"
