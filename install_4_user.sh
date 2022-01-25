#!/bin/bash
echo "+ make name for your system"

arch-chroot /mnt echo nosecure > /etc/hostname

echo "+ add machine inside host file "

arch-chroot /mnt echo '127.0.1.1 nosecure.local nosecure' >> /etc/hosts

echo "+ make time world"

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

echo "+ edit file vim /etc/locale.gen"

arch-chroot /mnt sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen

arch-chroot /mnt locale-gen

echo "+ define language "

arch-chroot /mnt echo LANG="en_US.UTF-8" > /etc/locale.conf

echo "+ define keboard like vim /etc/locale.conf"

arch-chroot /mnt echo KEYMAP=us > /etc/vconsole.conf

echo "+ install and enable network for next start of the system"

arch-chroot /mnt pacman -Sy --noconfirm networkmanager
arch-chroot /mnt systemctl enable NetworkManager

echo "+ enable color vim /etc/pacman.conf"

arch-chroot /mnt sed -i 's/#Color/Color/g' /etc/pacman.conf
arch-chroot /mnt sed -i 's/#UseSyslog/UseSyslog/g' /etc/pacman.conf

echo "+ remove # for enable libs 32b vim /etc/pacman.conf"

arch-chroot /mnt sed -i '93 s/^#//' /etc/pacman.conf
arch-chroot /mnt sed -i '94 s/^#//' /etc/pacman.conf

echo "+ enable forward syslog vim /etc/systemd/journald.conf"

arch-chroot /mnt sed -i 's/#ForwardToSyslog=no/ForwardToSyslog=yes/g' /etc/systemd/journald.conf

echo "+ edit vim /etc/mkinitcpio.conf for enable lvm2 and add arg in the ligne HOOK=()"

arch-chroot /mnt sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block filesystems keyboard keymap lvm2 encrypt udev fsck)/g' /etc/mkinitcpio.conf

echo "+ generate noyau image"

arch-chroot /mnt mkinitcpio -p linux-lts

echo "+ configure grub , remote empty ligne "

arch-chroot /mnt sed -i '/GRUB_CMDLINE_LINUX=/d' /etc/default/grub

echo "+ enable grub "

arch-chroot /mnt sed -i 's/#GRUB_ENABLE_CRYPTODISK=y/GRUB_ENABLE_CRYPTODISK=y/' /etc/default/grub

echo "+ add root with UUID"

arch-chroot /mnt echo GRUB_CMDLINE_LINUX=\"cryptdevice=UUID=$(blkid -s UUID -o value /dev/mapper/archlvm-root):root root=/dev/mapper/root\" >> /etc/default/grub

echo "+ install grub"

arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch_grub --recheck

echo "+ generate grub.cfg"

arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "+ generate key file"

arch-chroot /mnt mkdir -m 700 /etc/luks-keys
arch-chroot /mnt dd if=/dev/random of=/etc/luks-keys/home bs=1 count=256 status=progress

echo "+ make crypt home "

arch-chroot /mnt cryptsetup luksFormat -v -s 512 /dev/archlvm/home /etc/luks-keys/home

echo "+ add crypto inside mapper"

arch-chroot /mnt cryptsetup -d /etc/luks-keys/home open /dev/archlvm/home home

echo "+ format "

arch-chroot /mnt mkfs.xfs /dev/mapper/home

echo "+ mount partition"

arch-chroot /mnt mount /dev/mapper/home /home

echo "+ need uncrypt partition when you boot need edit file"
echo "+ vim /etc/crypttab"

1 root@archiso ~ # cp cryp /mnt 
root@archiso ~ # arch-chroot /mnt cat cryp > /etc/crypttab 

arch-chroot /mnt cat <<FUCK> /etc/crypttab
home /dev/mapper/archlvm-home  /etc/luks-keys/home
swap /dev/mapper/archlvm-swap  /dev/urandom  swap,cipher=serpent-xts-plain64,size=512
tmp  /dev/mapper/archlvm-tmp   /dev/urandom  tmp,cipher=serpent-xts-plain64,size=512
FUCK

arch-chroot /mnt echo "+ vim /etc/fstab"
cat <<FUCK> /etc/fstab
/dev/mapper/tmp   /tmp   tmpfs  defaults  0  0
/dev/mapper/swap  none   swap   sw  0  0
/dev/mapper/home  /home  xfs    defaults  0  2
FUCK
