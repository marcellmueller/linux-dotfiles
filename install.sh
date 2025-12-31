#!/bin/bash
set -e

# Log function
log() {
    echo -e "\033[1;32m[LOG] $1\033[0m"
}

warn() {
    echo -e "\033[1;33m[WARN] $1\033[0m"
}

# Configuration
CONFIG_DIR="./.config"
FONT_DIR="$HOME/.local/share/fonts"


# System Update
system_update() {
    log "Updating system..."
    sudo apt update -y
    sudo apt upgrade -y
}

# Debloat & Snap Purge
remove_bloat() {
    log "Removing GNOME bloat and Snaps..."
    
    # Remove Snap
    sudo snap remove firefox || true
    sudo snap remove snap-store || true
    sudo snap remove gnome-3-38-2004 || true
    sudo snap remove gtk-common-themes || true
    sudo snap remove snapd-desktop-integration || true
    sudo snap remove bare || true
    sudo snap remove core20 || true
    sudo snap remove core22 || true
    sudo snap remove core || true
    
    sudo systemctl stop snapd || true
    sudo systemctl disable snapd || true
    sudo apt autoremove --purge -y snapd gnome-software-plugin-snap
    
    # Prevent Snap from being reinstalled
    sudo apt-mark hold snapd

    # Remove GNOME Sessions & Extras
    sudo apt remove --purge -y gnome-shell ubuntu-session gdm3 gnome-startup-applications gnome-software gnome-terminal gnome-control-center nautilus
    
    # Clean up
    sudo apt autoremove -y
}

# Install Base Sway & Utilities
install_base() {
    log "Installing Sway and base utilities..."
    
    # Install Core Packages
    # - Window Manager: i3, i3lock, i3status, dunst, rofi
    # - X11/System: xorg, xinit, xinput, xclip, xdg-desktop-portal-gtk
    # - Display/Theming: lightdm, lxappearance, xfce4-settings, nitrogen/feh
    # - Audio/Media: pulseaudio, pavucontrol
    # - Tools: alacritty, brightnessctl, htop, btop, nvtop, scrot, policykit-1-gnome
    sudo apt install -y \
        i3 i3lock i3status dunst feh rofi \
        xorg xinit xinput scrot xclip \
        xdg-desktop-portal xdg-desktop-portal-gtk \
        lightdm lightdm-gtk-greeter lxappearance xfce4-settings \
        pulseaudio pavucontrol \
        alacritty \
        policykit-1-gnome \
        brightnessctl \
        htop btop nvtop

    # Enable XFCE settings in Rofi (remove OnlyShowIn=XFCE)
    sudo sed -i 's/OnlyShowIn=XFCE;//g' /usr/share/applications/xfce4-display-settings.desktop || true
    sudo sed -i 's/OnlyShowIn=XFCE;//g' /usr/share/applications/xfce4-settings-manager.desktop || true
}

configure_lightdm() {
    log "Configuring LightDM for i3..."
    
    # Remove any custom Wayland session if it exists (cleanup)
    sudo rm -f /usr/share/wayland-sessions/sway.desktop

    # Create a desktop entry for i3 (if not provided by package, but good to ensure)
    sudo mkdir -p /usr/share/xsessions
    sudo tee /usr/share/xsessions/i3.desktop > /dev/null <<'EOF'
[Desktop Entry]
Name=i3
Comment=Improved dynamic tiling window manager
Exec=i3
TryExec=i3
Type=Application
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;
EOF

    # Enable LightDM (force to override any prior DM settings)
    sudo systemctl disable sddm 2>/dev/null || true
    sudo systemctl disable gdm3 2>/dev/null || true
    sudo systemctl enable lightdm --force
}

# Install GUI Utilities
install_gui_utils() {
    log "Installing GUI utilities..."
    
    # Network, Bluetooth, Disks, File Manager, Archive Tools
    sudo apt install -y \
        network-manager-gnome \
        blueman \
        gnome-disk-utility \
        thunar \
        engrampa p7zip-full thunar-archive-plugin

    # Steam (requires 32-bit library support)
    sudo dpkg --add-architecture i386
    # We need to update again to pull 32-bit architecture info
    sudo apt update || true
    sudo apt install -y steam-installer

    # Rename Thunar to "Files" in Rofi
    if [ -f /usr/share/applications/thunar.desktop ]; then
        sudo sed -i 's/^Name=Thunar File Manager/Name=Files/g' /usr/share/applications/thunar.desktop
        sudo sed -i 's/^Name=Thunar/Name=Files/g' /usr/share/applications/thunar.desktop
    fi
}

