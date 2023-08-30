source ~/.dotfiles/scripts/utils.sh

echo "linking ~/.dotfiles//fonts"

eval_if_os "fedora" "rm -rf ~/.local/share/fonts"
eval_if_os "fedora" "ln -s ~/.dotfiles/fonts ~/.local/share/fonts"
eval_if_os "fedora" "sudo fc-cache"
