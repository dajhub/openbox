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


# --- 4. Updates ---
section "UPDATES"

sudo apt-get update


# --- 5. Package Definitions ---
PACKAGES_CORE=(openbox dbus-x11)
PACKAGES_UI=(tint2 obconf jgmenu)


# --- 6. Installation Logic ---
if [ "$ONLY_CONFIG" = false ]; then
    section "INSTALLING ALL PACKAGES"
    
    ALL_PACKAGES=("${PACKAGES_CORE[@]}" "${PACKAGES_UI[@]}")
    
    sudo apt-get install -y "${ALL_PACKAGES[@]}" || die "Apt installation failed"
fi


# --- 7. Configuration & Dotfiles ---
section "SETTING UP FOLDERS & DOTFILES"

mkdir -p "$CONFIG_DIR"

if [ -d "$DOTFILES_SRC" ]; then
    msg "Syncing dotfiles from $DOTFILES_SRC..."
    if [ -f "$DOTFILES_SRC/folders-min.sh" ]; then
        chmod +x "$DOTFILES_SRC/folders-min.sh"
        (cd "$DOTFILES_SRC" && ./folders-min.sh)
        msg "Folder sync complete."
    else
        warn "folders-min.sh not found in $DOTFILES_SRC."
    fi
else
    warn "Source directory $DOTFILES_SRC not found! Skipping dotfiles."
fi

section "Installation complete. Reboot for login screen."