# Install Firefox (Non-Snap)
install_firefox() {
    log "Installing Firefox (Non-Snap)..."
    
    sudo install -d -m 0755 /etc/apt/keyrings
    
    if ! wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null; then
        warn "Failed to download Mozilla GPG key. Skipping Firefox installation."
        return
    fi
    
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
    
    echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
    
    sudo apt update
    sudo apt install -y firefox
}

# Install Dev Tools
install_dev_tools() {
    log "Installing Development Tools..."
    sudo apt install -y git gh curl build-essential unzip ripgrep fd-find npm meson ninja-build pkg-config flex bison
}

# Install Zed
install_zed() {
    log "Installing Zed Editor..."
    curl -f https://zed.dev/install.sh | sh
}

# Copy Dotfiles
copy_dotfiles() {
    log "Installing Dotfiles..."
    
    if [ ! -d "$CONFIG_DIR" ]; then
        warn "Config directory ($CONFIG_DIR) not found. Skipping dotfiles installation."
        return
    fi
    
    log "Installing configs from $CONFIG_DIR to ~/.config..."
    mkdir -p ~/.config
    cp -r "$CONFIG_DIR"/* ~/.config/
}

configure_grub() {
    log "Configuring GRUB to be hidden..."
    
    # Backup grub config
    if [ ! -f /etc/default/grub.bak ]; then
        sudo cp /etc/default/grub /etc/default/grub.bak
    fi

    # Update GRUB settings
    
    # 1. Set GRUB_TIMEOUT=0
    if grep -q "^GRUB_TIMEOUT=" /etc/default/grub; then
        sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
    else
        echo "GRUB_TIMEOUT=0" | sudo tee -a /etc/default/grub
    fi

    # 2. Set GRUB_TIMEOUT_STYLE=hidden
    if grep -q "^GRUB_TIMEOUT_STYLE=" /etc/default/grub; then
        sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub
    else
        echo "GRUB_TIMEOUT_STYLE=hidden" | sudo tee -a /etc/default/grub
    fi

    # 3. Set GRUB_RECORDFAIL_TIMEOUT=0 (Critical for some systems where it defaults to 30s if boot failed/forced off)
    if grep -q "^GRUB_RECORDFAIL_TIMEOUT=" /etc/default/grub; then
        sudo sed -i 's/^GRUB_RECORDFAIL_TIMEOUT=.*/GRUB_RECORDFAIL_TIMEOUT=0/' /etc/default/grub
    else
        echo "GRUB_RECORDFAIL_TIMEOUT=0" | sudo tee -a /etc/default/grub
    fi
    

    
    # Update grub
    sudo update-grub
}

setup_antigravity() {
    log "Setting up Antigravity..."
    # 1. Add the repository to sources.list.d
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://us-central1-apt.pkg.dev/doc/repo-signing-key.gpg | \
      sudo gpg --dearmor --yes -o /etc/apt/keyrings/antigravity-repo-key.gpg
    echo "deb [signed-by=/etc/apt/keyrings/antigravity-repo-key.gpg] https://us-central1-apt.pkg.dev/projects/antigravity-auto-updater-dev/ antigravity-debian main" | \
      sudo tee /etc/apt/sources.list.d/antigravity.list > /dev/null

    sudo apt update

    sudo apt install -y antigravity
}


# Install Neovim & Fonts
install_neovim() {
    log "Installing Neovim & Nerd Fonts..."

    if ! command -v nvim &> /dev/null; then
        log "Installing Neovim via apt..."
        sudo apt install -y neovim
    else
        log "Neovim is already installed."
    fi

    if [ ! -d "$FONT_DIR/JetBrainsMono" ]; then
        log "Installing JetBrainsMono Nerd Font..."
        mkdir -p "$FONT_DIR/JetBrainsMono"
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O JetBrainsMono.zip
        unzip -o -q JetBrainsMono.zip -d "$FONT_DIR/JetBrainsMono"
        rm JetBrainsMono.zip
        
        if ! command -v fc-cache &> /dev/null; then
             sudo apt install -y fontconfig
        fi
        
        fc-cache -fv
    else
        log "JetBrainsMono Nerd Font already installed."
    fi
}

# --- Main Execution ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    read -p "This script will remove GNOME and SNAPD. Are you sure? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

system_update
remove_bloat
install_base
configure_lightdm
configure_grub
install_gui_utils
install_firefox
install_dev_tools
install_neovim
install_zed
copy_dotfiles
setup_antigravity

log "Installation Complete! Please reboot your system."
fi
