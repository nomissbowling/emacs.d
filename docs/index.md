<h1 style="text-align:center;">Configurations for GNU Emacs</h1>

## 1. はじめに
* [use-package](https://github.com/jwiegley/use-package) から [Leaf](https://github.com/conao3/leaf.el) に乗り換えたのを機に大幅に整理したので RTD にまとめました。
* もし参考になるとしたら [init.el](https://github.com/minorugh/emacs.d/blob/master/init.el) と [inits](https://github.com/minorugh/emacs.d/tree/master/inits) 内のファイル群かと思います。
* 複数端末で共有するため、設定ファイルは全て `~/Dropbox/emacs.d/` に置いています。
* init.el のシンボリックを `~/.emacs.d` に置き init-loader で inits のファイル群を読込みます。
* 全てのファイルは [GitHub](https://github.com/minorugh/emacs.d) に公開しています。 
* 本ドキュメントの構成は、[Takaaki Ishikawa](https://twitter.com/takaxp) さんの [init.el](https://takaxp.github.io/) の記事に倣いました。感謝！ 

## 2. ディレクトリ構成

パッケージ類は、Git管理する必要もなく、Dropboxの負担を減らすために、それぞれの端末の `~/.emacs.d` に配置しました。構成は以下のとおりです。
```
~/.emacs.d
├── el-get/
├── elisp/
│   ├── emacs-livedown/
│   ├── key-chord/
│   ├── mozc-el-extensions/
│   └── tempbuf/
├── elpa/
└── init.el （シンボリック）


~/Dropbox/emacs.d
├── docs/
├── elisp/
│   ├── iceberg-theme/
│   ├── info/
│   ├── user-test.el
│   ├── user-dired.el
│   └── user-template.el
├── inits/
│   ├── 01_base.el
│   ├── 02_git.el
│   ├── ...
│   ├── 99_user-dired.el
│   └── 99_user-template.el
├── snippets/
├── .gitignore
├── init.el
├── init-config.el
└── minimaru-init.el

```

## 3. 起動設定
基本的には `init.el` を読み込むことで制御しています。 読み込み手順は以下のとおり。

1. `init.el` の読み込み 
2. `init-config.el` の読み込み
3. `inits/` に配置したファイル群の読み込み （init-loader 使用）

`init-config.el` には、遅延起動させたくないものを設定して先読み込みさせます。

`user-dired.el` , `user-template.el` などの別設定もここから読み込ませます。`user-test.el` は、ちょこっと思いついた設定を書いて動作確認するための空ファイルです。他の設定ファイルを汚すことなくテストできるので便利です。

遅延起動できるものは `inits` フォルダーに配置して順次読み込みます。`init-loader` を使うことの是非は、諸説あるようですが、[多くの恩恵](http://emacs.rubikitch.com/init-loader/) もあるので私には必須ツールです。

### 3.1 minimal-init.el

最小限の emacs を起動させるための設定です。シェルから `eq` を入力することで起動することがでます。
以下を `.zshrc` または `.bashrc` に書き込みます。

``` shell
alias eq='emacs -q -l ~/Dropbox/emacs.d/minimal-init.el'
```

ファイルの PATH は、ご自分の環境に応じて修正が必要です。Package のテストや emacs が起動しない場合に使用します。

## 4. コア設定

## 5. カーソル移動

## 6. 編集サポート

## 7. 表示サポート

## 8. 履歴 / ファイル管理

## 9. 開発サポート

## 10. Org Mode / Howm Mode

## 11. フォント / 配色関係

## 12. ユーティリティー関数

## 13. おわりに


