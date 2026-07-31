git config --global user.name "wallpants"
git config --global user.email "47203170+wallpants@users.noreply.github.com"

if [ ! -e ~/.ssh/id_ed25519.pub ]; then
  ssh-keygen -t ed25519 -C "47203170+wallpants@users.noreply.github.com"

  cat ~/.ssh/id_ed25519.pub
fi
