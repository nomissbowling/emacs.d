<h1 style="text-align: center;">Configurations for GNU Emacs</h1>

## 1 はじめに

.. toctree::
   :maxdepth: 2
   :caption: Contents:



### Indices and tables

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`


### hoge

[GH](http://gospel-haiku.com)

``` emacs-lisp
;; hog test

(setq hoge)

```

> blockquote

```eval_rst
=====  =====  =======
A      B      A and B
=====  =====  =======
False  False  False
True   False  False
False  True   False
True   True   True
=====  =====  =======
```

* <i class="fa fa-exclamation-triangle" aria-hidden="true"></i> hoihoi 日本語

## 2 自動ビルドの確認

### title1

### title2

## TeX ディストリビューション †
Linux で TeX 環境を構築するには，2つの方法があります．

1. 使用している Linux ディストリビューションのパッケージ管理システムから TeX Live のパッケージをインストールする．
2. TeX Live のインストーラを使ってインストールする．

前者の場合は，他のパッケージと同様に統一的な管理ができますが，ディストリビューションによっては提供されているパッケージのバージョンが古いことがあります． 後者の場合は，パッケージ管理システムによる管理からは外れてしまいますが，tlmgr を使って最新の状態にアップデートし続けることが可能です．

## TeX Live のインストール †

TeX Live のインストールガイド

- http://www.tug.org/texlive/quickinstall.html
- http://www.tug.org/texlive/doc/texlive-en/texlive-en.html#installation
- http://www.tug.org/texlive/doc/texlive-ja/texlive-ja.pdf#c

に従えばよいですが，このページでもネットワークインストーラを使う場合について簡単に説明します．

まず，ミラーサイトから install-tl-unx.tar.gz をダウンロードします．

### ※ wget を使用する場合

```shell
$ wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
```

### ※ curl を使用する場合

```shell
$ curl -O http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
```

install-tl-unx.tar.gz を展開します．

```shell
$ tar xvf install-tl-unx.tar.gz
```

展開したインストーラのディレクトリに移動します．

```shell
$ cd install-tl*
```

root 権限でインストーラを実行します． オプションでダウンロードするリポジトリを指定できます．

```shell
$ sudo ./install-tl -no-gui -repository http://mirror.ctan.org/systems/texlive/tlnet/

...
Actions:
 <I> start installation to hard disk
 <H> help
 <Q> quit
Enter command: I
```

I を入力してインストールを開始します． サーバーの接続エラーが発生したり，何らかの理由により取得したアーカイブに問題があったりした場合はインストールが途中でストップします． この場合は，以下のコマンドで途中から再開できたりできなかったりします．

```shell
$ sudo ./install-tl -no-gui -profile installation.profile

ABORTED INSTALLATION FOUND: installation.profile
Do you want to continue with the exact same settings as before (y/N): y
```

再開できない場合は接続先を変更するか，または ISO ファイルをミラーサイトからダウンロードしてインストールしてください．

インストールが終了したら /usr/local/bin ディレクトリ配下にシンボリックリンクを追加します．

```shell
$ sudo /usr/local/texlive/????/bin/*/tlmgr path add
```

### アップデート †

アップデートは

```shell
$ sudo tlmgr update --self --all
```

を実行すれば OK です．

ただし，アップデートのタイミングによっては，今まで動いていたものが動かなくなったりすることがあるかもしれません．

- /usr/local/texlive/????/tlpkg/backups

にパッケージのバックアップが保存されています． アップデートによって動作しなくなった場合は

```shell
$ sudo tlmgr restore （パッケージ名） （リビジョン番号）
```

とすることで以前のバージョンに戻すことができます．


