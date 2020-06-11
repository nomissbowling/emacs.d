;;; init.el --- init.el  -*- lexical-binding: t -*-

;; emacs-initial-setting

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  (set-frame-parameter nil 'fullscreen 'maximized)
  (scroll-bar-mode 0)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)

  ;; Startup optimizations
  (setq gc-cons-threshold 100000000)
  (setq default-file-name-handler-alist file-name-handler-alist)
  (setq file-name-handler-alist nil)
  ;; after-init-hook to reset them
  (add-hook 'after-init-hook
            (lambda ()
              (setq gc-cons-threshold 800000)
              (setq file-name-handler-alist default-file-name-handler-alist)))

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
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    :config
    (leaf-keywords-init))

  (leaf init-loader
    :ensure t
    :config
    (setq load-prefer-newer t)
    (setq el-get-dir "~/.emacs.d/elisp")
    (custom-set-variables
     '(init-loader-show-log-after-init 'error-only))
    (init-loader-load "~/Dropbox/emacs.d/inits")
    (setq custom-file (locate-user-emacs-file "custom.el"))))


(provide 'init)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; init.el ends here
