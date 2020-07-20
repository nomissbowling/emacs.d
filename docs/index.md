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

``` emacs-lisp
;; Load user functions
(add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
(require 'user-test)
(add-hook
 'after-init-hook
 (lambda ()
   (require 'user-dired)
   (require 'user-template)))
```

その他の遅延起動できるものは `inits/` フォルダーに配置して順次読み込みます。`init-loader` を使うことの是非は、諸説あるようですが、[多くの恩恵](http://emacs.rubikitch.com/init-loader/) もあるので私には必須ツールです。

### 3.1 minimal-init.el：最小限のEmacsを起動

最小限の emacs を起動させるための設定です。シェルから `eq` を入力することで起動することがでます。

以下を `.zshrc` または `.bashrc` に書き込みます。

```shell
alias eq='emacs -q -l ~/Dropbox/emacs.d/minimal-init.el'
```

ファイルの PATH は、ご自分の環境に応じて修正が必要です。Packageのテストや emacsが起動しない場合に使用します。

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
Emacs起動時に思いっきり GCを減らし、Startup後に通常の値に戻しています。`init.el` の先頭に記述しないと効果は少ないです。元ネタは [Vincent Zhang](https://github.com/seagle0128/.emacs.d/blob/master/init.el) からです。感謝！

### 3.4 exec-path-from-shell：PATH設定をシェルから継承する

* [https://github.com/purcell/exec-path-from-shell](https://github.com/purcell/exec-path-from-shell)

`exec-path-from-shell` は，シェルに設定した PATHの情報を Emacsに継承してくれます。

これを使わないで設定ファイルに直接 PATHを書くことも対応できますが、私の場合、TexLive や Perlbrew をはじめ shell-command でいろいろ作業させるので必須のツールです。

``` emacs-lisp
;; exec-path-from-shell
(leaf exec-path-from-shell :ensure t
  :when (memq window-system '(mac ns x))
  :hook (after-init-hook . exec-path-from-shell-initialize)
  :config
  (setq exec-path-from-shell-check-startup-files nil))

```

### 3.5 after-init-hook / emacs-startup-hook：遅延読み込み

* [after-init-hook と emacs-startup-hook の違いを読み解く](https://minosjp.hatenablog.com/entry/2019/10/08/232215)

何度もテストして遅延読み込みを設定しても正常動作するものは積極的に使っています。

個別に設定してもいいのですが、私の場合は `after-init-hook` で `init-loarder` が起動するようにし、`inits/` フォルダー内の設定群をまとめて遅延読み込みしています。

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
Emacs起動時の初期画面表示のための設定 `init-config.el` を `init-loader` による遅延読み込みより前に先読み込みします。（前項の設定を参照）


![Dashboard by iceberg-theme](https://live.staticflickr.com/65535/50133698492_33ff20267b_b.jpg) 

起動時にギクシャクした画面をみたくないので、まず冒頭に以下を設定しています。

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

愛着あるこのバッファーですが、うっかり Killすると消えてしまうので再生できるように設定しています。

`[Home]` を押すことで、前に開いていたバッファーと Dashboard画面とをトグル表示します。(winner-mode使用)

``` emacs-lisp
;; user custom dashboard
(leaf dashboard :ensure t
  :bind (("<home>" . open-dashboard)
		 (:dashboard-mode-map
		  ("<home>" . quit-dashboard)))
  :hook (after-init-hook . dashboard-setup-startup-hook)
  :config
  ...
  ...
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

## 5. カーソル移動

## 6. 編集サポート

## 7. 表示サポート

## 8. 履歴 / ファイル管理

## 9. 開発サポート

## 10. Org Mode / Howm Mode

## 11. フォント / 配色関係

## 12. ユーティリティー関数

## 13. おわりに



<div class="rst-versions" data-toggle="rst-versions" role="note" aria-label="versions">
hoge
</div>
