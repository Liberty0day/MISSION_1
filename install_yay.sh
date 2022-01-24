echo "+ install yay"

git clone https://aur.archlinux.org/yay
cd yay/
makepkg -sri


echo "+ install font"

yay -S ttf-ms-fonts
