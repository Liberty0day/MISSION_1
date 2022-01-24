echo "+ make partition 1 512Mo"

sgdisk /dev/sda -n1:0Mib:513MiB -t1:EF00

echo "+ make partiton 2 with the next all"

sgdisk /dev/sda -n2:+0:-0


echo "+ Initialisatione of physical volume "

pvcreate /dev/sda2


echo "+ make volume logic "

vgcreate archlvm /dev/sda2


echo "+ make logic volum"

lvcreate -L 10G -n root archlvm
lvcreate -L 2G -n swap archlvm
lvcreate -L 1G -n tmp archlvm
lvcreate -l 100%FREE -n home archlvm


echo "+ make cryto for boot partition"

cryptsetup --type luks2 --pbkdf argon2id --cipher serpent-xts-plain64 --key-size 512 --hash sha512 --use-random --verify-passphrase luksFormat /dev/archlvm/root


echo "+ test your crypto"

cryptsetup open /dev/archlvm/root root


echo "+ make filesystem and mount "

mkfs.xfs /dev/mapper/root
mount /dev/mapper/root /mnt


echo "+ build and  mount partition of boot"

mkfs.fat -F32 /dev/sda1
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot


echo "+ Install paquet"

pacman -Sy --noconfirm pacman-contrib


echo "+ backup original mirror "

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup


echo "+ select best mirror ranked and add"

rankmirrors -n 3 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist


echo "+ Install base system paquet"

pacstrap /mnt base base-devel go lvm2 nmap jq curl cryptsetup xfsprogs linux-lts linux-lts-headers linux-firmware zip unzip p7zip mlocate vim alsa-utils syslog-ng mtools dosfstools lsb-release ntfs-3g exfat-utils bash-completion zsh zsh-completions git grub efibootmgr os-prober


echo "+ make fstab"

genfstab -Up /mnt >> /mnt/etc/fstab
