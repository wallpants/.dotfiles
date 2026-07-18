source ~/.dotfiles/scripts/utils.sh

echo "installing fonts"

eval_if_os "linux" "rm -rf ~/.local/share/fonts"
eval_if_os "linux" "ln -s ~/.dotfiles/fonts ~/.local/share/fonts"
eval_if_os "linux" "fc-cache -f"

# macos picks up fonts in ~/Library/Fonts automatically, no cache rebuild needed
eval_if_os "macos" "cp ~/.dotfiles/fonts/*.ttf ~/.dotfiles/fonts/*.otf ~/Library/Fonts/"
