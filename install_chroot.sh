
echo "+ make name for your system"

echo nosecure > /etc/hostname

echo "+ add machine inside host file "

echo '127.0.1.1 nosecure.local nosecure' >> /etc/hosts

echo "+ make time world"

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

echo "+ edit file vim /etc/locale.gen"

sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen

locale-gen

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

cryptsetup --type luks2 --pbkdf argon2id --cipher twofish-xts-plain64 --key-size 512 --hash sha512 --use-random --verify-passphrase luksFormat /dev/archlvm/home /etc/luks-keys/home

echo "+ add crypto inside mapper"

cryptsetup -d /etc/luks-keys/home open /dev/archlvm/home home

echo "+ format "

mkfs.xfs /dev/mapper/home

echo "+ mount partition"

mount /dev/mapper/home /home

echo "+ need uncrypt partition when you boot need edit file"
echo "+ vim /etc/crypttab"

cat <<FUCK>> /etc/crypttab
home /dev/mapper/archlvm-home  /etc/luks-keys/home
swap /dev/mapper/archlvm-swap  /dev/urandom  swap,cipher=serpent-xts-plain64,size=256
tmp  /dev/mapper/archlvm-tmp   /dev/urandom  tmp,cipher=serpent-xts-plain64,size=256
FUCK

echo "+ vim /etc/fstab"

cat <<FUCK>> /etc/fstab
/dev/mapper/tmp   /tmp   tmpfs  defaults  0  0
/dev/mapper/swap  none   swap   sw  0  0
/dev/mapper/home  /home  xfs    defaults  0  2
FUCK


echo "+ make user"

useradd -mG wheel -s /usr/bin/zsh -c "Liberty" liberty
passwd liberty

echo "+ make user sudoers remove # %wheel ALL=(ALL) ALL in visudo /etc/sudoers"

sudo sed -i '82 s/^#//' /etc/sudoers

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


echo "+ Switch user"

cd /home/liberty
sudo -u liberty /home/liberty/install_liberty.sh






