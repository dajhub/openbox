#!/bin/bash
set -e

# --- 1. Variables & Initialization ---
MAGENTA='\033[35m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

ONLY_CONFIG=${1:-false}
TEMP_DIR=$(mktemp -d)
CONFIG_DIR="$HOME/.config"
DOTFILES_SRC="$HOME/openbox" 

# Cleanup temp files on exit
trap 'rm -rf "$TEMP_DIR"' EXIT

# --- 2. Helper Functions ---
section() {
    printf "\n${MAGENTA}=========================================${NC}\n"
    printf "${MAGENTA}>>>>> %s ${NC}\n" "$1"
    printf "${MAGENTA}=========================================${NC}\n"
}

die() { echo -e "${RED}ERROR: $*${NC}" >&2; exit 1; }
msg() { echo -e "${CYAN}$*${NC}"; }
warn() { echo -e "${YELLOW}WARNING: $*${NC}"; }


# --- 3. Sudo Warm-up & Keep-alive ---
section "AUTHORIZING SCRIPT"
msg "Please enter your password to allow the installation to run unattended."
sudo -v

# Update the sudo timestamp every 60 seconds so it never times out
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# --- 4. Repositories ---
section "INITIALIZING SYSTEM & REPOS"
sudo apt-get update
sudo apt-get install -y curl gpg lsb-release wget git rsync

curl -sS https://debian.griffo.io/EA0F721D231FDD3A0A17B9AC7808B4DD62C41256.asc \
    | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/debian.griffo.io.gpg >/dev/null

echo "deb https://debian.griffo.io/apt $(lsb_release -sc) main" \
    | sudo tee /etc/apt/sources.list.d/debian.griffo.io.list

sudo apt-get update



# --- 5. Package Definitions ---
PACKAGES_CORE=(xorg openbox dbus-x11)

PACKAGES_UI=(tint2 lxappearance obconf pavucontrol dunst feh sxhkd lxpolkit picom jgmenu)

PACKAGES_FILE_MANAGER=(yazi ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick unzip)
PACKAGES_AUDIO=(pavucontrol pulsemixer pamixer pipewire-audio)
PACKAGES_UTILITIES=(avahi-daemon acpi acpid xfce4-power-manager flameshot qimgv xdg-user-dirs-gtk rsync brightnessctl bc htop fastfetch redshift xss-lock firefox-esr)
PACKAGES_TERMINAL=(alacritty kitty zsh)
PACKAGES_EDITORS=(micro hx geany geany-plugin-markdown geany-plugin-overview)
PACKAGES_FONTS=(fonts-recommended fonts-font-awesome fonts-terminus fonts-noto fonts-inter fonts-dejavu)
PACKAGES_BUILD=(cmake meson ninja-build pkg-config)
PACKAGES_LOCK_DEPS=(autoconf gcc make libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev)

# --- 6. Installation Logic ---
if [ "$ONLY_CONFIG" = false ]; then
    section "INSTALLING ALL PACKAGES"
    
    ALL_PACKAGES=("${PACKAGES_CORE[@]}" "${PACKAGES_UI[@]}" "${PACKAGES_FILE_MANAGER[@]}" "${PACKAGES_AUDIO[@]}" "${PACKAGES_UTILITIES[@]}" "${PACKAGES_TERMINAL[@]}" "${PACKAGES_EDITORS[@]}" "${PACKAGES_FONTS[@]}" "${PACKAGES_BUILD[@]}" "${PACKAGES_LOCK_DEPS[@]}")
    
    sudo apt-get install -y "${ALL_PACKAGES[@]}" || die "Apt installation failed"

    sudo systemctl enable avahi-daemon acpid

    section "BUILDING I3LOCK-COLOR"
    cd "$TEMP_DIR"
    git clone https://github.com/Raymo111/i3lock-color.git
    cd i3lock-color
    chmod +x install-i3lock-color.sh
    ./install-i3lock-color.sh || die "Failed to build i3lock-color"

    section "CONFIGURING SHELL"
    sudo apt-get install -y lua5.4
    bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
    sudo chsh -s /usr/bin/zsh "$USER"
fi


# --- 7. Configuration & Dotfiles ---
section "SETTING UP FOLDERS & DOTFILES"

mkdir -p "$CONFIG_DIR"

if [ -d "$DOTFILES_SRC" ]; then
    msg "Syncing dotfiles from $DOTFILES_SRC..."
    if [ -f "$DOTFILES_SRC/folders.sh" ]; then
        chmod +x "$DOTFILES_SRC/folders.sh"
        (cd "$DOTFILES_SRC" && ./folders.sh)
        msg "Folder sync complete."
    else
        warn "folders.sh not found in $DOTFILES_SRC."
    fi
else
    warn "Source directory $DOTFILES_SRC not found! Skipping dotfiles."
fi

# --- 8. LightDM Setup ---
section "INSTALLING LIGHTDM"
sudo apt-get install -y lightdm lightdm-gtk-greeter

sudo systemctl enable lightdm
sudo systemctl set-default graphical.target

section "Installation complete. Reboot to see the login screen."