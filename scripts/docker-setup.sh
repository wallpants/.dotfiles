source ~/.dotfiles/scripts/utils.sh

docker_setup() {
  if ! command -v docker &>/dev/null; then
    echo "docker is not installed. Installing..."
    # official convenience script: engine + cli + buildx + compose plugin
    curl -fsSL https://get.docker.com | sudo sh
  fi

  # ubuntu enables the service on install, fedora doesn't; idempotent either way
  sudo systemctl enable --now docker

  if ! id -nG "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER"
    echo "Added $USER to the docker group. Log out and back in to run docker without sudo."
  fi
}

# macOS runs Docker Desktop or OrbStack, installed manually
eval_if_os "linux" "docker_setup"
