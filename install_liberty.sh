echo "+ install git"

pacman -Sy --noconfirm git

echo "+ install ohmyzsh"

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


