echo "Please enter your username:"
read USERNAME

sudo useradd -m "$USERNAME"
sudo passwd "$USERNAME"

# admin group is "sudo" on ubuntu/debian, "wheel" on fedora
if getent group sudo >/dev/null; then
  sudo usermod -aG sudo "$USERNAME"
else
  sudo usermod -aG wheel "$USERNAME"
fi
