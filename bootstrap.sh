# docker CHECK THESE
# sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
# sudo dnf install docker-ce docker-ce-cli containerd.io

# Install required packages first
sudo dnf install -y $(grep -vE '^\s*#|^\s*$' packages.txt)

# fedora groups
sudo dnf group install c-development -y
sudo dnf group install development-tools -y
sudo dnf group install swaywm-extended -y

# python3
sudo dnf install pipx && pipx install pyright

# dbms
sudo dnf install postgresql-server postgresql-contrib -y && sudo postgresql-setup --initdb
sudo systemctl enable postgresql --now && sudo systemctl status postgresql

