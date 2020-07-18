<h1 style="text-align:center;">Configurations for GNU Emacs</h1>

## 1 はじめに
* [use-package](https://github.com/jwiegley/use-package) から [Leaf](https://github.com/conao3/leaf.el) に乗り換えたのを機に大幅に整理したので RTD にまとめました。
* もし参考になるとしたら [init.el](https://github.com/minorugh/emacs.d/blob/master/init.el) と [inits](https://github.com/minorugh/emacs.d/tree/master/inits) 内のファイル群かと思います。
* 複数端末で共有するため、設定ファイルは全て `~/Dropbox/emacs.d/` に置いています。
* init.el のシンボリックを `~/.emacs.d` に置き init-loader で inits のファイル群を読込みます。
* 全てのファイルは [GitHub](https://github.com/minorugh/emacs.d) に公開しています。 
* 本ドキュメントの構成は、[Takaaki Ishikawa](https://twitter.com/takaxp) さんの [init.el](https://takaxp.github.io/) の記事に倣いました。感謝！ 

## 2 ディレクトリ構成
以下のとおりです。
```
~/.emacs.d
├── .gitignore
├── ddskk/
│   ├── dic/
│   ├── emacs-id
│   ├── init
│   ├── jisyo
│   ├── record
│   └── study
├── elisp/
│   ├── auto-install/
│   └── work/
├── elpa/
├── init.el
├── inits/
│   ├── 000_init.el
│   ├── 00_command-keymap.el
│   ├── 00_misc.el
│   ├── ...
│   ├── 99_overriding-minor-mode-keymap.el
│   └── lin-conf.el
└── snippets/



~/Dropbox/emacs.d
├── .gitignore
├── ddskk/
│   ├── dic/
│   ├── emacs-id
│   ├── init
│   ├── jisyo
│   ├── record
│   └── study
├── elisp/
│   ├── auto-install/
│   └── work/
├── elpa/
├── init.el
├── inits/
│   ├── 000_init.el
│   ├── 00_command-keymap.el
│   ├── 00_misc.el
│   ├── ...
│   ├── 99_overriding-minor-mode-keymap.el
│   └── lin-conf.el
└── snippets/



```

## 3 起動設定

## 4 コア設定

## 5 カーソル移動

## 6 編集サポート

## 7 表示サポート

## 8 履歴/ファイル管理

## 9 開発サポート

## 10 Org Mode/Howm Mode

## 11 フォント/配色関係

## 12 ユーティリティー関数

## 13 おわりに
