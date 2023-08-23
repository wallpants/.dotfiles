source ~/.dotfiles/scripts/utils.sh

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
