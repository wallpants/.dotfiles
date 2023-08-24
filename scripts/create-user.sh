echo "Please enter your username:"
read USERNAME

sudo adduser "$USERNAME"
sudo usermod -aG sudo "$USERNAME"
sudo su "$USERNAME"
