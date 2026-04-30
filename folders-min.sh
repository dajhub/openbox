#!/bin/sh
set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from $REPO_DIR"

sync_dir() {
    src="$REPO_DIR/$1"
    dest="$HOME/$2"
    echo "Syncing directory $src → $dest"
    rsync -av "$src/" "$dest/"
}

sync_file() {
    src="$REPO_DIR/$1"
    dest="$HOME/$2"
    echo "Copying file $src → $dest"
    if [ -f "$src" ]; then
        rsync -a "$src" "$dest"
    else
        echo "Warning: file not found: $src"
    fi
}

# Directories
sync_dir ".config/openbox" ".config/openbox"
sync_dir ".config/tint2" ".config/tint2"
sync_dir ".themes" ".themes"
sync_dir ".icons" ".icons"


# Files



echo "Done."

