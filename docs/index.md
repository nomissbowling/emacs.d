<h1 style="text-align:center;">Configurations for GNU Emacs</h1>

## 1. はじめに
* [Leaf](https://github.com/conao3/leaf.el) に乗り換えたのを機に大幅に整理したので RTD にまとめました。
* 設定ファイルは全て `~/Dropbox/emacs.d/` に置いて Git管理しています。
* [init.el](https://github.com/minorugh/emacs.d/blob/master/init.el) のシンボリックを `~/.emacs.d` に置くことで複数端末から共有しています。
* 設定ファイル本体は、[GitHub](https://github.com/minorugh/emacs.d) に公開しています。
* 設定内容も本ドキュメントも、[@takaxp](https://twitter.com/takaxp) さんの [init.el](https://takaxp.github.io/) の記事から多くを吸収した模倣版です。
本家と重複する説明は省き、執筆用途にカスタマイズしたポイントのみ補足説明します。


八十路も近い老骨ながら、[@masasam](https://twitter.com/SolistWork) さん、[@takaxp](https://twitter.com/takaxp) さんのご指導を得て、盲目的なパッチワークから多少なりとも自力でカスタマイズできるまでスキルを上げることができました。感謝！


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

```emacs-lisp
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

### 3.2 GCサイズの最適化
通常は以下のように設定している事例が多いです。

```emacs-lisp
(setq gc-cons-threshold (* 128 1024 1024)) ;; 128MB
```
劇的な効果は期待できませんが、以下のように設定すると 0.06秒ほど起動時間を早くできます。

```emacs-lisp
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

### 3.3 after-init-hook / emacs-startup-hook：遅延読み込み

* [after-init-hook と emacs-startup-hook の違いを読み解く](https://minosjp.hatenablog.com/entry/2019/10/08/232215)

遅延読み込みしても問題ない設定には積極的に活用しています。

個別ごとに設定してもいいのですが、私の場合は `inits/` フォルダー内に設定群を配置してまとめて遅延読み込みしています。

以下の設定例では `after-init-hook` で `init-loarder` が始動します。

```emacs-lisp
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

### 3.4 初期画面設定
[init-config.el](https://github.com/minorugh/emacs.d/blob/master/init-config.el) は、Emacs起動時の初期画面表示のための設定ファイル ですので、遅延読み込みより前に読み込む必要があります。（前項の設定を参照）

起動時にギクシャクする画面は見たくないので、まず冒頭に以下を設定しています。

```emacs-lisp
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

```emacs-lisp
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
カーソルの移動は、原則デフォルトで使っていますが、以下の挙動だけ変更しています。

```eval_rst
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

### 5.1 ウインドウの移動

私の場合、二分割以上の作業はしないので `C-q` だけで便利に使えるこの関数は宝物です。

```emacs-lisp
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

- [iflipb.el](https://github.com/jrosdahl/iflipb) を使うと tabbar感覚の操作感になります。
- [タブを使わない究極のバーファー移動](https://qiita.com/minoruGH/items/aa96e92c1434f87940d6)


```emacs-lisp
(leaf iflipb
  :ensure t
  :bind(("M-]" . iflipb-next-buffer)
		("M-[" . iflipb-previous-buffer))
  :config
  (setq iflipb-wrap-around t)
  (setq iflipb-ignore-buffers (list "^[*]" "^magit" "dir")))

```
- [tempbf.el](https://github.com/jrosdahl/iflipb) を使うと不要なbufferを自動的にKillしてくれるので更に便利になります。
- [不要なバッファーを自動的にkillする](https://qiita.com/minoruGH/items/d7f6f1bd76c046a85927)

```emacs-lisp
;; automatically kill unnecessary buffers
(use-package tempbuf)
(add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)
(add-hook 'magit-mode-hook 'turn-on-tempbuf-mode)
```

### 5.3 バッファー先頭・末尾

[sequential-command.el](https://rubikitch.hatenadiary.org/entry/20090219/sequential_command) は地味なながら一度使うと便利すぎて止められません。Melpからインストールできるのですが、[@HKey](https://twitter.com/hke7) さんの改良版を el-getで入れてます。感謝！

- [sequential-command をもう少し賢く](https://hke7.wordpress.com/2012/04/08/sequential-command-%E3%82%92%E3%82%82%E3%81%86%E5%B0%91%E3%81%97%E8%B3%A2%E3%81%8F/)

```emacs-lisp
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

```emacs-lisp
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

```emacs-lisp
;; xref-find-* key
(bind-key "C-," 'xref-find-references)
(bind-key "C-." 'xref-find-definitions)

```


## 6. 編集サポート

### 6.1 [expand-region]
er/expand-regionを実行する度にリージョンの範囲が広がっていくというものです。

[@takaxp](https://twitter.com/m2ym) さんの [init.el](https://takaxp.github.io/) では [select.el とペアで使う方法](https://takaxp.github.io/init.html#org3901456e) が紹介されています。

```emacs-lisp
(leaf expand-region :ensure t
  :bind (("C-@" . er/expand-region)
		 ("C-M-@" . er/contract-region))
```

### 6.2 [selected]リージョン選択時のアクションを制御

```emacs-lisp

```

### 6.3 [hydra-quick-menu]

```emacs-lisp

```

### 6.4 [hydra-pinky]
```emacs-lisp

```


### 6.5 [darkroom-mode]執筆モード
[darkroom.el](https://github.com/joaotavora/darkroom)  は、画面の余計な項目を最小限にして、文章の執筆に集中できるようにするパッケージです。

基本機能は、文字サイズが大きくなり、モード行が消えるだけですが、設定例では、行番号表示、diff-hl、flymake も消しています。併せて文字間隔も少し大きくして読みやすくしました。[F12] キーで IN/OUT をトグルしています。

```emacs-lisp
(leaf darkroom :ensure t
  :bind ("<f12>" . my:darkroom-mode-in)
  :config
  (defun my:darkroom-mode-in ()
    "Darkroom mode in."
    (interactive)
    (display-line-numbers-mode 0)
    (diff-hl-mode 0)
    (flymake-mode 0)
    (setq line-spacing 0.4)
    (darkroom-mode 1)
    (bind-key "<f12>" 'my:darkroom-mode-out darkroom-mode-map))
  (defun my:darkroom-mode-out ()
    "Darkroom mode out."
    (interactive)
    (darkroom-mode 0)
    (flymake-mode 1)
    (diff-hl-mode 1)
    (setq line-spacing 0.1)
    (display-line-numbers-mode 1)))
```

### 6.6 [yatex]YaTexでTex編集

```emacs-lisp
(leaf yatex :ensure t
  :mode ("\\.tex\\'" . yatex-mode)
  :config
  (setq tex-command "platex"
		dviprint-command-format "dvpd.sh %s"
		YaTeX-kanji-code nil
		YaTeX-latex-message-code 'utf-8
		YaTeX-default-pop-window-height 15)
  :init
  (add-hook
   'yatex-mode-hook
   '(lambda ()
      (leaf yatexprc
		:bind (("M-c" . YaTeX-typeset-buffer)	;; Type set buffer
			   ("M-l" . YaTeX-lpr))))))	;; Open pdf veiwer


;; Dviprint-command-format
;; -----------------------------------------------------------------------
;; dvpd.sh for Linux
;; Create dvpd.sh and execute 'chmod +x', and place it in `/usr/local/bin'
;;
;; for Linux
;; | #!/bin/bash
;; | name=$1
;; | dvipdfmx $1 && evince ${name%.*}.pdf
;; |# Delete unnecessary files
;; |rm *.au* *.dv* *.lo*
;;
;; for WSL
;; | #!/bin/bash
;; | name=$1
;; | dvipdfmx $1 && wslstart ${name%.*}.pdf
;; |# Delete unnecessary files
;; |rm *.au* *.dv* *.lo*
;;
;; ------------------------------------------------------------------------

```

## 7. 表示サポート

### 7.1 [emacs-lock-mode]scratch を消さない

```emacs-lisp
;; Set buffer that can not be killed
(with-current-buffer "*scratch*"
  (emacs-lock-mode 'kill))
(with-current-buffer "*Messages*"
  (emacs-lock-mode 'kill))
```

### 7.2 [migemo]ローマ字入力で日本語を検索

```emacs-lisp
(defun my:ivy-migemo-re-builder (str)
  "Own ivy-migemo-re-build for swiper."
  (let* ((sep " \\|\\^\\|\\.\\|\\*")
		 (splitted (--map (s-join "" it)
						  (--partition-by (s-matches-p " \\|\\^\\|\\.\\|\\*" it)
										  (s-split "" str t)))))
    (s-join "" (--map (cond ((s-equals? it " ") ".*?")
							((s-matches? sep it) it)
							(t (migemo-get-pattern it)))
					  splitted))))

(setq ivy-re-builders-alist '((t . ivy--regex-plus)
							  (counsel-web . my:ivy-migemo-re-builder)
							  (counsel-rg . my:ivy-migemo-re-builder)
							  (swiper . my:ivy-migemo-re-builder)))
```


### 7.3 [beacon]

```emacs-lisp
(leaf beacon :ensure t
  :config
  (beacon-mode)
  (setq beacon-color "yellow"))
```


## 8. 履歴 / ファイル管理

### 8.1 [auto-save-buffer-enhanced]ファイルの自動保存

```emacs-lisp
(leaf auto-save-buffers-enhanced :ensure t
  :config
  (setq auto-save-buffers-enhanced-quiet-save-p t)
  ;; auto save *scratch* to ~/.emacs.d/scratch
  (setq auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t
		auto-save-buffers-enhanced-file-related-with-scratch-buffer
		(locate-user-emacs-file "scratch"))
  ;; Exclusion of the auto-save-buffers
  (setq auto-save-buffers-enhanced-exclude-regexps '("^/ssh:" "^/scp:" "/sudo:"))
  (auto-save-buffers-enhanced t))
```

### 8.2 空のファイルを自動的に削除

```emacs-lisp
(defun my:delete-file-if-no-contents ()
  "Automatic deletion for empty files (Valid in all modes)."
  (when (and (buffer-file-name (current-buffer))
			 (= (point-min) (point-max)))
    (delete-file
     (buffer-file-name (current-buffer)))))
(if (not (memq 'my:delete-file-if-no-contents after-save-hook))
    (setq after-save-hook
		  (cons 'my:delete-file-if-no-contents after-save-hook)))

```

### 8.3 [undo-tree]

```emacs-lisp
(leaf undo-tree :ensure t
  :bind* (("C-_" . undo-tree-undo)
		  ("C-\\" . undo-tree-undo)
		  ("C-/" . undo-tree-redo)
		  ("C-x u" . undo-tree-visualize))
  :hook ((prog-mode-hook . undo-tree-mode)
		 (text-mode-hook . undo-tree-mode))
  :custom
  ((undo-tree-visualizer-timestamps . t)
   (undo-tree-visualizer-diff . t)
   (undo-tree-enable-undo-in-region . nil)
   (undo-tree-auto-save-history . nil)
   (undo-tree-history-directory-alist
    . `(("." . ,(concat user-emacs-directory "undo-tree-hist/")))))
  :config
  ;; FIXME: `undo-tree-visualizer-diff' is a local variable in *undo-tree* buffer.
  (defun undo-tree-visualizer-show-diff (&optional node)
    ;; show visualizer diff display
    (setq-local undo-tree-visualizer-diff t)
    (let ((buff (with-current-buffer undo-tree-visualizer-parent-buffer
				  (undo-tree-diff node)))
		  (display-buffer-mark-dedicated 'soft)
		  win)
      (setq win (split-window))
      (set-window-buffer win buff)
      (shrink-window-if-larger-than-buffer win)))

  (defun undo-tree-visualizer-hide-diff ()
    ;; hide visualizer diff display
    (setq-local undo-tree-visualizer-diff nil)
    (let ((win (get-buffer-window undo-tree-diff-buffer-name)))
      (when win (with-selected-window win (kill-buffer-and-window))))))
```

### 8.4 [direx]

```emacs-lisp
(defun direx:jump-to-project-directory ()
  "If in project, launch direx-project otherwise start direx."
  (interactive)
  (let ((result (ignore-errors
				  (direx-project:jump-to-project-root-other-window)
				  t)))
    (unless result
      (direx:jump-to-directory-other-window))))

(defun direx:open-file ()
  "In direx, open the file in associated application."
  (interactive)
  (let* ((item (direx:item-at-point!))
		 (file (direx:item-tree item))
		 (file-full-name (direx:file-full-name file)))
    (unless (getenv "WSLENV")
      (call-process "xdg-open" nil 0 nil file-full-name))
    ;; use wsl-utils:https://github.com/smzht/wsl-utils
    (when (getenv "WSLENV")
      (call-process "wslstart" nil 0 nil file-full-name))))


(leaf direx :ensure t
  :after popwin
  :bind (("<f10>" . direx:jump-to-project-directory)
		 ("C-x C-j" . direx:jump-to-project-directory)
		 (:direx:direx-mode-map
		  ("o" . direx:open-file)
		  ("SPC" . direx:find-item-other-window)
		  ("<f10>" . quit-window)))
  :config
  (setq direx:leaf-icon "  " direx:open-icon "📂" direx:closed-icon "📁")
  (push '(direx:direx-mode :position left :width 25 :dedicated t) popwin:special-display-config))
```


## 9. 開発サポート

### 9.1 [magit]

magitの画面は、デフォルトでは、`other-window` に表示されますが、フルフレームで表示されるようにカスタマイズしています。

```emacs-lisp
(setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
```

### 9.2 [ps-print]

```emacs-lisp
(leaf ps-print :ensure nil
  :config
  (setq ps-paper-type 'a4
		ps-font-size 9
		ps-printer-name nil
		ps-print-header nil
		ps-show-n-of-n t
		ps-line-number t
		ps-print-footer nil))
```

### 9.3 [ps2pdf]

```emacs-lisp
(setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | ps2pdf - %s")
;; (setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | lpr")
(defun my:pdfout-buffer ()
  "PDF out from buffer."
  (interactive)
  (my:pdfout-region (point-min) (point-max)))
(defun my:pdfout-region (begin end)
  "PDF out from BEGIN to END of region."
  (interactive "r")
  ;; (shell-command-on-region begin end my:pdfout-command-format)))
  (shell-command-on-region begin end (format my:pdfout-command-format
											 (concat (read-from-minibuffer "File name:") ".pdf"))))
```

### 9.4 [md2pdf / md2docx]

```emacs-lisp
(defun md2pdf ()
  "Generate pdf from currently open markdown. Use wkhtmltopdf without latex"
  (interactive)
  (let ((filename (buffer-file-name (current-buffer))))
    (shell-command-to-string
     (concat "pandoc "
			 filename
			 " -f markdown -t html5 -o "
			 (file-name-sans-extension filename)
			 ".pdf"))
    (shell-command-to-string
     (concat "evince "
			 (file-name-sans-extension filename)
			 ".pdf"))))
```


```emacs-lisp
(defun md2pdf ()
  "Generate pdf from currently open markdown. Use wkhtmltopdf without latex"
  (interactive)
  (let ((filename (buffer-file-name (current-buffer))))
    (shell-command-to-string
     (concat "pandoc "
			 filename
			 " -f markdown -t html5 -o "
			 (file-name-sans-extension filename)
			 ".pdf"))
    (shell-command-to-string
     (concat "evince "
			 (file-name-sans-extension filename)
			 ".pdf"))))
```

```emacs-lisp
(defun md2docx ()
  "Generate docx from currently open markdown."
  (interactive)
  (let ((filename (buffer-file-name (current-buffer))))
	(shell-command-to-string
	 (concat "pandoc "
			 filename
			 " -t docx -o "
			 (file-name-sans-extension filename)
			 ;; ".docx -V mainfont=IPAPGothic -V fontsize=16pt --toc --highlight-style=zenburn"))
			 ".docx -V mainfont=IPAPGothic -V fontsize=16pt --highlight-style=zenburn"))
	(shell-command-to-string
	 (concat "xdg-open "
			 (file-name-sans-extension filename)
			 ".docx"))))
```

### 9.5 [hydra-compile]

``` emacs-lisp
(defun close-compile-window-if-successful (buffer string)
  "Close a compilation window if succeeded without warnings."
  (when (and
		 (string-match "compilation" (buffer-name buffer))
		 (string-match "finished" string)
		 (not
		  (with-current-buffer buffer
			(search-forward "warning" nil t))))
    (run-with-timer 1 nil
					(lambda ()
					  (delete-other-windows)))))
(add-hook 'compilation-finish-functions 'close-compile-window-if-successful)


;; Turn off 'Suspicious line XXX of Makefile.' makefile warning
(add-hook 'makefile-mode-hook
		  (lambda ()
			(fset 'makefile-warn-suspicious-lines 'ignore)))


(leaf *user-make-function
  :hydra
  (hydra-compile
   (:color red :hint nil)
   "
   🗿 Compile: make:_k_  _u_pftp  _m_ove  _b_klog  _g_it  _c_lean  _e_rror 🐾 "
   ("k" my:make-k)
   ("u" my:make-upftp)
   ("m" my:make-move)
   ("b" my:make-bklog)
   ("g" my:make-git)
   ("c" my:make-clean)
   ("e" next-error)
   ("<muhenkan>" nil))
  :config
  (defun my:make-k ()
    "Make command default."
    (interactive)
    (compile "make -k"))
  (defun my:make-upftp ()
    "Make command for upftp."
    (interactive)
    (compile "make up"))
  (defun my:make-move ()
    "Make command for move."
    (interactive)
    (compile "make mv"))
  (defun my:make-bklog ()
    "Make command for bklog."
    (interactive)
    (compile "make bk"))
  (defun my:make-git ()
    "Make command for git."
    (interactive)
    (compile "make git"))
  (defun my:make-clean ()
    "Make command for clean."
    (interactive)
    (compile "make clean")))

```

```emacs-lisp
(leaf *hydra-browse
  :hydra
  (hydra-browse
   (:hint nil :exit t)
   "
  💰 Shop^        ^💭 SNS^        ^🔃 Repos^       ^🏠 GH^        ^🙌 Favorite^    ^📝 Others^    ^💣 Github^^      Google
  ^^^^^^^^^^----------------------------------------------------------------------------------------------------------------
  _a_: Amazon      _t_: Twitter    _g_: github      _h_: HOME      _j_: Jorudan     _c_: Chrome    _1_: masasam     _5_: Keep
  _r_: Rakuten     _u_: Youtube    _0_: gist        _b_: Hatena    _n_: News        _p_: Pocket    _2_: abo-abo     _6_: Map
  _y_: Yodobashi   _f_: Flickr     _d_: Dropbox     _e_: Essay     _w_: Weather     _q_: Qiita     _3_: blue        _7_: Drive
  _k_: Kakaku      _l_: Tumblr     _x_: Xserver     _:_: Blog      _s_: SanyoBas    _,_: Slack     _4_: seagle      _8_: Photo"
   ("a" (browse-url "https://www.amazon.co.jp/"))
   ("r" (browse-url "https://www.rakuten.co.jp/"))
   ("y" (browse-url "https://www.yodobashi.com/"))
   ("k" (browse-url "http://kakaku.com/"))
   ("u" (browse-url "https://www.youtube.com/channel/UCnwoipb9aTyORVKHeTw159A/videos"))
   ("f" (browse-url "https://www.flickr.com/photos/minorugh/"))
   ("g" (browse-url "https://github.com/minorugh/emacs.d"))
   ("0" (browse-url "https://gist.github.com/minorugh"))
   ("1" (browse-url "https://github.com/masasam/dotfiles/tree/master/.emacs\.d"))
   ("2" (browse-url "https://github.com/abo-abo/hydra/wiki"))
   ("3" (browse-url "https://github.com/blue0513?tab=repositories"))
   ("4" (browse-url "https://github.com/seagle0128/.emacs\.d/tree/master/lisp"))
   ("5" (browse-url "https://keep.google.com/u/0/"))
   ("6" (browse-url "https://www.google.co.jp/maps"))
   ("7" (browse-url "https://drive.google.com/drive/u/0/my-drive"))
   (":" (browse-url "http://blog.wegh.net/"))
   ("e" (browse-url "http://essay.wegh.net/"))
   ("b" (browse-url "https://minoru.hatenablog.com/"))
   ("s" (browse-url "http://www.sanyo-bus.co.jp/pdf/20191028tarusan_schedule.pdf"))
   ("j" (browse-url "https://www.jorudan.co.jp/"))
   ("n" (browse-url "https://news.yahoo.co.jp/"))
   ("x" (browse-url "https://www.xserver.ne.jp/login_server.php"))
   ("d" (browse-url "https://www.dropbox.com/home"))
   ("q" (browse-url "https://qiita.com/tags/emacs"))
   ("8" (browse-url "https://photos.google.com/?pageId=none"))
   ("c" (browse-url "https://google.com"))
   ("l" (browse-url "https://minorugh.tumblr.com"))
   ("w" browse-weather)
   ("h" browse-homepage)
   ("p" browse-pocket)
   ("t" browse-tweetdeck)
   ("," browse-slack)
   ("<muhenkan>" nil)
   ("." nil)))


```
## 10. Org Mode / Howm Mode

```emacs-lisp

```

## 11. Hugo

```emacs-lisp

```

## 12. フォント / 配色関係

### 12.1 フォント設定

```emacs-lisp
(add-to-list 'default-frame-alist '(font . "Cica-18"))
;; for sub-machine
(when (string-match "x250" (shell-command-to-string "uname -n"))
  (add-to-list 'default-frame-alist '(font . "Cica-15")))
```
### 12.2 [volatile-highlight]コピペした領域を強調

```emacs-lisp

```

## 13. ユーティリティー関数

### 13.1 Terminal を Emacsから呼び出す

```emacs-lisp
(defun term-current-dir-open ()
  "Open terminal application in current dir."
  (interactive)
  (let ((dir (directory-file-name default-directory)))
    (compile (concat "gnome-terminal --working-directory " dir))))
(bind-key "<f4>" 'term-current-dir-open)
```

### 13.2 Thunar を Emacsから呼び出す

```emacs-lisp
(defun filer-current-dir-open ()
  "Open filer in current dir."
  (interactive)
  (compile (concat "Thunar " default-directory)))
(bind-key "<f3>" 'filer-current-dir-open)

```

### 13.7 [restart-emacs]Emacsを再起動する
`C-x C-c` は、デフォルトで `(save-buffers-kill-emacs)` に割り当てられていますが、Emacsの再起動にリバインドしました。

```emacs-lisp
(leaf restart-emacs :ensure t
  :bind (("C-x C-c" . restart-emacs)))

```

## 14. おわりに

以上が私の init.el とその説明です。

私の Emacsは、Webページのメンテナンスがメインで、プログラムミング・エディタというよりは、「賢くて多機能なワープロ」という存在です。ありえない…ような邪道キーバインドや未熟な点も多々ありますが、諸先輩に学びながら育てていきたいと願っています。

<div style="flort:left">
&ensp;<a href="https://twitter.com/share" class="twitter-share-button" data-url="{{ .Permalink }}" data-via="minorugh" data-text="{{ .Params.Title }}" data-lang="jp" data-count="horizontal">Tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</div>
<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr"> <a href="https://twitter.com/minorugh/status/839117944260997120"></a></blockquote>


