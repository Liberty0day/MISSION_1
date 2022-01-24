curl https://raw.githubusercontent.com/Liberty0day/MISSION_1/main/install.sh |tee install.sh
echo "[+] Download install.sh"
curl https://raw.githubusercontent.com/Liberty0day/MISSION_1/main/install_chroot.sh |tee install_chroot.sh
echo "[+] Download install_chroot.sh"
curl https://raw.githubusercontent.com/Liberty0day/MISSION_1/main/install_liberty.sh |tee install_liberty.sh
echo "[+] Download install_liberty.sh"

chmod +x install.sh
chmod +x install_chroot.sh
chmod +x install_liberty.sh

echo "[+] Start install"
zsh install.sh
zsh install_yay.sh
