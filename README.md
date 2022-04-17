# archas

- efi 설치. 멀티부팅을 위해 grub 설치-<br>
(efi 설치이므로 virtual box 나 같은 가상환경 설치는 지원되지 않습니다.)
-다른 운영체제와 다른 저장장치사용-<br>
-예를 들어 윈도우는 1번 SSD(sda) 리눅스는 2번 SSD(sdb)-<br>
<br>
-저 편하려고 만들었는데 다른 초보분들께도 도움이 되길 바라는 마음에 올립니다.-<br>
<br>
1. ping 테스트로 네트워크 연결 되었는지 확인<br>
ping 168.126.63.1<br>
ping archlinux.org<br>
(무선랜 설정이 필요하거나 인터넷 연결이 안되어 설정이 필요하면 구글 검색으로 해결한 다음 진행)<br>
<br>
2. 파티션 설정<br>
-파티션 정보 확인-<br>
fdisk -l<br>
<br>
-파티션 생성-<br>
gdisk /dev/설치할디스크<br>
<br>
o 엔터 y 엔터<br>
<br>
n 엔터 (파티션 새로 만들기)<br>
엔터 (파티션 번호. null엔터는 자동)<br>
엔터 (첫 섹터. null엔터는 자동)<br>
+512M<br>
ef00 (EFI 파티션)<br>
<br>
n 엔터<br>
엔터<br>
엔터<br>
+8G<br>
8200 (스왑파티션)<br>
<br>
n 엔터<br>
엔터<br>
엔터<br>
엔터 (나머지 전체용량)<br>
엔터 (기본 리눅스 파티션)<br>
<br>
p (파티션 확인)<br>
w (파티션 작성)<br>
y<br>
<br>
-설정된 파티션 포멧-<br>
mkfs.vfat -F32 /dev/설치할디스크1 (위에서 설정한 EFI 파티션)<br>
mkfs.ext4 /dev/설치할디스크3 (위에서 설정한 기본 리눅스 파티션)<br>
mkswap /dev/설치할디스크2 (위에서 설정한 스왑파티션)<br>
swapon !$<br>
<br>
3. 설정완료된 파티션 마운트 하기<br>
mount /dev/설치할디스크3 /mnt<br>
mkdir /mnt/boot<br>
mount /dev/설치할디스크1 /mnt/boot<br>
<br>
4. 리눅스 베이스 설치 하기<br>
pacstrap /mnt base linux linux-firmware git<br>
<br>
genfstab -U /mnt >> /mnt/etc/fstab<br>
<br>
arch-chroot /mnt<br>
<br>
5. archas 스크립트 다운로드 및 스크립트 실행<br>
# git clone https://github.com/sephid86/archas.git<br>
# cd archas<br>
# ./archas.sh<br>
(AMD 나 라데온 그래픽 카드를 이용 하시는분은 ./archas-amd.sh)<br>
(Nvidia 는 아직.. 그래픽드라이버 직접 설치 하셔야 합니다...)<br>
<br>
<br>
추가로 한글 입력기 설정과 크롬 설치, yay 설치를 원하시는 경우는 <br>
위의 설치과정 종료후 재부팅하신후 아래 내용을 진행하시면 됩니다.<br>
아래 내용은 root 계정에서 실행되면 안되므로 <br>
반드시 일반 사용자계정으로 진행하셔야 합니다. <br>
<br>
1. 우선 기존의 archas 폴더를 사용자계정으로 복사합니다.<br>
$ cp -r /archas ~/<br>
<br>
-한글 입력기 설정-<br>
$ cd ~/archas/AfterReboot/<br>
$ ./hangul.sh<br>
<br>
-크롬 설치-<br>
$ cd ~/archas/AfterReboot/<br>
$ ./chrome.sh<br>
<br>
-yay 설치-<br>
(위의 크롬 설치를 진행하셨으면 이것을 실행할필요 없습니다.)<br>
$ cd ~/archas/AfterReboot/<br>
$ ./yay.sh<br>
