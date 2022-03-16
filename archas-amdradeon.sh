#!/bin/bash
AUTO_DIR=$(pwd)
#-----아치리눅스 자동 설치 스크립트
#-----Archlinux auto setup - archas
#-----last update 2022-03-08
#-----https://github.com/sephid86
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

https://github.com/sephid86 - update 220308 - This is for korean.
\033[0m
---Press any key to start the installation."
#-1.리눅스 베이스 설치
#pacstrap /mnt base linux linux-firmware
#genfstab -U /mnt >> /mnt/etc/fstab
#arch-chroot /mnt

#CPU 제조사 부터 확인합니다.
#FindCPU=$(lscpu | grep -o 'AMD' | head -1)
#echo ${FindCPU}
if [ "$(lscpu | grep -o 'AMD' | head -1)" == "AMD" ];
then
  CPUVendorID="amd"
else
  CPUVendorID="intel"
fi


read
#시간설정
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
timedatectl set-local-rtc 1 --adjust-system-clock
#hwclock --systohc
#hwclock -w

#언어설정
echo ko_KR.UTF-8 UTF-8 > /etc/locale.gen
echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
locale-gen
echo LANG=ko_KR.UTF-8 > /etc/locale.conf

#호스트네임 설정
echo arch > /etc/hostname

#컴파일에 멀티 코어 쓰레드 사용 설정입니다.
echo "MAKEFLAGS='-j$(nproc)'" >> /etc/makepkg.conf

#배쉬 컬러 설정입니다.
cp DIR_COLORS /etc
cp bash.bashrc /etc
cp .bashrc /etc/skel
cp .bashrc ~/

#pacman 컬러 설정입니다.
sed -i 's/#Color/Color/g' /etc/pacman.conf

#root 패스워드 설정
echo -e "
\033[01;32m -Please enter the root password. \033[00m"
passwd

#계정 추가
echo -e "
\033[01;32m -Please enter your user account ID \033[00m"
read userid
useradd -m -g users -G wheel -s /bin/bash ${userid}

echo -e "
\033[01;32m -Please enter your user password \033[00m"
passwd ${userid}

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
pacman -Sy vim base-devel os-prober ntfs-3g efibootmgr networkmanager ${CPUVendorID}-ucode
systemctl enable NetworkManager

#root 용 vim 설정 해줍니다.
cp .vimrc ~/
mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/colors
curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim
cp jellybeans.vim ~/.vim/colors
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

#유저용 vim 설정 해줍니다.
su - ${userid} -c "cp /archas/.vimrc ~/"
su - ${userid} -c "mkdir -p ~/.vim/bundle"
su - ${userid} -c "mkdir -p ~/.vim/colors"
su - ${userid} -c "cd ~/.vim/colors;curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim"
su - ${userid} -c "git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
su - ${userid} -c "vim +PluginInstall +qall"

#grub 설치 및 설정 - 멀티부팅을 자동으로 잡아줍니다.
pacman -Sy grub
sed -i 's/GRUB_DISABLE_OS_PROBER="true"/GRUB_DISABLE_OS_PROBER="false"/g' /usr/bin/grub-mkconfig
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

#gnome 설치 - 한글 입력기와 noto 폰트 설치됩니다.
pacman -Sy gnome gnome-shell-extensions gnome-tweaks noto-fonts-cjk ibus-hangul 
systemctl enable gdm

#사용자 계정 sudo 명령어 설정.
pacman -Sy sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

su - ${userid} -c "git config --global core.editor vim"

#동영상 재생 프로그램, 터미널, 음악 재생 프로그램 설치합니다. 
pacman -Syu
pacman -Sy smplayer smplayer-skins smplayer-themes gst-libav gst-plugins-ugly rhythmbox xfce4-terminal ffmpegthumbnailer

#xfce4 터미널을 설정합니다.
su - ${userid} -c "mkdir -p ~/.config/smplayer"
su - ${userid} -c "mkdir -p ~/.config/xfce4/terminal"
su - ${userid} -c "cp -v /archas/smplayer.ini ~/.config/smplayer"
su - ${userid} -c "cp -v /archas/styles.ass ~/.config/smplayer"
su - ${userid} -c "cp -v /archas/terminalrc ~/.config/xfce4/terminal/"
pacman -R gnome-terminal

#기본 프로그램을 지정해줍니다.
su - ${userid} -c "cp -v /archas/mimeapps.list ~/.config"
su - ${userid} -c "timedatectl set-local-rtc 1 --adjust-system-clock"

#AMD ATI 드라이버 설치합니다.
#pacman -Sy xf86-video-ati xf86-video-amdgpu mesa vulkan-radeon lib32-vulkan-radeon mesa-vdpau lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver vulkan-icd-loader vulkan-tools

pacman -Sy amdvlk vulkan-radeon
echo "options amdgpu si_support=1" >> /etc/modprobe.d/amdgpu.conf
echo "options amdgpu cik_support=1" >> /etc/modprobe.d/amdgpu.conf
echo "options radeon si_support=0" >> /etc/modprobe.d/radeon.conf
echo "options radeon cik_support=0" >> /etc/modprobe.d/radeon.conf

pacman -Sy vulkan-tools

#d2coding 폰트를 설치합니다.
git clone https://github.com/naver/d2codingfont.git
unzip d2codingfont/D2Coding-Ver1.3.2-20180524.zip -d /usr/share/fonts

echo -e "
\033[01;32m 
-- Installation is complete.
Please reboot by entering the commands below.

exit
umount -R /mnt
reboot
\033[00m
"

