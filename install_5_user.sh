echo "+ make user"
arch-chroot /mnt useradd -mG wheel -s /usr/bin/zsh -c "Liberty" liberty
arch-chroot /mnt passwd liberty

echo "+ make user sudoers remove # %wheel ALL=(ALL) ALL in visudo /etc/sudoers"
arch-chroot /mnt sudo sed -i '82 s/^#//' /etc/sudoers
echo "+ enable time ntp and deamon cron and syslog-ng"
arch-chroot /mnt pacman -Sy --noconfirm cronie ntp
arch-chroot /mnt systemctl enable cronie
arch-chroot /mnt systemctl enable ntpd
arch-chroot /mnt systemctl enable syslog-ng@default
echo "+ enable tlp for batterie"
arch-chroot /mnt pacman -S --noconfirm tlp && systemctl enable tlp
echo "+ install driver for graphic card"
arch-chroot /mnt pacman -S --noconfirm xorg-{server,xinit,apps} xdg-user-dirs xf86-video-intel mesa lib32-mesa
echo "+ install cpu"
arch-chroot /mnt pacman -Sy --noconfirm intel-ucode
echo "+ install audio codec"
arch-chroot /mnt pacman -S --noconfirm gst-libav gst-plugins-{base,good,bad,ugly}
echo "+ install fonts"
arch-chroot /mnt pacman -S --noconfirm xorg-fonts-type1 gsfonts sdl_ttf ttf-{dejavu,bitstream-vera,liberation} noto-fonts-{cjk,emoji,extra}
