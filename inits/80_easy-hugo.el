;;; 80_easy-hugo.el --- 80_easy-hugo.el   -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf easy-hugo
  :ensure t
  :config
  (bind-key "C-c C-e" 'easy-hugo)
  (bind-key "C-x p" 'easy-hugo-preview)
  (bind-key "C-x P" 'easy-hugo-publish)
  (bind-key "C-c d" 'inseart-date)
  (with-eval-after-load 'easy-hugo
    (bind-key [tab] 'easy-hugo-no-help easy-hugo-mode-map)
    (bind-key "v" 'easy-hugo-view-other-window easy-hugo-mode-map)
    (bind-key "o" 'easy-hugo-open-basedir easy-hugo-mode-map)
    (bind-key "m" 'asy-hugo-magit easy-hugo-mode-map)
    (bind-key "r" 'easy-hugo-rename easy-hugo-mode-map)
    (bind-key "e" 'my:edit-easy-hugo easy-hugo-mode-map))
  ;; Sort-publishday on startup
  (setq easy-hugo--sort-char-flg nil)
  (setq easy-hugo--sort-time-flg nil)
  (setq easy-hugo--sort-publishday-flg 1)
  :init
  (require 'popup)
  (leaf toml-mode :ensure t)
  ;; Main blog (=blog1)
  (setq easy-hugo-basedir "~/Dropbox/web/wegh/topics/"
		easy-hugo-url "https://topics.wegh.net"
		easy-hugo-sshdomain "xsrv"
		easy-hugo-root "/home/minorugh/wegh.net/public_html/topics/"
		easy-hugo-previewtime "300")
  ;; Bloglist
  (setq easy-hugo-bloglist
		;; blog2 setting
		'(((easy-hugo-basedir . "~/Dropbox/web/wegh/snap/")
		   (easy-hugo-url . "https://snap.wegh.net")
		   (easy-hugo-sshdomain . "xsrv")
		   (easy-hugo-root . "/home/minorugh/wegh.net/public_html/snap/"))
		  ;; blog3 setting
		  ((easy-hugo-basedir . "~/Dropbox/web/wegh/blog/")
		   (easy-hugo-url . "https://blog.wegh.net")
		   (easy-hugo-sshdomain . "xsrv")
		   (easy-hugo-root . "/home/minorugh/wegh.net/public_html/blog/"))
		  ;; blog4 setting
		  ((easy-hugo-basedir . "~/Dropbox/web/wegh/essay/")
		   (easy-hugo-url . "https://essay.wegh.net")
		   (easy-hugo-sshdomain . "xsrv")
		   (easy-hugo-root . "/home/minorugh/wegh.net/public_html/essay/"))
		  ;; blog5 setting
		  ((easy-hugo-basedir . "~/Dropbox/web/wegh/bible/")
		   (easy-hugo-url . "https://bible.wegh.net")
		   (easy-hugo-sshdomain . "xsrv")
		   (easy-hugo-root . "/home/minorugh/wegh.net/public_html/bible/"))
		  ;; blog6 setting
		  ((easy-hugo-basedir . "~/Dropbox/web/wegh/tube/")
		   (easy-hugo-url . "https://tube.wegh.net")
		   (easy-hugo-sshdomain . "xsrv")
		   (easy-hugo-root . "/home/minorugh/wegh.net/public_html/tube/"))
		  ;; blog7 setting
		  ((easy-hugo-basedir . "~/Dropbox/web/wegh/ryo/")
		   (easy-hugo-url . "https://ryo.wegh.net")
		   (easy-hugo-sshdomain . "xsrv")
		   (easy-hugo-root . "/home/minorugh/wegh.net/public_html/ryo/"))))

  ;; Customize for my help menu
  (setq easy-hugo-help-line 5
		easy-hugo-help "  n .. New blog post    r .. Rename file     p .. Preview          g .. Refresh
  d .. Delete post      a .. Search blog ag  P .. Publish clever   e .. Edit easy-hugo
  u .. Sort publish     s .. Sort time       < .. Previous blog    > .. Next bloge
  T .. publish timer    m .. Magit status    c .. Open config      f .. Open file
  N .. No help [tab]    / .. Select postdir  o .. Open base dir    v .. View other window
  ")
  :preface
  (defun my:edit-easy-hugo ()
    "Edit setting file for 'easy-hugo'."
    (interactive)
    (find-file "~/Dropbox/emacs.d/inits/80_easy-hugo.el")
    (forword-line 2))

  (defun inseart-date ()
    "Inseart date now."
    (interactive)
    (insert (format-time-string "%Y-%m-%dT%H:%M:%S+09:00"))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 80_easy-hugo.el ends here
