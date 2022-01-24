echo "+ install git"

pacman -Sy --noconfirm git
pacman -Sy --noconfirm go

echo "+ install ohmyzsh"

su liberty -c "sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)""

