source ~/.dotfiles/scripts/utils.sh

if [ ! -d ~/.oh-my-zsh ]; then
  echo "Oh my zsh is not installed. Installing..."
  # --unattended: don't launch zsh or change the default shell mid-script,
  # otherwise the rest of the setup scripts never run
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# --unattended skips chsh, so set the default shell ourselves
if [ "$(basename "$SHELL")" != "zsh" ]; then
  chsh -s "$(command -v zsh)"
fi

echo "linking ~/.zshrc"
rm -f ~/.zshrc
ln -s ~/.dotfiles/zsh/zshrc ~/.zshrc
rm -f ~/.dotfiles/zsh/os_specific.zsh
eval_if_os "linux" "ln -s ~/.dotfiles/zsh/linux.zsh ~/.dotfiles/zsh/os_specific.zsh"
eval_if_os "macos" "ln -s ~/.dotfiles/zsh/mac.zsh ~/.dotfiles/zsh/os_specific.zsh"
rm -f ~/.oh-my-zsh/custom/themes/leite.zsh-theme
echo "linking ~/.oh-my-zsh/custom/themes/leite.zsh-theme"
ln -s ~/.dotfiles/zsh/leite.zsh-theme ~/.oh-my-zsh/custom/themes/leite.zsh-theme
