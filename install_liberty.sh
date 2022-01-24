echo "+ install git"

pacman -Sy --noconfirm git
pacman -Sy --noconfirm go

echo "+ install ohmyzsh"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


sudo -u liberty /home/liberty/install_yay.sh
