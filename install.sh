#!/bin/bash

sudo apt update
sudo apt upgrade
sudo apt install -y i3 i3blocks rofi redshift-gtk 
sudo apt install -y steam autokey-gtk nautilus git curl htop tlp powertop gimp libreoffice 
sudo apt install -y vagrant virtualbox virtualbox-guest-utils virtualbox-guest-dkms linux-headers-generic 
sudo snap install chromium
sudo snap remove software-boutique
sudo snap remove ubuntu-mate-welcome
sudo apt remove -y caja apport bluez pluma
dconf write /org/mate/desktop/session/required-components/windowmanager "'i3'"
dconf write /org/mate/desktop/background/show-desktop-icons "false"
mv i3 i3status redshift rofi ~/.config
mv ijkl ~/.config/autokey
sudo apt -y autoremove
