#!/bin/bash
AUTO_DIR=$(pwd)
#한글입력기를 자동으로 설정해줍니다.

cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay -S google-chrome chrome-gnome-shell ttf-d2coding

gsettings set org.gnome.desktop.input-sources sources "[('ibus', 'hangul')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul', 'korean:rctrl_hanja']"

echo -e "
\033[01;32m 
-- 한글 입력 설정이 완료되었습니다. -- 
\033[00m
"

