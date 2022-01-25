cp fstab /mnt/home
cp crypttab /mnt/home

echo "+ vim /etc/crypttab"
 cat /mnt/home/crypttab  > /mnt/etc/crypttab 

echo "+ vim /etc/fstab"
cat /mnt/home/fstab > /mnt/etc/fstab
