EMAIL=""
GIT_USERNAME=""

if [ ! -e ~/.ssh/id_ed25519.pub ]; then
  # Check if the vars are empty
  if [[ -z "$EMAIL" || -z "$GIT_USERNAME" ]]; then
    echo "EMAIL or USERNAME not set in 'scripts/github-setup.sh'"
    exit 1
  fi

  git config --global user.name "$GIT_USERNAME"
  git config --global user.email "$EMAIL"

  ssh-keygen -t ed25519 -C "$EMAIL"

  cat ~/.ssh/id_ed25519.pub
fi
