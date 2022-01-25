echo "+ jump to arch-root install"

cp install_4.0_user.sh /mnt/home

arch-chroot /mnt sh /home/install_4.0_user.sh
#rm /mnt/home/install_4.0_user.sh
echo 'Setup Complete!'
echo 'type "reboot" and remove installation media.'
