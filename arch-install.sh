#!/bin/bash
set -e

# Colors
MAGENTA="\033[35m"
NC="\033[0m" # No Color

# Print section headers (POSIX compliant)
section() {
    printf "${MAGENTA}=========================================${NC}\n"
    printf "${MAGENTA}>>>>> %s ${NC}\n" "$1"
    printf "${MAGENTA}=========================================${NC}\n\n"
    sleep 0.5
}


## INSTALL YAY
section "INSTALLING YAY"
cd
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
cd



# INSTALL OPENBOX & DEPENDENCIES
section "INSTALL OPENBOX & DEPENDENCIES"
yay -S --noconfirm \
            openbox \
            obconf \
            tint2 \
            volumeicon \
            xorg \
            xorg-server \
            xorg-xinit \
            lxappearance \
            nitrogen \
            pavucontrol \
            picom \
            rofi \
            sxhkd \
            xfce4-screenshooter \
            xfce4-clipman-plugin \
            xfce4-power-manager \
            arandr \
            exo \
            gsimplecal \
            xcape \
            gparted \
            file-roller \
            xautomation \
            networkmanager \
            python-pyxdg

# INSTALL BASIC PACKAGES
section "INSTALL BASIC PACKAGES"
yay -S --noconfirm \
            vlc \
            zip \
            unzip \
            gmtp \
            mtpfs \
            evince \
            wget \
            xdg-utils \
            xdg-user-dirs \
            network-manager-applet \
            tlp

# Enable services
systemctl enable --now tlp


# INSTALL ADDITIONAL PACKAGES
section "INSTALL ADDITIONAL PACKAGES"
yay -S --noconfirm \
    xed \
    kitty \
    chromium \
    ffmpeg \
    htop \
    neofetch \
    viewnior \
    nano \
    flameshot \
    wget \
    tumbler \
    inkscape \
    task \
    gcolor2 


# INSTALL THUNAR
section "INSTALL THUNAR"
yay -S --noconfirm \
            thunar \
            thunar-archive-plugin \
            thunar-media-tags-plugin \
            catfish \
            gvfs \
            gvfs-mtp \
            gvfs-nfs \
            gvfs-smb


### TERMINAL & EDITOR
section "TERMINAL & EDITOR"
yay -S --noconfirm kitty micro helix

### YAZI (TERMINAL FILE MANAGER)
section "INSTALL YAZI"
yay -S --noconfirm yazi
# Additional dependencies to extend yazi
yay -S --noconfirm ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick

### Zsh shell & Zinit
section "ZSH & Zinit INSTALL"
yay -S --noconfirm zsh
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
# Set zsh as default shell
chsh -s /usr/bin/zsh



# COPY obamenu
#section "COPY OBAMENU"
#sudo cp -v "$base_dir/obamenu" /usr/bin
#sudo chmod +x /usr/bin/obamenu

# COPYING FILES & FOLDERS
section "COPYING FILES & FOLDERS"
mkdir -p ~/.config
cd
cd ~/openbox
./folders.sh


### DISPLAY MANAGER (LIGHTDM)
section "INSTALL DISPLAY MANAGER (LIGHTDM)"

yay -S --noconfirm lightdm lightdm-gtk-greeter

systemctl start lightdm.service && systemctl enable lightdm.service

printf "${MAGENTA}Done! ${NC}\n"