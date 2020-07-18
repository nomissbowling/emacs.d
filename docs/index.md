<h1 style="text-align:center;">Configurations for GNU Emacs</h1>


<!-- .. minorugh documentation master file, created by -->
<!--    sphinx-quickstart on Sat Jul 18 17:41:56 2020. -->
<!--    You can adapt this file completely to your liking, but it should at least -->
<!--    contain the root `toctree` directive. -->
   
## はじめに
VirtualBoxにArchLinuxをインストールし、Xfceの設定までをまとめました。BIOS環境でも試みましたがうまく行かなかったので、UEFI-GPT環境でインストールします。

## ホスト環境
- Linux Debian10
- VertualBox 6.0.14


## ゲスト環境
- メモリー 4096MB
- ビデオメモリー 256MB
- ディスク 64GB（固定サイズ）
- archlinux-2019.12.01-x86_64.iso

## VirtualBoxの設定

### 一般
- クリップボードの共有：双方向
- ドラッグ＆ドロップ：双方向


### システム
### マザーボード

#### 起動順序
フロッピーのチェックを外す。

#### チップセット
ICH9を選択する。

#### 拡張機能
以下をチェックする。

- I/O APICを有効化
- EFIを有効化
- ハードウェアクロックをUTCにする

#### プロセッサー

##### プロセッサー数
ホストのコア数の半分にする。

##### 拡張機能
PAE/NXを有効化にチェックする。

#### アクセラレーション

##### 準仮想化インターフェース
KVMを選択する。

##### 仮想化支援機能
以下をチェックする。

- VT-x/AMD-Vを有効化
- ネステッドページングを有効化

### ディスプレイ
#### スクリーン
##### ビデオメモリー
256MBにする。
```shell
$ cd 'VirtualBoxのインストール先'
$ VBoxManage modifyvm "仮想OSの名前" --vram 256
```

#### アクセラレーション
3Dアクセラレーションを有効化にチェックする。

### ストレージ
SSD*(Solid-state drive)にチェックする。

## インストール

### キーマップの設定とvimインストロール

- 日本語キーボードの設定
- いろいろ設定ファイルを触るので使い慣れたvimをインストール

```shell
 # loadkeys jp106
 # pacman -Sy vim
```

### 通信できているかの確認、時計を合わせる

```shell
 # ping -c 3 www.google.com  
 # timedatectl set-ntp true  
```

### パーテーションの準備

- パーティションを切っていきます
- Vboxなので基本はsdaとなるが、一応lsblkを使用して自分のデバイス名を確認しておくといい。

```shell
 # gdisk /dev/sdX  
Command (? for help):o  

This option deletes all partitions and creates a new protective MBR.  
Proceed? (Y/N): y  

Command (? for help):n //このコマンドで新しいパーティションを作る  
Partition number: 1  
First sector     : Enter  
Last sector      : +512M  
Hex code or GUID : EF00  

Command (? for help):n  
Partition number: Enter  
First sector     : Enter  
Last sector      : Enter  
Hex code or GUID : Enter  

Command (? for help):w  
Do you want to proceed? (Y/N)y 
```
### パーティションのフォーマット,マウント

```shell
 # mkfs.vfat -F32 /dev/sda1  
 # mkfs.ext4 /dev/sda2  
 # mount /dev/sda2 /mnt  
 # mkdir -p /mnt/boot  
 # mount /dev/sda1 /mnt/boot 
```

### ベースシステムのインストール

日本のミラーサーバーを一番上に移動する。

```shell
 # vim /etc/pacman.d/mirrorlist
```
`/Japan` で検索、見つかったら `2dd` で2行削除、`gg` でカーソル移動し、`p` でリストの先頭にペースト。
`:wq`で抜ける。

繰り返していくつかリストアップしておくいく...面倒なので私の場合は一つだけ。

```shell
 ##

 ## Arch Linux repository mirrorlist
 ## Filtered by mirror score from mirror status page
 ## Generated on 2018-06-01
 ##


 ## Japan
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
 ## Japan
Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch
 ## Japan
Server = http://archlinux.asia-east.mirror.zoidplex.net/$repo/os/$arch
 ## Japan
Server = http://mirrors.cat.net/archlinux/$repo/os/$arch
 ## China
Server = http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
 ## Lithuania
Server = http://mirrors.atviras.lt/archlinux/$repo/os/$arch
 ## South Africa
Server = http://mirror.wbs.co.za/archlinux/$repo/os/$arch
 ## Singapore
Server = http://mirror.nus.edu.sg/archlinux/$repo/os/$arch
 ## Belgium
Server = http://archlinux.cu.be/$repo/os/$arch
...
```
ミラーリストの編集が終わったらベースシステムをインストールする。

