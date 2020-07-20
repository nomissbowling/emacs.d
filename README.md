# My private emacs configuration files

## Screen Shot

![Alt Text](https://live.staticflickr.com/65535/50002999041_ede7526494_b.jpg)

## Usage environment

### OS
  * GNU Linux Debian 10.4
  * GNU Linux Microsoft Debian 10.4 on WSL

### GNU Emacs
 * GNU Emacs 26.3

## Install Emacs

This installs all dependencies for Emacs and then installs Emacs 26.3:

### install dependencies (got those from all over the net)

``` shell
sudo apt install -y autoconf automake autotools-dev bsd-mailx build-essential \
    diffstat gnutls-dev imagemagick libasound2-dev libc6-dev libdatrie-dev \
    libdbus-1-dev libgconf2-dev libgif-dev libgnutls28-dev libgpm-dev libgtk2.0-dev \
    libgtk-3-dev libice-dev libjpeg-dev liblockfile-dev liblqr-1-0 libm17n-dev \
    libmagickwand-dev libncurses5-dev libncurses-dev libotf-dev libpng-dev \
    librsvg2-dev libsm-dev libthai-dev libtiff5-dev libtiff-dev libtinfo-dev libtool \
    libx11-dev libxext-dev libxi-dev libxml2-dev libxmu-dev libxmuu-dev libxpm-dev \
    libxrandr-dev libxt-dev libxtst-dev libxv-dev quilt sharutils texinfo xaw3dg \
    xaw3dg-dev xorg-dev xutils-dev zlib1g-dev

```

### download and install

``` shell
cd ~
wget https://ftp.gnu.org/pub/gnu/emacs/emacs-26.3.tar.gz
tar -xzvf emacs-26.3.tar.gz
cd emacs-26.3
./configure
make
sudo make install

cd ~
rm -rf ~/emacs-26.3
rm ~/emacs-26.3.tar.gz

```

### Configuration file placement

* Put all files under emacs.d in '~/Dropbox' directory
* Then put a symboliclink of 'init.el' to  '~/.emacs.d'

>By executing the above settings for gnu/Linux and Windows Subsystem for Linux,
>You can use Emacs with the same operation from either environment.

## Consept

  * I installed 98 packages from melpa and downloaded some other elisp from github.
  * We use lazy loading with 'leaf' and use 'after-init-hook' whenever possible for fast emacs startup.
  * This repository only discloses personal configuration information, and does not guarantee its operation.

## Referenced code and article

  * [Github: masasam/dotfiles](https://github.com/masasam/dotfiles)
  * [Github: seagle0128/.emacs.d](https://github.com/seagle0128/.emacs.d)
  * [Qiita: Emacsモダン化計画](https://qiita.com/Ladicle/items/feb5f9dce9adf89652cf)
  * [Qiita: Emacs入門から始めるleaf.el入門](https://qiita.com/conao3/items/347d7e472afd0c58fbd7) 
