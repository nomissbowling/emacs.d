;;; init.el --- emacs initial setting  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  (require 'cl-lib))

;; Speed up startup
(defvar default-file-name-handler-alist file-name-handler-alist)
(defvar default-gc-cons-threshold gc-cons-threshold)
(setq file-name-handler-alist nil)
(setq gc-cons-threshold (* 1024 1024 100))
(add-hook
 'emacs-startup-hook
 (lambda ()
   "Restore defalut values after startup."
   (setq file-name-handler-alist default-file-name-handler-alist)
   (setq gc-cons-threshold default-gc-cons-threshold)))


;; Package
(customize-set-variable
 'package-archives '(("org"   . "https://orgmode.org/elpa/")
					 ("melpa" . "https://melpa.org/packages/")
					 ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless (package-installed-p 'leaf)
  (package-refresh-contents)
  (package-install 'leaf))


(leaf leaf-keywords
  :ensure t
  :init
  (leaf bind-key :ensure t)
  (leaf el-get :ensure t)
  (leaf hydra :ensure t)
  :config
  (leaf-keywords-init)
  (setq load-prefer-newer t)
  (setq el-get-dir "~/.emacs.d/elisp")
  (setq custom-file (locate-user-emacs-file "custom.el"))
  (setq byte-compile-warnings '(cl-functions)))


(leaf init-loader
  :ensure t
  :init
  (add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
  (leaf user-defined :require t)
  :config
  (custom-set-variables '(init-loader-show-log-after-init 'error-only))
  (add-hook
   'after-init-hook
   (lambda ()
	 (init-loader-load "~/Dropbox/emacs.d/inits"))))


(provide 'init)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; init.el ends here
