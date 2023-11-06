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
read
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

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

#sway 로그인 세션설정파일
cp sway.desktop /usr/share/wayland-sessions/sway.desktop

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
#read userid
useradd -m -g users -G wheel -s /bin/bash setup

#계정 패스워드 설정
echo -e "
\033[01;32m -Please enter your user password \033[00m"
passwd setup

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
pacman -Sy --noconfirm vim base-devel os-prober ntfs-3g efibootmgr networkmanager amd-ucode intel-ucode
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
su - setup -c "cp /archas/.vimrc ~/"
su - setup -c "mkdir -p ~/.vim/bundle"
su - setup -c "mkdir -p ~/.vim/colors"
su - setup -c "cd ~/.vim/colors;curl -O https://raw.githubusercontent.com/nanotech/jellybeans.vim/master/colors/jellybeans.vim"
su - setup -c "git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim"
su - setup -c "vim +PluginInstall +qall"

#grub 설치 및 설정 - 멀티부팅을 자동으로 잡아줍니다.
pacman -Sy --noconfirm grub
grub-install --target=i386-pc --recheck /dev/sdd
grub-install --target=x86_64-efi --efi-directory /boot --recheck --removable
grub-mkconfig -o /boot/grub/grub.cfg
LC_ALL=C grub-mkconfig -o /boot/grub/grub.cfg

#--- gnome 설치
pacman -Sy --noconfirm gnome noto-fonts-cjk ibus-hangul gnome-shell-extensions firefox-i18n-ko xfce4-terminal ffmpegthumbnailer mpv

echo "MOZ_ENABLE_WAYLAND=1" >> /etc/environment

systemctl enable gdm

#사용자 계정 sudo 명령어 설정.
#pacman -Sy sudo
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

su - setup -c "git config --global core.editor vim"

#동영상 재생 프로그램, 터미널, 음악 재생 프로그램 설치합니다. 
#pacman -Sy smplayer smplayer-skins smplayer-themes ffmpegthumbnailer gst-libav gst-plugins-ugly rhythmbox xfce4-terminal

#pacman -Sy libreoffice-fresh-ko gimp

pacman -R --noconfirm gnome-software gnome-console

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

