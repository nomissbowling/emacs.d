;;; init.el --- init.el  -*- lexical-binding: t -*-
;; emacs-initial-setting

;;; Code:
;; (setq debug-on-error t)

;; Quiet Startup
(set-frame-parameter nil 'fullscreen 'maximized)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)

(defvar default-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(setq gc-cons-threshold 100000000)
(add-hook 'emacs-startup-hook
	  (lambda ()
	    "Restore defalut values after startup."
	    (setq file-name-handler-alist default-file-name-handler-alist)
	    (setq gc-cons-threshold 800000)))

(customize-set-variable
 'package-archives '(("org"   . "https://orgmode.org/elpa/")
		     ("melpa" . "https://melpa.org/packages/")
		     ("gnu"   . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless (package-installed-p 'leaf)
  (package-refresh-contents)
  (package-install 'leaf))

(leaf exec-path-from-shell :ensure t
  :hook (after-init-hook . exec-path-from-shell-initialize)
  :config
  (setq exec-path-from-shell-check-startup-files nil))

(leaf leaf-keywords
  :ensure t
  :init
  (leaf bind-key :ensure t)
  (leaf hydra :ensure t)
  (leaf el-get :ensure t)
  :config
  (leaf-keywords-init))

(leaf init-loader :ensure t
  :init
  (setq load-prefer-newer t)
  (setq el-get-dir "~/.emacs.d/elisp")
  (add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
  (require 'dashboard)
  :config
  (add-hook
   'emacs-startup-hook
   (lambda ()
     (custom-set-variables '(init-loader-show-log-after-init 'error-only))
     (init-loader-load "~/Dropbox/emacs.d/inits")))
  (setq custom-file (locate-user-emacs-file "custom.el")))


(provide 'init)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; init.el ends here
