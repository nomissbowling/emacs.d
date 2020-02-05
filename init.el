;;; init.el --- init.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI
(set-frame-parameter nil 'fullscreen 'maximized)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Speed up startup
;; https://github.com/seagle0128/.emacs.d/blob/master/init.el
(defvar my:gc-cons-threshold (if (display-graphic-p) 8000000 800000)
  "The default value to use for `gc-cons-threshold'.
If you experience freezing,decrease this.If you experience stuttering, increase this.")

(defvar my:gc-cons-upper-limit (if (display-graphic-p) 400000000 100000000)
  "The temporary value for `gc-cons-threshold' to defer it.")

(defvar my:gc-timer (run-with-idle-timer 10 t #'garbage-collect)
  "Run garbarge collection when idle 10s.")

(defvar default-file-name-handler-alist file-name-handler-alist)

(setq file-name-handler-alist nil)
(setq gc-cons-threshold my:gc-cons-upper-limit)
(add-hook 'emacs-startup-hook
          (lambda ()
            "Restore defalut values after startup."
            (setq file-name-handler-alist default-file-name-handler-alist)
            (setq gc-cons-threshold my:gc-cons-threshold)

            ;; GC automatically while unfocusing the frame
            ;; `focus-out-hook' is obsolete since 27.1
            (if (boundp 'after-focus-change-function)
                (add-function :after after-focus-change-function
	    		      (lambda ()
	    			(unless (frame-focus-state)
	    			  (garbage-collect))))
              (add-hook 'focus-out-hook 'garbage-collect))

            ;; Avoid GCs while using `ivy'/`counsel'/`swiper' and `helm', etc.
            ;; @see http://bling.github.io/blog/2016/01/18/why-are-you-changing-gc-cons-threshold/
            (defun my-minibuffer-setup-hook ()
              (setq gc-cons-threshold my:gc-cons-upper-limit))

            (defun my-minibuffer-exit-hook ()
              (setq gc-cons-threshold my:gc-cons-threshold))

            (add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
            (add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load path
(add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
(add-to-list 'load-path "~/Dropbox/emacs.d/elisp/my-lisp")

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; List of packages to install from melpa
(defvar my-install-package-list
  '(aggressive-indent
    all-the-icons-dired
    auto-save-buffers-enhanced
    avy
    beacon
    bind-key
    browse-at-remote
    company
    company-box
    company-prescient
    counsel
    counsel-projectile
    counsel-css
    counsel-tramp
    dash
    dashboard
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
    howm
    htmlize
    hydra
    iflipb
    init-loader
    ivy-prescient
    ivy-rich
    ivy-yasnippet
    key-chord
    magit
    markdown-mode
    markdown-toc
    migemo
    mozc
    neotree
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
    use-package
    volatile-highlights
    web-mode
    which-key
    yasnippet
    yatex))

(require 'package)
(setq package-user-dir "~/.emacs.d/elpa")
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; Install packages that are not installed.
(let ((not-installed
       (cl-loop for x in my-install-package-list
                when (not (package-installed-p x))
                collect x)))
  (when not-installed
    (package-refresh-contents)
    (dolist (pkg not-installed)
      (package-install pkg))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Init-loader
(custom-set-variables
 '(init-loader-show-log-after-init 'error-only))
(init-loader-load "~/Dropbox/emacs.d/inits")
(setq custom-file (expand-file-name "custom.el" "~/Dropbox/emacs.d"))

(provide 'init)

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; init.el ends here