```shell
 # pacman -Syy
 # pacstrap /mnt linux base base-devel linux-firmware
```

### fstabの生成

```shell
 # genfstab -U /mnt >> /mnt/etc/fstab  
 # cat /mnt/etc/fstab 
```

### chrootでの作業

vimを再インストールしておくこと。

```shell
 # arch-chroot /mnt /bin/bash 
 # pacman -Sy vim
 # vim /etc/locale.gen
en_US.UTF-8,ja_JP.UTF-8のコメントアウトを外す  

 # locale-gen
 # echo LANG=en_US.UTF-8 > /etc/locale.conf  
 # export LANG=en_US.UTF-8
```

### キーマップを日本語にする（新規ファイル）

```shell
 # vim /etc/vconsole.conf
KEYMAP=jp106
```

### タイムゾーンを東京にする

```shell
 # ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
 # hwclock --systohc --utc
```

### ロケールを設定
```shell
 # vim /etc/locale.gen
 'en_US.UTF-8 UTF-8'と'ja_JP.UTF-8 UTF-8'のコメントを解除する。

 # locale-gen
 # echo LANG=en_US.UTF-8 > /etc/locale.conf
```

### ホストネームを追加する
ホスト名はとりあえずarchにしておくといいかもです。

```shell
 # echo arch > /etc/hostname
 # vim /etc/hosts

... 
 ## Static table lookup for hostnames.
 ## See hosts(5) for details. 
127.0.0.1       localhost
::1             localhost
127.0.1.1       arch.localdomain arch
...
```
### systemd-networkd等が起動されるようにする
細かい設定はOSのインストール後にします。

```shell
 # systemctl enable systemd-networkd 
 # systemctl enable systemd-resolved 
```

### 初期RAMディスク作成

```shell
 # mkinitcpio -p linux
```

### パスワードの設定
```
 # passwd
```

### ブートローダのインストール
```shell
 # bootctl --path=/boot install
```

### ブートローダのタイムアウト設定

```shell
 # vim /boot/loader/loader.conf
default arch
timeout 3
editor  0
```

### ブートローダの設定

```shell
 # vim /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=/dev/sda2 rw
```

### chroot 終了
```shell
 # exit
```

### パーティションのアンマウント

```shell
 # umount -R /mnt
 # shutdown -h now 
```

### 再起動
一度シャットダウンし、VirtualBoxの設定からインストールメディアを除去したあと再起動し`root`でログインする。

### ネットワークの設定
OSをインストールした段階では、まだネットワークは有効になっていません
なので、通信できるように設定をします

```shell
 # mv /etc/resolv.conf /etc/resolv.conf.orig 
 # ln -s /run/systemd/resolve/resov.conf /etc/resolv.conf 
 # ip a 
 # vim /etc/systemd/network/20-wired.network

[Match] 
Name=en* //ここには ip aで出てきた出力の下に出てきた、例えば、enp0s3などの英数字を入れてください 

[Network] 
DHCP=yes 
```

あとはサービスを再起動してネットワークが通じるようになります

```shell
 # systemctl restart systemd-networkd 
 # systemctl restart systemd-resolved 
```


### VirtualBox ゲストサービスを起動
```shell
$ VBoxClient --clipboard --draganddrop --seamless --display --checkhostversion
```
### 一般ユーザーの作成
```shell
 # useradd -m -G wheel -s /bin/bash "ユーザー名" 
 # passwd "ユーザー名" 
 # visudo 
... 
 ## 
 ## Runas alias specification 
 ## 

 ## 
 ## User privilege specification 
 ## 
root ALL=(ALL) ALL 

 ## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL) ALL 

 ## Same thing without a password 
 # %wheel ALL=(ALL) NOPASSWD: ALL 
... 
```
他人が全く手に触れない使用環境であれば、`NOPASSWD` のほうを設定しても便利だ。
### Guest Additions インストール
```shell
 # pacman -S virtualbox-guest-utils
'virtualbox-guest-modules-arch'を選択する。

#### vboxservice サービスを有効化
```shell
 # systemctl enable vboxservice.service
 # systemctl start vboxservice.service
```

### 再起動する。
一般ユーザーを作成したらRootからログアウトして、作成したユーザーからログインします。

Guest Additions が適応されているかも確認する。私の場合は上手く行かなかったのでGUIになってから再設定した。

### pacmanの色付け
```
$ sudo vim /etc/pacman.conf
...
 ## Misc options 
 ##UseSyslog 
Color // ここのコメントを外す 
 ##TotalDownload 
CheckSpace 
 ##VerbosePkgLists 
