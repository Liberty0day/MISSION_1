echo "+ jump to arch-root install"
cp install_4_user.sh /mnt
cd /mnt
sudo chmod +x install_4_user.sh
sudo arch-chroot /mnt ./install_4_user.sh
