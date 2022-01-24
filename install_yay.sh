echo "+ install yay"

su liberty -c "git clone https://aur.archlinux.org/yay"
su liberty -c "cd yay/"
su liberty -c "makepkg -sri"


echo "+ install font"

su liberty -c "yay -S ttf-ms-fonts"
