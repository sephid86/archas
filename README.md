# archas

- efi 설치. 멀티부팅을 위해 grub 설치-\n
-다른 운영체제와 다른 저장장치사용-
-예를 들어 윈도우는 1번 SSD(sda) 리눅스는 2번 SSD(sdb)-

1. ping 테스트로 네트워크 연결 되었는지 확인
ping 168.126.63.1
ping archlinux.org
(무선랜 설정이 필요하거나 인터넷 연결이 안되어 설정이 필요하면 구글 검색으로 해결한 다음 진행)

2. 파티션 설정
-파티션 정보 확인-
fdisk -l

-파티션 생성-
gdisk /dev/설치할디스크

o 엔터 y 엔터

n 엔터 (파티션 새로 만들기)
엔터 (파티션 번호. null엔터는 자동)
엔터 (첫 섹터. null엔터는 자동)
+512M
ef00 (EFI 파티션)

n 엔터
엔터
엔터
+8G
8200 (스왑파티션)

n 엔터
엔터
엔터
엔터 (나머지 전체용량)
엔터 (기본 리눅스 파티션)

p (파티션 확인)
w (파티션 작성)
y

-설정된 파티션 포멧-
mkfs.vfat -F32 /dev/설치할디스크1 (위에서 설정한 EFI 파티션)
mkfs.ext4 /dev/설치할디스크3 (위에서 설정한 기본 리눅스 파티션)
mkswap /dev/설치할디스크2 (위에서 설정한 스왑파티션)
swapon !$

3. 설정완료된 파티션 마운트 하기
mount /dev/설치할디스크3 /mnt
mkdir /mnt/boot
mount /dev/설치할디스크1 /mnt/boot

4. 리눅스 베이스 설치 하기
pacstrap /mnt base linux linux-firmware git

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

5. archas 스크립트 다운로드 및 스크립트 실행
\# git clone https://github.com/sephid86/archas.git

\# cd archas

\# ./archas.sh
