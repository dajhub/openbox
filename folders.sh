#!/bin/bash
set -e

echo "Creating folders for later use"

[ -d $HOME"/Documents" ] || mkdir -p $HOME"/Documents"
[ -d $HOME"/Pictures" ] || mkdir -p $HOME"/Pictures"
[ -d $HOME"/Downloads" ] || mkdir -p $HOME"/Downloads"

[ -d $HOME"/.icons" ] || mkdir -p $HOME"/.icons"
[ -d $HOME"/.themes" ] || mkdir -p $HOME"/.themes"
[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"

[ -d $HOME"/.config/geany" ] || mkdir -p $HOME"/.config/geany"
[ -d $HOME"/.config/kitty" ] || mkdir -p $HOME"/.config/kitty"
[ -d $HOME"/.config/openbox" ] || mkdir -p $HOME"/.config/openbox"
[ -d $HOME"/.config/rofi" ] || mkdir -p $HOME"/.config/rofi"
[ -d $HOME"/.config/sxhkd" ] || mkdir -p $HOME"/.config/sxhkd"
[ -d $HOME"/.config/tint2" ] || mkdir -p $HOME"/.config/tint2"

[ -d $HOME"/.local/bin" ] || mkdir -p $HOME"/.local/bin"
[ -d $HOME"/.local/share/xfce4/terminal/colorschemes" ] || mkdir -p $HOME"/.local/share/xfce4/terminal/colorschemes"
[ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"


echo "###############################################"
echo "### Personal folders created or existed already"
echo "###############################################"


echo "Copy fonts to .fonts"

cp -R ~/openbox/.fonts/* ~/.fonts/

echo "Building new fonts into the cache files";
echo "Depending on the number of fonts, this may take a while..."
fc-cache -fv ~/.fonts


echo "############################################"
echo "#   Fonts have been copied and loaded       "
echo "############################################"

echo "Copy fonts to .icons"

cp -R ~/openbox/.icons/* ~/.icons/

echo "############################################"
echo "#   Icons have been copied across           "
echo "############################################"

echo "Copy themes to .themes"

cp -R ~/openbox/.themes/* ~/.themes/

echo "############################################"
echo "#   Themes have been copied across          "
echo "############################################"

echo "Copy .local/bin to .local/bin"

cp -R ~/openbox/.local/bin* ~/.local/

echo "############################################"
echo "#   Bin has been copied across              "
echo "############################################"


echo "Copy .config folders and files across to .config"

cp -R ~/openbox/.config/geany* ~/.config/
cp -R ~/openbox/.config/kitty* ~/.config/
cp -R ~/openbox/.config/openbox* ~/.config/
cp -R ~/openbox/.config/rofi* ~/.config/
cp -R ~/openbox/.config/sxhkd* ~/.config/
cp -R ~/openbox/.config/tint2* ~/.config/


echo "############################################"
echo "#   .config folders and files have been copied across  "
echo "############################################"
