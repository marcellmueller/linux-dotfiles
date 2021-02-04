#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt-get dist-upgrade -y
mv i3 i3status redshift rofi ~/.config
mv ijkl ~/.config/autokey
sudo apt install -y i3 i3blocks rofi redshift-gtk 
sudo apt install -y steam autokey-gtk nautilus git curl htop tlp powertop gimp libreoffice 
sudo apt install -y nodejs build-essential adapta-gtk-theme
sudo apt install -y vagrant virtualbox virtualbox-guest-utils virtualbox-guest-dkms linux-headers-generic 
sudo snap install chromium
sudo snap remove software-boutique
sudo snap remove ubuntu-mate-welcome
sudo apt remove -y caja apport pluma
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt-get install -y apt-transport-https
sudo apt-get update -y
sudo apt-get install -y code
dconf write /org/mate/desktop/session/required-components/windowmanager "'i3'"
dconf write /org/mate/desktop/background/show-desktop-icons "false"
git config --global user.name "marcellmueller"
git config --global user.email "mlmueller@protonmail.com"
git config --global color.ui auto
sudo apt update -y  && sudo apt upgrade -y && sudo apt dist-upgrade -y && sudo apt -y autoremove 
ssh-keygen -C mlmueller@protonmail.com
cat ~/.ssh/id_rsa.pub
