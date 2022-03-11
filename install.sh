#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
mv i3 i3status redshift rofi ~/.config
mv ijkl ~/.config/autokey
sudo apt install -y i3 i3blocks rofi redshift-gtk
sudo apt install -y steam autokey-gtk nautilus git curl htop tlp powertop gimp 
sudo apt install -y nodejs build-essential adapta-gtk-theme
sudo snap install chromium
sudo snap remove software-boutique
sudo snap remove ubuntu-mate-welcome
sudo apt remove -y caja apport pluma
sudo apt install apt-transport-https ca-certificates gnupg lsb-release

# VSCode
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

# Github CLI
url -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Gcloud CLI
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo tee /usr/share/keyrings/cloud.google.gpg

# Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \ "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \ $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Kubectl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update -y
sudo apt install -y code gh google-cloud-cli kubectl
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Replace Mate window manager with i3
dconf write /org/mate/desktop/session/required-components/windowmanager "'i3'"
# Hide desktop icons
dconf write /org/mate/desktop/background/show-desktop-icons "false"

git config --global user.name "marcellmueller"
git config --global user.email "mlmueller@protonmail.com"
git config --global color.ui auto

sudo apt update -y  && sudo apt upgrade -y && sudo apt -y autoremove 
ssh-keygen -C mlmueller@protonmail.com
cat ~/.ssh/id_rsa.pub
