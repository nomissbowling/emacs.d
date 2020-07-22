<h1 style="text-align:center;">Configurations for GNU Emacs</h1>

## 1. はじめに
* [Leaf](https://github.com/conao3/leaf.el) に乗り換えたのを機に大幅に整理したので RTD にまとめました。
* もし参考になるとしたら [init.el](https://github.com/minorugh/emacs.d/blob/master/init.el) と [inits](https://github.com/minorugh/emacs.d/tree/master/inits) 内のファイル群かと思います。
* 設定ファイルは全て `~/Dropbox/emacs.d/` に置いて Git管理しています。
* init.el のシンボリックを `~/.emacs.d` に置くことで複数端末から共有できます。
* 全てのファイルは [GitHub](https://github.com/minorugh/emacs.d) に公開しています。
* 本ドキュメントの構成は、[@takaxp](https://twitter.com/takaxp) さんの [init.el](https://takaxp.github.io/) の記事に倣いました。感謝！

## 2. ディレクトリ構成

Dropboxの負担を減らすためにパッケージ類は各端末の `~/.emacs.d` に配置しました。

ファイル配置のデレクトリ構成は以下のとおりです。
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
基本的には `init.el` を読み込むことで制御しています。 手順は以下のとおり。

1. `init.el` の読み込み
2. `init-config.el` の読み込み
3. `inits/` に配置したファイル群の遅延読み込み （init-loader 使用）

[init-config.el](https://github.com/minorugh/emacs.d/blob/master/init-config.el) には、主に Emacs起動時の画面設定を書いていますが、個人的な設定ファイルなどもここから読み込ませます。

``` emacs-lisp
;; Load user Functions
(add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
(require 'user-test)
(add-hook
 'after-init-hook
 (lambda ()
   (require 'user-dired)
   (require 'user-template)))
```

[user-test.el](https://github.com/minorugh/emacs.d/blob/master/elisp/user-test.el) は、ちょこっとした設定を試すための空ファイルです。こうしておくことで他の設定を汚すこと無くテストできるので便利です。

遅延起動でも問題ないものは `inits/` フォルダーに配置し [init-loader.el](https://github.com/emacs-jp/init-loader) で順次読み込みます。
init-loader の是非は諸説あるようですが、[多くの恩恵](http://emacs.rubikitch.com/init-loader/)は捨て難く私には必須ツールです。

### 3.1 minimal-init.el：最小限のEmacsを起動

[minimal-init.el](https://github.com/minorugh/emacs.d/blob/master/minimal-init.el) は、最小限の emacs を起動させるための設定です。シェルから `resq` と入力することで起動することがでます。

以下を `.zshrc` または `.bashrc` に書き込みます。

```shell
alias resq='emacs -q -l ~/Dropbox/emacs.d/minimal-init.el'
```

ファイルの PATH は、ご自分の環境に応じて修正が必要です。エラー等で Emacsが起動しない場合に使用します。

### 3.2 起動時間の計測
`M-x emacs-init-time` を実行すると Emacsの起動にかかった時間が表示されますが、小数点以下三桁まで表示させたいのでハッキングします。元ネタは [takaxp.github.io](https://takaxp.github.io/init.html#orga09727ae) からです。感謝！

``` emacs-lisp
(with-eval-after-load "time"
  (defun ad:emacs-init-time ()
    "Return a string giving the duration of the Emacs initialization."
    (interactive)
    (let ((str
           (format "%.3f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))))
      (if (called-interactively-p 'interactive)
          (message "%s" str)
        str)))

  (advice-add 'emacs-init-time :override #'ad:emacs-init-time))
```

### 3.3 GCサイズの最適化
通常は以下のように設定している事例が多いです。

``` emacs-lisp
(setq gc-cons-threshold (* 128 1024 1024)) ;; 128MB
```
劇的な効果は期待できませんが、以下のように設定すると 0.06秒ほど起動時間を早くできます。

``` emacs-lisp
;; Speed up startup
(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(setq gc-cons-threshold 100000000)
(add-hook 'emacs-startup-hook
		  (lambda ()
			"Restore defalut values after startup."
			(setq file-name-handler-alist default-file-name-handler-alist)
			(setq gc-cons-threshold 800000)))

```
Emacs起動時に大胆に GCを減らし、Startup後に通常の値に戻します。

`init.el` の先頭に記述しないと効果は少ないです。元ネタは [Vincent Zhang](https://github.com/seagle0128/.emacs.d/blob/master/init.el) からです。感謝！

### 3.4 exec-path-from-shell：PATH設定をシェルから継承する

* [https://github.com/purcell/exec-path-from-shell](https://github.com/purcell/exec-path-from-shell)

`exec-path-from-shell` は シェルに設定した PATH情報を Emacsに継承してくれます。

init.el に直接 PATHを書くことでも対応できますが、私の場合、TexLive や Perlbrew をはじめ shell-command でいろいろ作業させるので必須のツールです。

``` emacs-lisp
;; exec-path-from-shell
(leaf exec-path-from-shell :ensure t
  :when (memq window-system '(mac ns x))
  :hook (emacs-startup-hook . exec-path-from-shell-initialize)
  :config
  (setq exec-path-from-shell-check-startup-files nil))

```

### 3.5 after-init-hook / emacs-startup-hook：遅延読み込み

* [after-init-hook と emacs-startup-hook の違いを読み解く](https://minosjp.hatenablog.com/entry/2019/10/08/232215)

遅延読み込みしても問題ない設定には積極的に活用しています。

個別ごとに設定してもいいのですが、私の場合は `inits/` フォルダー内に設定群を配置してまとめて遅延読み込みしています。

以下の設定例では `after-init-hook` で `init-loarder` が始動します。

``` emacs-lisp
(leaf init-loader :ensure t
  :init
  (setq load-prefer-newer t)
  (setq el-get-dir "~/.emacs.d/elisp")
  (add-to-list 'load-path "~/Dropbox/emacs.d")
  (require 'init-config)
  :config
  (add-hook
   'after-init-hook
   (lambda ()
	 (custom-set-variables '(init-loader-show-log-after-init 'error-only))
	 (init-loader-load "~/Dropbox/emacs.d/inits")))
  (setq custom-file (locate-user-emacs-file "custom.el")))
```

### 3.5 初期画面設定
[init-config.el](https://github.com/minorugh/emacs.d/blob/master/init-config.el) は、Emacs起動時の初期画面表示のための設定ファイル ですので、遅延読み込みより前に読み込む必要があります。（前項の設定を参照）

起動時にギクシャクする画面は見たくないので、まず冒頭に以下を設定しています。

``` emacs-lisp
;; Quiet Startup
(set-frame-parameter nil 'fullscreen 'maximized)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
```

初期画面には、`Dashboard` を表示させています。

![Dashboard by iceberg-theme](https://live.staticflickr.com/65535/50133698492_33ff20267b_b.jpg)

愛着あるこのバッファーですが、うっかり Killすると消えてしまうので再生できるように設定しました。作業が一段落したらここへ戻ります。

下記設定例では `<Home>` キーを押すことで、直前に作業していたバッファー画面とDashboard画面とをトグルで表示させています。(winner-mode 使用)

``` emacs-lisp
;; Custom dashboard
(leaf dashboard :ensure t
  :bind (("<home>" . open-dashboard)
		 (:dashboard-mode-map
		  ("<home>" . quit-dashboard)))
  :hook (after-init-hook . dashboard-setup-startup-hook)
  :config
  ;;  ...
  ;;  （中略）
  ;;  ...
  (defvar dashboard-recover-layout-p nil
    "Wether recovers the layout.")

  (defun restore-previous-session ()
    "Restore the previous session."
    (interactive)
    (when (bound-and-true-p persp-mode)
      (restore-session persp-auto-save-fname)))

  (defun restore-session (fname)
    "Restore the specified session."
    (interactive (list (read-file-name "Load perspectives from a file: "
									   persp-save-dir)))
    (when (bound-and-true-p persp-mode)
      (message "Restoring session...")
      (quit-window t)
      (condition-case-unless-debug err
		  (persp-load-state-from-file fname)
		(error "Error: Unable to restore session -- %s" err))
      (message "Done")))

  (defun open-dashboard ()
    "Open the *dashboard* buffer and jump to the first widget."
    (interactive)
    (delete-other-windows)
    (setq default-directory "~/")
    ;; Refresh dashboard buffer
    (if (get-buffer dashboard-buffer-name)
		(kill-buffer dashboard-buffer-name))
    (dashboard-insert-startupify-lists)
    (switch-to-buffer dashboard-buffer-name)
    ;; Jump to the first section
    (goto-char (point-min))
    (dashboard-goto-recent-files))

  (defun quit-dashboard ()
    "Quit dashboard window."
    (interactive)
    (quit-window t)
    (when (and dashboard-recover-layout-p
			   (bound-and-true-p winner-mode))
      (winner-undo)
      (setq dashboard-recover-layout-p nil)))

  (defun dashboard-goto-recent-files ()
    "Go to recent files."
    (interactive)
    (funcall (local-key-binding "r"))))

```



## 4. コア設定
Emacs を操作して文書編集する上で必要な設定。

### 4.1 言語 / 文字コード

シンプルにこれだけです。

``` emacs-lisp
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
```
### 4.2 日本語入力

Debian10 にインストールした Emacs上で [emacs-mozc](https://packages.debian.org/ja/jessie/emacs-mozc) を使っています。

Emacsをソースからビルドするときに `--without-xim` しなかったので、インラインXIMでも日本語入力ができてしまいます。特に使い分けする必要もなく紛らわしいので `.Xresources` で XIM無効化の設定をしました。

```bash
! ~/.Xresources
! Emacs XIMを無効化
Emacs*useXIM: false

```
Mozcと連動してカーソルの色をカスタマイズするために [mozc-cursor-color.el](https://github.com/iRi-E/mozc-el-extensions/blob/master/mozc-cursor-color.el) を、また日本語変換候補の表示を posframe表示させるのに [mozc-cand-posframe.el](https://github.com/akirak/mozc-posframe) を使います。

``` emacs-lisp
(leaf mozc :ensure t
  :bind* ("<hiragana-katakana>" . toggle-input-method)
  :config
  (setq default-input-method "japanese-mozc"
		mozc-helper-program-name "mozc_emacs_helper"
		mozc-leim-title "♡かな")
  :init
  (leaf mozc-cursor-color
    :el-get iRi-E/mozc-el-extensions
    :require t
    :config
    (setq mozc-cursor-color-alist
		  '((direct . "#BD93F9")
			(read-only . "#84A0C6")
			(hiragana . "#CC3333"))))
  (leaf mozc-cand-posframe :ensure t
    :require t
    :config
    (setq mozc-candidate-style 'posframe)))

```
**📝 今後の課題**
>Windows10 では `Google日本語入力` を使います。WSLも含めて複数環境で Emacsを動かしています。これら全ての環境で Mozcユーザー辞書を共有できるようにしたいと思考中です。

## 5. カーソル移動
カーソルの移動は、原則デフォルトで使っています。

```eval_rst
+--------------------------+-----------+
| 行移動                   | C-n / C-p |
+--------------------------+-----------+
| ページ移動（スクロール） | C-v / M-v |
+--------------------------+-----------+
| ウインドウ移動           | C-q       |
+--------------------------+-----------+
| バッファー切り替え       | M-] / M-[ |
+--------------------------+-----------+
| バッファー先頭・末尾     | C-a / C-e |
+--------------------------+-----------+
| 編集点の移動             | C-x C-x   |
+--------------------------+-----------+
| タグジャンプ             | C-, / C-. |
+--------------------------+-----------+
```
※ キーバインドを覚えるのが苦手なので便利関数を多用しています。

### 5.1 ウインドウの移動

私の場合、二分割以上の作業はしないので `C-q` だけで便利に使えるこの関数は宝物です。

``` emacs-lisp
(defun other-window-or-split ()
  "If there is one window, open split window.
If there are two or more windows, it will go to another window."
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))
(bind-key "C-q" 'other-window-or-split)
```

### 5.2 バッファー切り替え

[iflipb.el](https://github.com/jrosdahl/iflipb) を使うと tabbar感覚の操作感になります。

- [タブを使わない究極のバーファー移動](https://qiita.com/minoruGH/items/aa96e92c1434f87940d6)


``` emacs-lisp
(leaf iflipb
  :ensure t
  :bind(("M-]" . iflipb-next-buffer)
		("M-[" . iflipb-previous-buffer))
  :config
  (setq iflipb-wrap-around t)
  (setq iflipb-ignore-buffers (list "^[*]" "^magit" "dir" ".org")))

```
[tempbf.el](https://github.com/jrosdahl/iflipb) を使うと不要なbufferを自動的にKillしてくれるので更に便利になります。

- [不要なバッファーを自動的にkillする](https://qiita.com/minoruGH/items/d7f6f1bd76c046a85927)

``` emacs-lisp
;; automatically kill unnecessary buffers
(use-package tempbuf)
(add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)
(add-hook 'magit-mode-hook 'turn-on-tempbuf-mode)
```

### 5.3 バッファー先頭・末尾

[sequential-command.el](https://rubikitch.hatenadiary.org/entry/20090219/sequential_command) は地味なながら一度使うと便利すぎて止められません。Melpからインストールできるのですが、[@HKey](https://twitter.com/hke7) さんの改良版を el-getで入れてます。感謝！

- [sequential-command をもう少し賢く](https://hke7.wordpress.com/2012/04/08/sequential-command-%E3%82%92%E3%82%82%E3%81%86%E5%B0%91%E3%81%97%E8%B3%A2%E3%81%8F/)

``` emacs-lisp
(leaf sequential-command-config
  :hook (emacs-startup-hook . sequential-command-setup-keys)
  :bind (("C-a" . seq-home)
		 ("C-e" . seq-end))
  :init
  (leaf sequential-command
	:el-get HKey/sequential-command))
```

### 5.4 編集点の移動
ポイントを変遷するような高度な作業はしないので、"一手前に戻る汎用的な方法" だけ採用しています。元ネタは [@masasam](https://twitter.com/SolistWork) さんのブログ記事
[Mark Ringを活用する](https://solist.work/blog/posts/mark-ring/) からです。感謝！

``` emacs-lisp
(defun my:exchange-point-and-mark ()
  "No mark active `exchange-point-and-mark'."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark))
(bind-key "C-x C-x" 'my:exchange-point-and-mark)
```

### 5.5 タグジャンプ
この機能もごく稀にしか使いません。
一等地にあるデフォルトの `M-.` は、もっとも頻繁に使う [hydra-menu](https://github.com/minorugh/emacs.d/blob/master/inits/10_hydra-menu.el) （後述）に渡したいので変更しています。

``` emacs-lisp
;; xref-find-* key
(bind-key "C-," 'xref-find-references)
(bind-key "C-." 'xref-find-definitions)

```


## 6. 編集サポート
### 6.1 矩形編集

### [expand-region]

``` emacs-lisp
(leaf expand-region :ensure t
  :bind ("C-@" . er/expand-region))
```

### 6.2 [swiper]リージョンを使って検索

### 6.3 markdown-mode

### [hydra-quick-menu]

### [hydra-work-menu]

### [hydra-pinky]

### [howm-mode / org-mode]メモ環境

### [darkroom-mode]執筆モード

### [yatex]YaTexでTex編集

### [yasnippet]

### [google-translate]

### [web-search]


## 7. 表示サポート

### [display-line-numbers]行番号の表示

### [doom-modeline]モードラインをカスタマイズ

### [emacs-lock-mode]scratch を消さない/自動保存

### [oaren]対応する括弧をハイライト

### [migemo]ローマ字入力で日本語を検索

### [dif-hl]編集差分をフレーム端で視覚化

### [which-key]キーバインドの選択肢をポップアップ

### [all-the-icons]フォントでアイコン表示

### [rainbow-delimiters]対応する括弧に色をつける

### [beacon]

### [imenu-list]サイドバー的にファイルの目次要素を表示

### [dimmer]現在のバッファー以外の輝度を落とす

## 8. 履歴 / ファイル管理
### 6.3 [auto-save-buffer]ファイルの自動保存

### 6.3 空のファイルを自動的に削除

### [undo-tree]

### [direx]

### [counsel-ag]

### [git-timemachine]

## 9. 開発サポート

### [company]

### [magit]

### [counsel-tramp]

### [quickrun]

### [flymake]

### [browse-at-remote]

### [ps-print]

### [ps2pdf]

### [md2pdf / md2docx]

### [gist]


### [hydra-compile]

### [hydra-misc]

## 10. Org Mode / Howm Mode


## 11. Hugo

## 12. フォント / 配色関係

### フォント設定
### 行間を制御する
### [rainbow-mode]配色のリアルタイム確認
### [volatile-highlight]コピペした領域を強調


### カーソル行に色をつける

## 13. ユーティリティー関数

### Terminal を Emacsから呼び出す

### Thunar を Emacsから呼び出す

### mozc-Tool を Emacsから呼び出す

### [eshell]

### [sudo-edit]

### [restart-emacs]


## 14. おわりに

以上が私の init.el とその説明です。

まだまだ未熟な点が多々ありますが学びながら育てていきたいと願っています。

