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

# cloud providers (e.g. DigitalOcean) only seed root's authorized_keys, so
# copy them over to make the new user reachable over ssh directly
if sudo test -f /root/.ssh/authorized_keys; then
  sudo mkdir -p "/home/$USERNAME/.ssh"
  sudo cp /root/.ssh/authorized_keys "/home/$USERNAME/.ssh/authorized_keys"
  sudo chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.ssh"
  sudo chmod 700 "/home/$USERNAME/.ssh"
  sudo chmod 600 "/home/$USERNAME/.ssh/authorized_keys"
fi
