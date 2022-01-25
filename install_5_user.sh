echo "+ make user"
useradd -mG wheel -s /usr/bin/zsh -c "Liberty" liberty
passwd liberty
echo "+ make root password"
passwd root
echo "+ make user sudoers remove # %wheel ALL=(ALL) ALL in visudo /etc/sudoers"
#sudo sed -i '82 s/^#//' /etc/sudoers
sed -i '82 s/^#//' /mnt/etc/sudoers
echo "+ enable time ntp and deamon cron and syslog-ng"
pacman -Sy --noconfirm cronie ntp
systemctl enable cronie
systemctl enable ntpd
systemctl enable syslog-ng@default
echo "+ enable tlp for batterie"
pacman -S --noconfirm tlp && systemctl enable tlp
echo "+ install driver for graphic card"
pacman -S --noconfirm xorg-{server,xinit,apps} xdg-user-dirs xf86-video-intel mesa lib32-mesa
echo "+ install cpu"
pacman -Sy --noconfirm intel-ucode
echo "+ install audio codec"
pacman -S --noconfirm gst-libav gst-plugins-{base,good,bad,ugly}
echo "+ install fonts"
pacman -S --noconfirm xorg-fonts-type1 gsfonts sdl_ttf ttf-{dejavu,bitstream-vera,liberation} noto-fonts-{cjk,emoji,extra}
