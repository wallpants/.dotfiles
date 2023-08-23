EMAIL=""
GIT_USERNAME=""

# Check if the vars are empty
if [[ -z "$EMAIL"  || -z "$GIT_USERNAME" ]]; then
    echo "EMAIL or USERNAME not set"
    exit 1
fi

git config --global user.name "$GIT_USERNAME"
git config --global user.email "$EMAIL"

if [ ! -e ~/.ssh/id_ed25519.pub ]; then
  ssh-keygen -t ed25519 -C "$EMAIL"
fi

cat ~/.ssh/id_ed25519.pub
