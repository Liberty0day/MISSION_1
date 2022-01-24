echo "+ install git"

su liberty -c "pacman -Sy --noconfirm git"
pacman -Sy --noconfirm go

echo "+ install ohmyzsh"

su liberty -c "sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)""

