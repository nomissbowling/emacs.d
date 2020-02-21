# My private emacs configuration files

## Screen Shot

![Alt Text](https://live.staticflickr.com/65535/49563670097_cc031076a9_b.jpg)

## Usage environment

### OS
  * GNU Linux Debian 9
  * macOS High Sierra 10.13.6

### GNU Emacs

  * Site: [homebrew-emacsmacport](https://github.com/railwaycat/homebrew-emacsmacport/releases)
  * Download:  [emacs-26.2-mac-7.6-10.13.6.zip](https://github.com/railwaycat/homebrew-emacsmacport/releases/download/emacs-26.2-mac-7.6/emacs-26.2-mac-7.6-10.13.6.zip)

### Configuration file placement

* Put all files under emacs.d in '~/Dropbox' directory
* Then put a symboliclink of 'init.el' to  '~/.emacs.d'

>By executing the above settings for gnu/Linux and macOS,
>You can use Emacs with the same operation from either environment.

## Consept

  * I installed 101 packages from melpa and downloaded some other elisp from github.
  * We use lazy loading with 'use-package' and use 'after-init-hook' whenever possible for fast emacs startup.
  * This repository only discloses personal configuration information, and does not guarantee its operation.

## Referenced code and article

  * [Github: masasam/dotfiles](https://github.com/masasam/dotfiles)
  * [Github: seagle0128/.emacs.d](https://github.com/seagle0128/.emacs.d)
  * [Qiita: Emacsモダン化計画](https://qiita.com/Ladicle/items/feb5f9dce9adf89652cf)
