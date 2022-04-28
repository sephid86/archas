#!/bin/bash
AUTO_DIR=$(pwd)
#한글입력기를 자동으로 설정해줍니다.
gsettings set org.gnome.desktop.input-sources sources "[('ibus', 'hangul')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['korean:ralt_hangul', 'korean:rctrl_hanja']"
#gsettings set org.gnome.desktop.interface font-name "나눔바른고딕 11"
#gsettings set org.gnome.desktop.interface document-font-name "나눔바른고딕 11"
#gsettings set  org.gnome.desktop.wm.preferences font-name "나눔바른고딕 Semi-Bold 11"

echo -e "
\033[01;32m 
-- 한글 입력 설정이 완료되었습니다. -- 
\033[00m
"

