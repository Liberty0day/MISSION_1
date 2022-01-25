echo "+ jump to arch-root install"
cp install_4_user.sh /mnt
cd /mnt
sudo chmod +x install_4_user.sh
sudo arch-chroot /mnt ./install_4_user.sh




cp script2 /mnt/home/
arch-chroot /mnt sh /home/script2

rm /mnt/home/script2
echo 'Setup Complete!'
echo 'type "reboot" and remove installation media.'



echo "+ jump to arch-root install"
cp install_4_user.sh /mnt/home
arch-chroot /mnt sh /home/install_4_user.sh
rm /mnt/home/install_4_user.sh
echo 'Setup Complete!'
echo 'type "reboot" and remove installation media.'
