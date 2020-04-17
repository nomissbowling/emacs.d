;;; init.el --- init.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; Custom start
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(set-frame-parameter nil 'fullscreen 'maximized)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq gc-cons-threshold (* 128 1024 1024))

;; package
(require 'package)
(setq package-user-dir "~/.emacs.d/elpa")
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

(defvar my:install-packages
  '(aggressive-indent
    all-the-icons-dired
    auto-save-buffers-enhanced
    avy
    beacon
    bind-key
    browse-at-remote
    company
    company-prescient
    counsel
    counsel-projectile
    counsel-css
    counsel-tramp
    dash
    dashboard
    dired-rsync
    direx
    doom-themes
    doom-modeline
    easy-hugo
    exec-path-from-shell
    expand-region
    flymake-diagnostic-at-point
    gist
    git-timemachine
    google-translate
    hiwin
    hide-mode-line
    howm
    htmlize
    hydra
    iflipb
    init-loader
    imenu-list
    ivy-prescient
;;    ivy-rich
    ivy-yasnippet
    key-chord
    leaf
    magit
    markdown-mode
    markdown-toc
    migemo
    mozc
    nyan-mode
    package-utils
    persistent-scratch
    popwin
    posframe
    prescient
    projectile
    quickrun
    rainbow-delimiters
    restart-emacs
    search-web
    sequential-command
    smartparens
    smex
    sudo-edit
    undohist
    volatile-highlights
    web-mode
    which-key
    yasnippet
    yatex))

;; Install packages that are not installed.
(let ((not-installed
       (cl-loop for x in my:install-packages
                when (not (package-installed-p x))
                collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))

;; Load path
(add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
(add-to-list 'load-path "~/Dropbox/emacs.d/elisp/my-lisp/")

;; Load newer whichever el or elc
(setq load-prefer-newer t)

;; Init-loader
(custom-set-variables
 '(init-loader-show-log-after-init 'error-only))
(init-loader-load "~/Dropbox/emacs.d/inits")
(setq custom-file (locate-user-emacs-file "custom.el"))

(provide 'init)

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; init.el ends here
