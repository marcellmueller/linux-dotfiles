Backup for my Linux setup files running i3 over Mate desktop. I use Ubuntu Mate but should work on any distro running Mate aside from the apt install command.

Drop these files in ~/.config

Requirements:

sudo apt install i3 i3blocks i3status rofi redshift-gtk

Switch Mate window manager to i3:

dconf write /org/mate/desktop/session/required-components/windowmanager "'i3'"

Turn off Mate desktop icons:  
dconf write /org/mate/desktop/background/show-desktop-icons "false"

Log out/reset pc :)
