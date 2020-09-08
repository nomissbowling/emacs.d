;;; init.el --- my init.el  -*- lexical-binding: t -*-
;;; Commentary:
;; emacs-initial-setting

;;; Code:
;; (setq debug-on-error t)

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


(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
		       ("melpa" . "https://melpa.org/packages/")
		       ("gnu"   . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))


  (leaf leaf-keywords :ensure t
    :config
    (leaf-keywords-init)
    :init
    (leaf bind-key :ensure t)
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    :preface
    (setq el-get-dir "~/.emacs.d/elisp")
    (setq load-prefer-newer t))


  (leaf init-loader :ensure t
    :config
    (custom-set-variables '(init-loader-show-log-after-init 'error-only))
    (add-hook
     'after-init-hook
     (lambda ()
       (init-loader-load "~/Dropbox/emacs.d/inits")))
    (setq custom-file (locate-user-emacs-file "custom.el"))))


(provide 'init)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; init.el ends here
