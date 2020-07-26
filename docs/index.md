<h1 style="text-align:center;">Emacs Configuration @minorugh</h1>

## 1. はじめに
* [Leaf](https://github.com/conao3/leaf.el) に乗り換えたのを機に大幅に整理したので RTD にまとめました。
* 設定ファイルは全て `~/Dropbox/emacs.d/` に置いて Git管理しています。
* [init.el](https://github.com/minorugh/emacs.d/blob/master/init.el) のシンボリックを `~/.emacs.d` に置くことで複数端末から共有しています。
* 設定ファイル本体は、[GitHub](https://github.com/minorugh/emacs.d) に公開しています。
* 設定内容も本ドキュメントも、[@takaxp](https://twitter.com/takaxp) さんの [init.el](https://takaxp.github.io/) の記事から多くを吸収した模倣版です。
本家と重複する説明は省き、執筆用途にカスタマイズしたポイントのみ補足説明します。


八十路も近い老骨ながら、[@masasam](https://twitter.com/SolistWork) さん、[@takaxp](https://twitter.com/takaxp) さんのご指導を得て、盲目的なパッチワークから多少なりとも自力でカスタマイズできるまでスキルを上げることができました。感謝！

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
│   ├── user-dired.el
│   └── user-template.el
├── inits/
│   ├── 00_base.el
│   ├── 01_dashboard.el
│   ├── ...
│   ├── 90_eshell.el
│   └── 90_translate.el
├── snippets/
├── .gitignore
├── init.el
└── minimaru-init.el

```

## 2. 起動設定
基本的には `init.el` を読み込むことで制御しています。 手順は以下のとおり。

1. `init.el` の読み込み
2. `inits/` に配置したファイル群の読み込み （init-loader 使用）

init-loader を使うことの是非については諸説あるようですが、[多くの恩恵](http://emacs.rubikitch.com/init-loader/)は捨て難く私には必須ツールです。

### 2.1 [minimal-init.el] 最小限のEmacsを起動

[minimal-init.el](https://github.com/minorugh/emacs.d/blob/master/minimal-init.el) は、最小限の emacs を起動させるための設定です。シェルから `resq` と入力することで起動することがでます。

以下を `.zshrc` または `.bashrc` に書き込みます。

```shell
alias resq='emacs -q -l ~/Dropbox/emacs.d/minimal-init.el'
```

ファイルの PATH は、ご自分の環境に応じて修正が必要です。エラー等で Emacsが起動しない場合に使用します。

### 2.2 GCサイズの最適化
Emacs起動時に大胆に GCを減らし、Startup後に通常の値に戻します。
`init.el` の先頭に記述しないと効果は少ないです。元ネタは [seagle0123](https://github.com/seagle0128/.emacs.d/blob/master/init.el) からです。感謝！

```emacs-lisp
;; Speed up startup
(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(setq gc-cons-threshold 100000000)
(add-hook
 'emacs-startup-hook
 (lambda ()
   "Restore defalut values after startup."
   (setq file-name-handler-alist default-file-name-handler-alist)
   (setq gc-cons-threshold 800000)))

```

### 2.3 初期画面設定
起動時にギクシャクする画面は見たくないので、`init.el` の冒頭に以下を設定しています。

```emacs-lisp
;; Quiet Startup
(set-frame-parameter nil 'fullscreen 'maximized)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
```

### 2.4 Dashboard バッファーをリロードさせる

Emacs 起動時の初期画面には、`Dashboard` を表示させています。

![Dashboard by iceberg-theme](https://live.staticflickr.com/65535/50133698492_33ff20267b_b.jpg)

愛着あるこのバッファーですが、うっかり Killすると消えてしまうので消さないでリロードできるように設定しました。当面の作業が一段落したらここへ戻ります。
下記設定例では `<Home>` キーを押すことで、直前に作業していたバッファー画面とDashboard画面とをトグルで表示させています。(winner-mode 使用)

また、Dashboard は、読み取り専用バッファーなので簡単なお気に入りを開くためのワンキーリンクを設定できます。hydra で更に多くのBookMark リンクを表示させても便利です。


```emacs-lisp
;; Custom dashboard
(leaf dashboard :ensure t
  :hook (after-init-hook . dashboard-setup-startup-hook)
  :config
  (bind-key "<home>" 'open-dashboard)
  (bind-key "<home>" 'quit-dashboard dashboard-mode-map)
  ;;  （中略）
  (defvar dashboard-recover-layout-p nil
    "Wether recovers the layout.")

  (defun restore-previous-session ()
    "Restore the previous session."
    (interactive)
    (when (bound-and-true-p persp-mode)
      (restore-session persp-auto-save-fname)))

  (defun restore-session (fname)
    "Restore the specified session."
    (interactive
	 (list (read-file-name "Load perspectives from a file: " persp-save-dir)))
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
- [Dashboard の詳細設定](https://github.com/minorugh/emacs.d/blob/master/init-config.el)は、ここを見て下さい。 



## 3. コア設定
Emacs を操作して文書編集する上で必要な設定。

### 3.1 言語 / 文字コード

シンプルにこれだけです。

``` emacs-lisp
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
```
### 3.2 日本語入力

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
  (setq default-input-method "japanese-mozc")
  (setq mozc-helper-program-name "mozc_emacs_helper")
  (setq mozc-leim-title "♡かな")
  :init
  (leaf mozc-cursor-color
    :el-get iRi-E/mozc-el-extensions
    :require t)
  (leaf mozc-cand-posframe :ensure t
    :require t
    :config
    (setq mozc-candidate-style 'posframe)))

```
#### 3.2.1 [mozc] 句読点では即確定させる
句読点などを入力したとき、わざわざmozcに変換してもらう必要はないので以下を設定しておくことでワンアクションスピーディーになります。

```emacs-lisp
(add-hook 'mozc-mode-hook
          (lambda ()
            (define-key mozc-mode-map "?" '(lambda () (interactive) (mozc-insert-str "？")))
            (define-key mozc-mode-map "," '(lambda () (interactive) (mozc-insert-str "、")))
            (define-key mozc-mode-map "." '(lambda () (interactive) (mozc-insert-str "。")))))
```



#### 3.2.2 [mozc] ユーザー辞書を複数端末で共有させる

Windows10 では `Google日本語入力` を使います。WSLも含めて複数環境で Emacsを動かしています。これら全ての環境で Mozcユーザー辞書を共有できるようにしたいと思考中です。

Mozc のファイル群を Dropbox に保存して、シンボリックを各端末に置くという方法で、一応は動きますが多少問題もあります。辞書の共有は、Google Drive がよいという情報もあるので、時間のあるときにゆっくり試してみます。


## 4. カーソル移動
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

### 4.1 ウインドウの移動

私の場合、二分割以上の作業はしないので `C-q` だけで便利に使えるこの関数は宝物です。
最初の `C-q` でに分割になり、二度目以降は押すたびに Window 移動します。

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

### 4.2 バッファー切り替え

- [iflipb.el](https://github.com/jrosdahl/iflipb) を使うと tabbar感覚の操作感になります。
- [タブを使わない究極のバーファー移動](https://qiita.com/minoruGH/items/aa96e92c1434f87940d6)


```emacs-lisp
(leaf iflipb
  :ensure t
  :config
  (bind-key "M-]" 'iflipb-next-buffer)
  (bind-key "M-[" 'iflipb-previous-buffer)
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

### 4.3 バッファー先頭・末尾

[sequential-command.el](https://rubikitch.hatenadiary.org/entry/20090219/sequential_command) は地味なながら一度使うと便利すぎて止められません。Melpからインストールできるのですが、[@HKey](https://twitter.com/hke7) さんの改良版を el-getで入れてます。感謝！

- [sequential-command をもう少し賢く](https://hke7.wordpress.com/2012/04/08/sequential-command-%E3%82%92%E3%82%82%E3%81%86%E5%B0%91%E3%81%97%E8%B3%A2%E3%81%8F/)

```emacs-lisp
(leaf sequential-command-config
  :hook (emacs-startup-hook . sequential-command-setup-keys)
  :config
  (bind-key "C-a" 'seq-home)
  (bind-key "C-e" 'seq-end)
  :init
  (leaf sequential-command
	:el-get HKey/sequential-command))
```

### 4.4 編集点の移動
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

### 4.5 タグジャンプ
この機能もごく稀にしか使いません。
一等地にあるデフォルトの `M-.` は、もっとも頻繁に使う [hydra-menu](https://github.com/minorugh/emacs.d/blob/master/inits/10_hydra-menu.el) （後述）に渡したいので変更しています。

```emacs-lisp
;; xref-find-* key
(bind-key "C-," 'xref-find-references)
(bind-key "C-." 'xref-find-definitions)

```
### 4.6 [expand-region]カーソル位置を起点に選択範囲を賢く広げる
`er/expand-region` を呼ぶと、カーソル位置を起点として前後に選択範囲を広げてくれます。2回以上呼ぶとその回数だけ賢く選択範囲が広がりますが、2回目以降は設定したキーバインドの最後の一文字を連打すればOKです。その場合、選択範囲を狭める時は - を押し， 0 を押せばリセットされます。

```emacs-lisp
(leaf expand-region :ensure t
  :bind ("C-@" . er/expand-region)
  :confug
  (push 'er/mark-outside-pairs er/try-expand-list))
```
[@takaxp](https://twitter.com/m2ym) さんの [init.el](https://takaxp.github.io/) では [select.el とペアで使う方法](https://takaxp.github.io/init.html#org3901456e) が紹介されています。


## 5. 編集サポート


### 5.1 [selected] リージョン選択時のアクションを制御

選択領域に対するスピードコマンドです。Emacsバッファーで領域を選択した後、バインドしたと入力するとコマンドが実行されます。

`activate-mark-hook` は、日本語IMEが有効な時にもシングルキーで機能するためのものみたいですね。
元ネタは、[@takaxp](https://twitter.com/takaxp) さんの [init.el](https://takaxp.github.io/init.html#orgbc8501cf) です。 感謝！

[counsel-selected](https://github.com/takaxp/counsel-selected) を使うと、ミニバッファーにコマンドメニューがポップアップ表示されますが、私は Hydra で Help-menu ぽいのも併用しています。

```emacs-lisp
(leaf selected :ensure t
  :bind ("s-s" . hydra-selected/body)
  :hook (emacs-startup-hook . selected-global-mode)
  :config
  (with-eval-after-load 'selected
	(bind-key ";" 'comment-dwim selected-keymap)
	(bind-key "c" 'clipboard-kill-ring-save selected-keymap)
	(bind-key "." 'my:mozc-word-regist selected-keymap)
	(bind-key "e" 'my:eijiro selected-keymap)
	(bind-key "w" 'my:weblio selected-keymap)
	(bind-key "k" 'my:kobun selected-keymap)
	(bind-key "r" 'my:ruigo selected-keymap)
	(bind-key "p" 'my:postal selected-keymap)
	(bind-key "t" 'my:translate selected-keymap)
	(bind-key "m" 'my:g-map selected-keymap)
	(bind-key "g" 'my:google selected-keymap)
	(bind-key "l" 'counsel-selected selected-keymap)
	(bind-key "h" 'hydra-selected/body selected-keymap)
	(bind-key "q" 'selected-off selected-keymap))
  :init
  (leaf counsel-selected :el-get takaxp/counsel-selected)
  (defun my:translate ()
	"Traslate user-function for selected."
	(interactive)
	(google-translate-auto))
  :hydra
  (hydra-selected
   (:color red :hint nil)
   "
 🔍 _t_ranslate  _e_ijiro  _w_eblio  _k_obun  _r_uigo  _g_oogle  _l_ist"
   ("t" my:translate)
   ("e" my:eijiro)
   ("w" my:weblio)
   ("k" my:kobun)
   ("r" my:ruigo)
   ("g" my:google)
   ("l" cunsel-selected)))

```

検索結果を browse-url で表示させるユーザーコマンドは、検索urlのフォーマとさえ解れば、パッケージツールに頼らずともお好みのマイコマンドを作成できます。以下は、Webkio串刺し検索の例です。

```emacs-lisp
(defun weblio (str)
  (interactive (list (region-or-read-string nil)))
  (browse-url (format "http://www.weblio.jp/content/%s"
					  (upcase (url-hexify-string str)))))
```

日本語文章の編集中に即、辞書登録できるように、`mozc-word-regist` も設定しています。

```emacs-lisp
(defun my:mozc-word-regist ()
  "Run the mozc-tool in the background."
  (interactive)
  (compile "/usr/lib/mozc/mozc_tool --mode=word_register_dialog"))
```

### 5.2 [selected] IME のオン・オフを自動制御する

selected.el の最大の欠点は、IMEとの相性が悪いことです。IMEオンのまま選択領域に対するコマンドを選択すると、押下キーがバッファにそのまま入力されてしまいます。

領域を選択し始める時にIMEをオフにして、コマンド発行後にIMEを元に戻すという例が、
[@takaxp](https://qiita.com/takaxp) さんの [Qiitaの記事](https://qiita.com/takaxp/items/00245794d46c3a5fcaa8) にあったので、私の環境（emacs-mozc ）にあうように設定したら、すんなり動いてくれました。感謝！

```emacs-lisp
(leaf  *control-mozc-when-region-seleceted
  :init
  (defun my-activate-selected ()
    (selected-global-mode 1)
    (selected--on) ;; must call expclitly here
    (remove-hook 'activate-mark-hook #'my-activate-selected))
  (add-hook 'activate-mark-hook #'my-activate-selected)
  (defun my:ime-on ()
    (interactive)
    (when (null current-input-method) (toggle-input-method)))
  (defun my:ime-off ()
    (interactive)
    (inactivate-input-method))
  ;; mark-hook
  (add-hook
   'activate-mark-hook
   #'(lambda ()
       (setq my:ime-flag current-input-method) (my:ime-off)))
  (add-hook
   'deactivate-mark-hook
   #'(lambda ()
       (unless (null my:ime-flag) (my:ime-on)))))
```



### 5.3 [darkroom-mode] 執筆モード
[darkroom.el](https://github.com/joaotavora/darkroom)  は、画面の余計な項目を最小限にして、文章の執筆に集中できるようにするパッケージです。

基本機能は、文字サイズが大きくなり、モード行が消えるだけですが、設定例では、行番号表示、diff-hl、flymake も消しています。併せて文字間隔も少し大きくして読みやすくしました。[F12] キーで IN/OUT をトグルしています。

```emacs-lisp
(leaf darkroom :ensure t
  :config
  (bind-key "<f12>" 'my:darkroom-mode-in)
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

### 5.4 [yatex] YaTexでTex編集

ごく一般的な設定例ですが、参考になるとしたら [yatexprc](https://www.yatex.org/gitbucket/yuuji/yatex/blob/c45e2a0187b702c5e817bf3023816dde154f0de9/yatexprc.el) の `M-x YaTeX-lpr` を使って一気にPDF作成まで自動化している点でしょうか。

```emacs-lisp
(leaf yatex :ensure t
  :mode ("\\.tex\\'" . yatex-mode)
										;fa-  :config
  (setq tex-command "platex")
  (setq dviprint-command-format "dvpd.sh %s")
  (setq YaTeX-kanji-code nil)
  (setq YaTeX-latex-message-code 'utf-8)
  (setq YaTeX-default-pop-window-height 15)
  :init
  (add-hook
   'yatex-mode-hook
   (lambda()
     (require 'yatexprc)
     (bind-key "M-c" 'YaTeX-typeset-buffer)	;; Type set
     (bind-key "M-l" 'YaTeX-lpr))))		;; Open PDF file
```
`YaTeX-lpr` は、`dviprint-command-format` を呼び出すコマンドです。

dviファイルからdvipdfmx でPDF作成したあと、PDFビューアーを起動させて表示させるところまでをバッチファイルに書き、PATHの通ったところに置きます。私は、`/usr/loca/bin` に置きました。


```sh
#!/bin/bash
name=$1
dvipdfmx $1 && evince ${name%.*}.pdf
# Delete unnecessary files
rm *.au* *.dv* *.lo*
```
上記の例では、ビューアーに Linux の evince を設定していますが、mac でプレビューを使う場合は、下記のようになるかと思います。

```sh
dvipdfmx $1 && open -a Preview.app ${name%.*}.pdf
```

## 6. 表示サポート

### 6.1 [emacs-lock-mode] scratch バッファーを消さない

難しい関数を設定せずとも内蔵コマンドで簡単に実現できます。

```emacs-lisp
;; Set buffer that can not be killed
(with-current-buffer "*scratch*"
  (emacs-lock-mode 'kill))
(with-current-buffer "*Messages*"
  (emacs-lock-mode 'kill))
```

### 6.2 swiper を migemo 化してローマ字入力で日本語を検索

昔は、[avy-migemo-e.g.swiper.el](https://github.com/momomo5717/avy-migemo) を使って出来ていたのですが、２年ほど前から更新が止まってしまっていて、いまは動きません。つい最近、avy-migemo を使わない Tipsを見つけたので試した処、機嫌よく動いてくれています。

- [avy-migemoを使わずにswiper-migemoを実現する](https://qiita.com/minoruGH/items/20d7664a3a57c7365ebc) 
- [Ivy (Swiper) で雑に migemo を使う](https://www.yewton.net/2020/05/21/migemo-ivy/) 


```emacs-lisp
(defun my:ivy-migemo-re-builder (str)
  (let* ((sep " \\|\\^\\|\\.\\|\\*")
		 (splitted
		  (--map (s-join "" it)
				 (--partition-by
				  (s-matches-p " \\|\\^\\|\\.\\|\\*" it)
				  (s-split "" str t)))))
    (s-join "" (--map (cond
					   ((s-equals? it " ") ".*?")
					   ((s-matches? sep it) it)
					   (t (migemo-get-pattern it)))
					  splitted))))

(setq ivy-re-builders-alist
	  '((t . ivy--regex-plus)
		(swiper . my:ivy-migemo-re-builder)))
```

## 7. Hydra


[hydra.el](https://github.com/abo-abo/hydra) は、連続して操作するときにプレフィクスキーをキャンセルさせるための elispです。

日本では、[smartrep.el](http://sheephead.homelinux.org/2011/12/19/6930/) が有名だったようですが、hydra.elも同様の機能を提供します。
私はおもに8種の hydra を設定しています。それぞれを呼び出すための相関図は下記のとおりです。

```
┌──────────────────┐
│ hydra-work-menu  │ ワークテーブル分岐
└──────────────────┘
￬￪ 相互に行き来できる
┌──────────────────┐
│ hydra-quick-menu │ よく使うコマンド群
└──────────────────┘
   │
   ├── hydra-compile
   ├── hydra-markdown
   ├── hydra-package
   ├── hydra-magit    <<- Dired からも呼び出せる
   ├── hydra-browse   <<- Dashboard からも呼び出せる
   └── hydra-pinky
```

- [hydra-work-menu](https://github.com/minorugh/emacs.d/blob/master/inits/10_hydra-menu.el) 
- [hydra-quick-menu](https://github.com/minorugh/emacs.d/blob/master/inits/10_hydra-menu.el) 
- [hydra-pinky](https://github.com/minorugh/emacs.d/blob/master/inits/10_hydra-pinky.el) 
- [hydra-compile](https://github.com/minorugh/emacs.d/blob/master/inits/10_hydra-compile.el) 
- [hydra-markdown](https://github.com/minorugh/emacs.d/blob/master/inits/50_markdown.el) 
- [hydra-magit](https://github.com/minorugh/emacs.d/blob/master/inits/01_git.el) 
- [hydra-package](https://github.com/minorugh/emacs.d/blob/master/inits/10_hydra-misc.el) 
- [hydra-browse](https://github.com/minorugh/emacs.d/blob/master/inits/10_hydra-misc.el) 


## 8. 履歴 / ファイル管理

### 8.1 [auto-save-buffer-enhanced] ファイルの自動保存

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

### 8.2 空になったファイルを自動的に削除

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
  :hook
  (prog-mode-hook . undo-tree-mode)
  (text-mode-hook . undo-tree-mode)
  :custom
  ((undo-tree-visualizer-timestamps . t)
   (undo-tree-visualizer-diff . t)
   (undo-tree-enable-undo-in-region . nil)
   (undo-tree-auto-save-history . nil)
   (undo-tree-history-directory-alist
    . `(("." . ,(concat user-emacs-directory "undo-tree-hist/")))))
  :config
  (bind-key* "C-_" 'undo-tree-undo)
  (bind-key* "C-\\" 'undo-tree-undo)
  (bind-key* "C-/" 'undo-tree-redo)
  (bind-key* "C-x u" 'undo-tree-visualize)
  :init
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
  (let ((result	(ignore-errors (direx-project:jump-to-project-root-other-window) t)))
    (unless result (direx:jump-to-directory-other-window))))

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

(leaf direx :ensure t :require t
  :config
  (bind-key "<f10>" 'direx:jump-to-project-directory)
  (bind-key "C-x C-j" 'direx:jump-to-project-directory)
  (define-key direx:direx-mode-map "o" 'direx:open-file)
  (define-key direx:direx-mode-map "SPC" 'direx:find-item-other-window)
  (define-key direx:direx-mode-map "<f10>" 'quit-window)
  (setq direx:leaf-icon "  " direx:open-icon "📂" direx:closed-icon "📁")
  (push '(direx:direx-mode :position left :width 25 :dedicated t)
		popwin:special-display-config))

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
  (setq ps-paper-type 'a4)
  (setq ps-font-size 9)
  (setq ps-printer-name nil)
  (setq ps-print-header nil)
  (setq ps-show-n-of-n t)
  (setq ps-line-number t)
  (setq ps-print-footer nil))
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
  (shell-command-on-region
   begin end
   (format my:pdfout-command-format
		   (concat (read-from-minibuffer "File name:") ".pdf"))))
```

### 9.4 [md2pdf / md2docx]

```emacs-lisp
(defun md2pdf ()
  "Generate pdf from currently open markdown. Use wkhtmltopdf without latex"
  (interactive)
  (let ((filename (buffer-file-name (current-buffer))))
    (shell-command-to-string
     (concat
	  "pandoc "
	  filename
	  " -f markdown -t html5 -o "
	  (file-name-sans-extension filename) ".pdf"))
    (shell-command-to-string
     (concat
	  "evince "
	  (file-name-sans-extension filename) ".pdf"))))
```


```emacs-lisp
(defun md2docx ()
  "Generate docx from currently open markdown."
  (interactive)
  (let ((filename (buffer-file-name (current-buffer))))
	(shell-command-to-string
	 (concat
	  "pandoc "
	  filename
	  " -t docx -o "
	  (file-name-sans-extension filename)
	  ".docx -V mainfont=IPAPGothic -V fontsize=16pt --highlight-style=zenburn"))
	(shell-command-to-string
	 (concat
	  "xdg-open "
	  (file-name-sans-extension filename) ".docx"))))
```

## 10. Org Mode / Howm Mode

```emacs-lisp

```


## 11. フォント / 配色関係

### 11.1 フォント設定

```emacs-lisp
(add-to-list 'default-frame-alist '(font . "Cica-18"))
;; for sub-machine
(when (string-match "x250" (shell-command-to-string "uname -n"))
  (add-to-list 'default-frame-alist '(font . "Cica-15")))
```
### 11.2 [volatile-highlight]コピペした領域を強調

```emacs-lisp

```

## 12. ユーティリティー関数

### 12.1 Terminal を Emacsから呼び出す

```emacs-lisp
(defun term-current-dir-open ()
  "Open terminal application in current dir."
  (interactive)
  (let ((dir (directory-file-name default-directory)))
    (compile (concat "gnome-terminal --working-directory " dir))))
(bind-key "<f4>" 'term-current-dir-open)
```

### 12.2 Thunar を Emacsから呼び出す

```emacs-lisp
(defun filer-current-dir-open ()
  "Open filer in current dir."
  (interactive)
  (compile (concat "Thunar " default-directory)))
(bind-key "<f3>" 'filer-current-dir-open)

```

### 12.7 [restart-emacs] Emacsを再起動する
`C-x C-c` は、デフォルトで `(save-buffers-kill-emacs)` に割り当てられていますが、Emacsの再起動にリバインドしました。

```emacs-lisp
(leaf restart-emacs :ensure t
  :bind (("C-x C-c" . restart-emacs)))

```

## 13. WEB開発Tool

### 13.1 MakeWeb

### 13.2 Easy-Hugo

## 14. おわりに

以上が私の init.el とその説明です。

私の Emacsは、Webページのメンテナンスがメインで、プログラムミング・エディタというよりは、「賢くて多機能なワープロ」という存在です。ありえない…ような邪道キーバインドや未熟な点も多々ありますが、諸先輩に学びながら育てていきたいと願っています。

<div style="flort:left">
&ensp;<a href="https://twitter.com/share" class="twitter-share-button" data-url="{{ .Permalink }}" data-via="minorugh" data-text="{{ .Params.Title }}" data-lang="jp" data-count="horizontal">Tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');</script>
</div>
<blockquote class="twitter-tweet" lang="ja"><p lang="ja" dir="ltr"> <a href="https://twitter.com/minorugh/status/839117944260997120"></a></blockquote>


