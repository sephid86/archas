#!/bin/bash
AUTO_DIR=$(pwd)
#yay 와 크롬을 설치해줍니다.
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S google-chrome chrome-gnome-shell

echo -e "
\033[01;32m 
-- 크롬 설치가  완료되었습니다. -- 
\033[00m
"