... 
```

### yayのインストール
AURに登録されているパッケージをインストールするためのパッケージを導入します。

ここではyay(Yet another Yogurt)をインストールします。

```shell
$ sudo pacman -S git
$ git clone https://aur.archlinux.org/yay.git 
$ cd yay 
$ makepkg -si
```

これでyayがインストールされました。


### Xorgのインストール
次のコマンドでPCに搭載されているグラフィックカードを確認します

VirtualBoxの場合はxf86-video-vesaです

xf86-video-fbdevも入れておくといいらしいです
```shell 
$ lspci | grep -e VGA -e 3D 
$ sudo pacman -S xf86-video-vesa　xf86-video-fbdev xorg-server xorg-apps xorg-xinit mesa xorg-twm xorg-xclock xterm
$ startx
```
Xorgが立ち上がれば成功です

タッチパッドを認識しない場合はlibinputか、xf86-input-libinputを入れて設定してください。


### XFCEのインストール

XFCEとその他のパッケージをインストール
```shell
$ sudo pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings plank adapta-gtk-theme papirus-icon-theme xdg-user-dirs-gtk gamin gvfs xarchiver zip unzip pulseaudio pulseaudio-alsa pavucontrol alsa-utils noto-fonts-cjk ttf-dejavu ttf-roboto chromium firefox firefox-i18n-ja
$ yay -S google-chrome ttf-myricam breeze-snow-cursor-theme
```
#### lightdm.confを編集

```shell
$ sudo vim /etc/lightdm/lightdm.conf
... 
 ##unity-compositor-command=unity-system-compositor
 ##unity-compositor-timeout=60
greeter-session=lightdm-gtk-greeter
...
```
#### lightdmを有効化する 
```shell
$ sudo systemctl enable lightdm
```

#### 一度再起動する
```shell
$ sudo reboot
```

### 日本語環境の設定
環境変数日本語用に変更する

```shell
$ sudo nano /etc/locale.conf  
LANG=ja_JP.UTF-8  
 ## LANG=en_US.UTF-8  
```

### fcitxのインストール
Emacsで emacs-mozc-helperを使えるようにするためにfcitx-mozcにパッチを当ててからインストールする。

#### 1. mozc-emacs  mozcがインストールされている場合はアンインストールしておく
`fcitx-mozc` とconfictするため。

```shell
$ sudo pacman -R emacs-mozc mozc
```

#### 2. fcitx-mozcのPKGCONFIGを落としてくる

```shell
$ yay -G fcitx-mozc
```
### パッチを当てる

バージョンによって変わるので、直接編集したほうが無難。

```shell
$ cd fcitx-mozc
$ sudo vim PKGBUILD

##### PKGBUILD.patch
```shell
--- PKGBUILD    2018-01-08 16:08:09.000000000 +0900
+++ -   2018-01-13 21:17:48.133846572 +0900
@@ -77,7 +77,7 @@

   cd mozc/src

-  _targets="server/server.gyp:mozc_server gui/gui.gyp:mozc_tool unix/fcitx/fcitx.gyp:fcitx-mozc"
+  _targets="server/server.gyp:mozc_server gui/gui.gyp:mozc_tool unix/fcitx/fcitx.gyp:fcitx-mozc unix/emacs/emacs.gyp:mozc_emacs_helper"

   QTDIR=/usr GYP_DEFINES="document_dir=/usr/share/licenses/$pkgname use_libzinnia=1" python2 build_mozc.py gyp
   python2 build_mozc.py build -c $_bldtype $_targets
@@ -91,6 +91,8 @@
   install -D -m 755 out_linux/${_bldtype}/mozc_server "${pkgdir}/usr/lib/mozc/mozc_server"
   install    -m 755 out_linux/${_bldtype}/mozc_tool   "${pkgdir}/usr/lib/mozc/mozc_tool"

+  install -D -m 755 out_linux/${_bldtype}/mozc_emacs_helper "${pkgdir}/usr/bin/mozc_emacs_helper"
+  install -d "${pkgdir}/usr/share/licenses/$pkgname/"
+  install -m 644 LICENSE data/installer/*.html "${pkgdir}/usr/share/licenses/${pkgname}/"
```

### ビルド＆インストールする

```shell
$ makepkg -si
```

### fcitxインストール
```shell
$ sudo pacman -Sy fcitx-im fcitx-configtool
```
### xprofileの設定（新規ファイル）
```shell
$ vim ~/.xprofile 

export GTK_IM_MODULE=fcitx 
export QT_IM_MODULE=fcitx 
export XMODIFIERS=”@im=fcitx” 
```

## dropboxのインストール

