source ~/.dotfiles/scripts/utils.sh

# official binary bundle in ~/.local/kitty.app + PATH/desktop integration
# (https://sw.kovidgoyal.net/kitty/binary/)
install_kitty_linux() {
  if [ ! -d ~/.local/kitty.app ]; then
    echo "kitty is not installed. Installing..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
  fi
  mkdir -p ~/.local/bin ~/.local/share/applications
  ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
  cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
  cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
  sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
  sed -i "s|Exec=kitty|Exec=$HOME/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
}

eval_if_os "macos" "brew_ensure_installed 'kitty' 'brew install --cask kitty'"
eval_if_os "linux" "install_kitty_linux"

echo "linking ~/.config/kitty"
rm -rf ~/.config/kitty
ln -s ~/.dotfiles/kitty ~/.config/kitty
rm -f ~/.dotfiles/kitty/os_specific.conf
eval_if_os "linux" "ln -s ~/.dotfiles/kitty/linux.conf ~/.dotfiles/kitty/os_specific.conf"
eval_if_os "macos" "ln -s ~/.dotfiles/kitty/mac.conf ~/.dotfiles/kitty/os_specific.conf"
