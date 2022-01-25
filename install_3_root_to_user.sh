echo "+ jump to arch-root install"
cp fstab /mnt/home
cp crypttab /mnt/home
cp install_4_user.sh /mnt/home

arch-chroot /mnt sh /home/install_4_user.sh
rm /mnt/home/install_4_user.sh
echo 'Setup Complete!'
echo 'type "reboot" and remove installation media.'
