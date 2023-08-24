if [ ! -e ~/.ssh/id_ed25519.pub ]; then
  # Check if the vars are empty
  echo "Please enter your Name:"
  read USER_NAME

  echo "Please enter your Email:"
  read USER_EMAIL

  git config --global user.name "$USER_NAME"
  git config --global user.email "$USER_EMAIL"

  ssh-keygen -t ed25519 -C "$USER_EMAIL"

  cat ~/.ssh/id_ed25519.pub
fi
