#!/bin/bash
AUTO_DIR=$(pwd)
#-----아치리눅스 자동 설치 스크립트
#-----last update 2021-10-11
#-----http://k-lint.net
echo -e "
\033[41m

--- caution ---
This script should be executed after completing partition setup, formatting, and mounting.
It should be executed after the arch-chroot /mnt process is completed.

Mount specified in script: /mnt
\033[44m

Hello.
Arch Linux automatic installation script.

-Things installed by default
grub multiboot
gnome
vim

http://k-lint.net - update 211011 - This is for korean.
\033[0m
---Press any key to start the installation."
read
#-1.리눅스 베이스 설치
#pacstrap /mnt base linux linux-firmware

#genfstab -U /mnt >> /mnt/etc/fstab

#arch-chroot /mnt

#시간설정
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
timedatectl set-local-rtc 1 --adjust-system-clock
hwclock --systohc

#언어설정
echo ko_KR.UTF-8 UTF-8 > /etc/locale.gen
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=ko_KR.UTF-8 > /etc/locale.conf

#호스트네임 설정
echo arch > /etc/hostname

#컴파일에 멀티 코어 쓰레드 사용 설정입니다.
sudo echo "MAKEFLAGS='-j$(nproc)'" >> /etc/makepkg.conf

#사용자 계정 sudo 명령어 설정.
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

#root 패스워드 설정
echo "
\033[01;32m -Please enter the root password. \033[00m"
passwd

#계정 추가
echo "
\033[01;32m -Please enter your user account ID \033[00m"
read userid
useradd -m -g users -G wheel -s /bin/bash ${userid}

echo "
\033[01;32m -Please enter your user password \033[00m"
passwd ${userid}

#배쉬 컬러 설정입니다.
cp DIR_COLORS /etc
cp bash.bashrc /etc
cp .bashrc /etc/skel
cp .bashrc ~/
cp .bashrc /home/${userid}/

#대한민국 미러 사이트를 등록합니다. - 원활한 다운속도를 위해.
echo "Server = https://mirror.premi.st/archlinux/\$repo/os/\$arch
Server = http://mirror.premi.st/archlinux/\$repo/os/\$arch
Server = https://ftp.lanet.kr/pub/archlinux/\$repo/os/\$arch
Server = http://ftp.lanet.kr/pub/archlinux/\$repo/os/\$arch
Server = http://mirror.anigil.com/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

#미러리스트를 적용시켜 줍니다.
echo "[multilib]
Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

#부팅관련 설치입니다. 네트워크 설치 설정도 포함합니다. vim 설치 포함.
pacman -S vim os-prober ntfs-3g efibootmgr networkmanager intel-ucode
systemctl enable NetworkManager

#root 용 vim 설정 해줍니다.
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/colors
#cd ~/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim -o ~/.vim/colors/

#grub 설치 및 설정 - 멀티부팅을 자동으로 잡아줍니다.
pacman -S grub
sed -i 's/GRUB_DISABLE_OS_PROBER="true"/GRUB_DISABLE_OS_PROBER="false"/g' /usr/bin/grub-mkconfig
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

#gnome 설치 - 한글 입력기와 noto 폰트 설치됩니다.
pacman -S gnome gnome-shell-extensions gnome-tweaks noto-fonts-cjk ibus-hangul 
systemctl enable gdm

#사용자계정으로 전환
su - sephid86

#사용자계정에서 시간설정을 다시 한번 잡아줍니다.
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
timedatectl set-local-rtc 1 --adjust-system-clock
sudo hwclock --systohc

#vim 설정을 해줍니다.
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/colors
#cd ~/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim -o ~/.vim/colors/
vim +PluginInstall +qall

#root 계정용 vim 설정도 해줍니다.
sudo vim +PluginInstall +qall

#한글입력기를 자동으로 설정해줍니다.
gsettings set org.gnome.desktop.input-sources sources "[('ibus', 'hangul')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul', 'korean:rctrl_hanja']"

#동영상 재생 프로그램, 터미널, 음악 재생 프로그램 설치합니다. 
sudo pacman -Syu
sudo pacman -S smplayer smplayer-skins smplayer-themes rhythmbox sudo xfce4-terminal ffmpegthumbnailer

#xfce4 터미널을 설정합니다.
sudo pacman -R gnome-terminal
cp -v terminalrc ~/.config/xfce4/terminal/

#AMD ATI 드라이버 설치합니다.
sudo pacman -S xf86-video-ati xf86-video-amdgpu mesa vulkan-radeon lib32-vulkan-radeon mesa-vdpau lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver vulkan-icd-loader vulkan-tools

echo "
\033[01;32m 
-- Installation is complete.
Please reboot by entering the commands below.

exit
umount -R /mnt
reboot
\033[00m
"
exit
