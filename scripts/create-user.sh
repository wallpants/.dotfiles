echo "Please enter your username:"
read USERNAME

sudo useradd -m "$USERNAME"
sudo passwd "$USERNAME"
sudo usermod -aG wheel "$USERNAME"
