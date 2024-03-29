#!/bin/bash
AUTO_DIR=$(pwd)
#-----아치리눅스 자동 설치 스크립트
#-----Archlinux auto setup - archas
#-----last update 2022-05-13
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

https://github.com/sephid86 - update 220513 - This is for korean.
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
#hwclock -s
#timedatectl set-timezone Asia/Seoul
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
#timedatectl set-local-rtc 1
#---timedatectl set-ntp true
#timedatectl set-local-rtc 1 --adjust-system-clock
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
cp .bashrc ~/

#기본 설정파일을 복사합니다.
cp -rf skel /etc

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

#계정 패스워드 설정
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
sed -i 's/#\[multilib\]/\[multilib\]\nInclude = \/etc\/pacman.d\/mirrorlist/g' /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

pacman -Syu
pacman -Sy --noconfirm archlinux-keyring

#부팅관련 설치입니다. 네트워크 설치 설정도 포함합니다. vim 설치 포함.
pacman -Sy --noconfirm vim base-devel os-prober ntfs-3g efibootmgr networkmanager ${CPUVendorID}-ucode
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
pacman -Sy --noconfirm grub
sed -i 's/GRUB_DISABLE_OS_PROBER="true"/GRUB_DISABLE_OS_PROBER="false"/g' /usr/bin/grub-mkconfig
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
#grub-mkconfig -o /boot/grub/grub.cfg
LC_ALL=C grub-mkconfig -o /boot/grub/grub.cfg

#--- gnome 설치
pacman -Sy --noconfirm wireplumber pipewire-alsa pipewire-audio pipewire-jack pipewire-pulse pipewire-v4l2 pipewire-x11-bell lib32-pipewire lib32-pipewire-jack lib32-pipewire-v4l2 gst-plugin-pipewire hyprland ibus-hangul noto-fonts noto-fonts-cjk noto-fonts-emoji xdg-desktop-portal-hyprland smplayer smplayer-skins smplayer-themes ffmpegthumbnailer gst-libav gst-plugins-good gst-plugin-va rhythmbox xfce4-terminal libreoffice-fresh-ko gimp pavucontrol firefox-i18n-ko grim slurp dmenu wofi xorg-xwayland thunar tumbler gvfs pantheon-polkit-agent sddm

#echo "GTK_IM_MODULE=ibus" >> /etc/environment
#echo "QT_IM_MODULE=ibus" >> /etc/environment
#echo "XMODIFIERS=@im=ibus" >> /etc/environment

systemctl enable sddm

#사용자 계정 sudo 명령어 설정.
#pacman -Sy sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

su - ${userid} -c "git config --global core.editor vim"

#동영상 재생 프로그램, 터미널, 음악 재생 프로그램 설치합니다. 
#pacman -Sy smplayer smplayer-skins smplayer-themes ffmpegthumbnailer gst-libav gst-plugins-ugly rhythmbox xfce4-terminal

#pacman -Sy libreoffice-fresh-ko gimp

#pacman -R --noconfirm gnome-software gnome-console

#AMD ATI 드라이버 설치합니다. ----- 아래 주석 내용 사용 금지. radeon vulkan 활성에 문제 있음.-----
#pacman -Syy xf86-video-ati xf86-video-amdgpu mesa vulkan-radeon lib32-vulkan-radeon mesa-vdpau lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver vulkan-icd-loader vulkan-tools
#pacman -Sy amdvlk vulkan-radeon lib32-vulkan-radeon lib32-vulkan-icd-loader
#echo "options amdgpu si_support=1" >> /etc/modprobe.d/amdgpu.conf
#echo "options amdgpu cik_support=1" >> /etc/modprobe.d/amdgpu.conf
#echo "options radeon si_support=0" >> /etc/modprobe.d/radeon.conf
#echo "options radeon cik_support=0" >> /etc/modprobe.d/radeon.conf
#pacman -Sy vulkan-tools
#----- 위 주석 내용 사용 금지. /etc/mkinitcpio.conf
#----- 라데온의 경우 amdvlk 설치하면 vulkan 에서 에러남.
#----- 라데온의 경우 /etc/mkinitcpio.conf 에서 MODULES=(amdgpu radeon) 해주고 라데온 드라이버만 설치해야됨.
#----- 

pacman -Sy --noconfirm mesa-vdpau lib32-mesa-vdpau libva-mesa-driver lib32-libva-mesa-driver libva-vdpau-driver libvdpau-va-gl gstreamer-vaapi

#d2coding 폰트를 설치합니다.
#git clone https://github.com/naver/d2codingfont.git
#unzip d2codingfont/D2Coding-Ver1.3.2-20180524.zip -d /usr/share/fonts

#D2Coding - 나눔 폰트를 설치합니다.
mkdir -p /usr/share/fonts
cp -vrf /archas/nanumfont /usr/share/fonts
#fc-cache -f -v

echo -e "
\033[01;32m 
-- Installation is complete.
Please reboot by entering the commands below.

exit
umount -R /mnt
reboot
\033[00m
"

