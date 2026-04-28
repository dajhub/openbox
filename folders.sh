#!/bin/sh

#!/bin/sh
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $REPO_DIR"

sync_dir() {
    src="$REPO_DIR/$1"
    dest="$HOME/$2"
    echo "Syncing directory $src → $dest"
    rsync -a --delete "$src/" "$dest/"
}

sync_file() {
    src="$REPO_DIR/$1"
    dest="$HOME/$2"
    echo "Copying file $src → $dest"
    rsync -a "$src" "$dest"
}

# Directories
sync_dir ".config/helix" ".config/helix"
sync_dir ".config/kitty" ".config/kitty"
sync_dir ".config/obmenu-generator" ".config/obmenu-generator"
sync_dir ".config/openbox" ".config/openbox"
sync_dir ".config/sxhkd" ".config/sxhkd"
sync_dir ".config/tint2" ".config/tint2"
sync_dir ".config/yazi" ".config/yazi"


sync_dir ".fonts" ".fonts"
sync_dir ".themes" ".themes"
sync_dir ".icons" ".icons"


# Files
sync_file ".zshrc" ".zshrc"

sync_file ".config/obmenu" ".config/obmenu"
sync_file ".config/picom.conf" ".config/picom.conf"

echo "Done."

