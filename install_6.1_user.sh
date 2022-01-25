echo "+ install ohmyzsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "+ install yay"

git clone https://aur.archlinux.org/yay
cd yay/
makepkg -sri


echo "+ install font"

yay -S ttf-ms-fonts
