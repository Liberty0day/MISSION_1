echo "+ install git"

su liberty -c "pacman -Sy --noconfirm git"
su liberty -c "pacman -Sy --noconfirm go"

echo "+ install ohmyzsh"

su liberty -c "sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)""

echo "+ install yay"

su liberty -c "git clone https://aur.archlinux.org/yay"
su liberty -c "cd yay/"
su liberty -c "makepkg -sri"


echo "+ install font"

su liberty -c "yay -S ttf-ms-fonts"
