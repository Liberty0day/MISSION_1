curl https://raw.githubusercontent.com/Liberty0day/MISSION_1/main/install.sh |tee install.sh
echo "[+] Download install.sh"

curl https://raw.githubusercontent.com/Liberty0day/MISSION_1/main/install_chroot.sh |tee install_chroot.sh
echo "[+] Download install_chroot.sh"

curl https://raw.githubusercontent.com/Liberty0day/MISSION_1/main/install_git_go_ohmyzsh.sh |tee install_liberty.sh
echo "[+] Download install_git_go_ohmyzsh.sh"

curl https://raw.githubusercontent.com/Liberty0day/MISSION_1/main/install_yay.sh |tee install_yay.sh
echo "[+] Downlaod install_yay.sh"

chmod +x install.sh
chmod +x install_chroot.sh
chmod +x install_git_go_ohmyzsh.sh
chmod +x install_yay.sh


#echo "[+] Start install"
#zsh install.sh

#echo "[+] Start install ohmyzsh go git"
#su liberty -c "zsh install_git_go_ohmyzsh.sh"

#echo "[+] Start install yay"
su liberty -c "zsh install_yay.sh"
