#!/bin/bash
echo "+ make name for your system"

echo nosecure > /etc/hostname

echo "+ add machine inside host file "

echo '127.0.1.1 nosecure.local nosecure' >> /etc/hosts

echo "+ make time world"

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

echo "+ edit file vim /etc/locale.gen"

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen

arch-chroot /mnt locale-gen

echo "+ define language "

echo LANG="en_US.UTF-8" > /etc/locale.conf

echo "+ define keboard like vim /etc/locale.conf"

echo KEYMAP=us > /etc/vconsole.conf

echo "+ install and enable network for next start of the system"

pacman -Sy --noconfirm networkmanager
systemctl enable NetworkManager

echo "+ enable color vim /etc/pacman.conf"

sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#UseSyslog/UseSyslog/g' /etc/pacman.conf

echo "+ remove # for enable libs 32b vim /etc/pacman.conf"

sed -i '93 s/^#//' /etc/pacman.conf
sed -i '94 s/^#//' /etc/pacman.conf

echo "+ enable forward syslog vim /etc/systemd/journald.conf"

sed -i 's/#ForwardToSyslog=no/ForwardToSyslog=yes/g' /etc/systemd/journald.conf

echo "+ edit vim /etc/mkinitcpio.conf for enable lvm2 and add arg in the ligne HOOK=()"

sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block filesystems keyboard keymap lvm2 encrypt udev fsck)/g' /etc/mkinitcpio.conf

echo "+ generate noyau image"

mkinitcpio -p linux-lts

echo "+ configure grub , remote empty ligne "

sed -i '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub

echo "+ enable grub "

sed -i 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/' /etc/default/grub

echo "+ add root with UUID"

echo GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$(blkid -s UUID -o value /dev/mapper/archlvm-root):root root=/dev/mapper/root\" >> /etc/default/grub

echo "+ install grub"

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck

echo "+ generate grub.cfg"

grub-mkconfig -o /boot/grub/grub.cfg

echo "+ generate key file"

mkdir -m 700 /etc/luks-keys
dd if=/dev/random of=/etc/luks-keys/home bs=1 count=256 status=progress

echo "+ make crypt home "

cryptsetup luksFormat -v -s 512 /dev/archlvm/home /etc/luks-keys/home

echo "+ add crypto inside mapper"

cryptsetup -d /etc/luks-keys/home open /dev/archlvm/home home

echo "+ format "

mkfs.xfs /dev/mapper/home

echo "+ mount partition"

mount /dev/mapper/home /home

echo "+ need uncrypt partition when you boot need edit file"
echo "+ vim /etc/crypttab"

cp crypttab /mnt 
cat crypttab > /etc/crypttab 

echo "+ vim /etc/fstab"
cp fstab /mnt 
cat fstab > /etc/fstab
