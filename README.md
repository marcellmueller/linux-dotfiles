# My dotfiles for Mate/i3wm setup

Backup for my Linux setup files running **i3** over the **Mate** desktop environment which is IMO a perfect combination. It works pretty much flawlessly for some of the comforts of a normal GUI based desktop environment with the benefits of an i3 workflow and is much easier to set up than combining i3 with XFCE or KDE Plasma. I use Ubuntu Mate but should work on any distro running Mate aside from the apt install command.

## Drop these files in ~/.config

**Requirements:**

```
sudo apt install i3 i3blocks rofi redshift-gtk
```

**Switch Mate window manager to i3:**

```
dconf write /org/mate/desktop/session/required-components/windowmanager "'i3'"
```

**Turn off Mate desktop icons:**

```
dconf write /org/mate/desktop/background/show-desktop-icons "false"
```

Log out/reset pc

**Alternate install script**
Haven't tried on fresh install yet but working on an install script. Runs these commands:

```
sudo chmod +x install.sh
sudo ./install.sh
```
