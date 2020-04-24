;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita
;; Author: Naoya Yamashita <conao3@gmail.com>
;; Modified: Minoru Yamada <minorughgmail.com>

;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; Quiet start
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(set-frame-parameter nil 'fullscreen 'maximized)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq gc-cons-threshold (* 128 1024 1024))

;; this enables this running methodf
;; emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq load-prefer-newer t)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    :init
    (leaf leaf-convert :ensure t)
    (leaf bind-key :ensure t)
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    :config
    (setq el-get-dir "~/.emacs.d/elisp")
    (leaf-keywords-init)))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf init-loader
  :ensure t
  :config
  (custom-set-variables
   '(init-loader-show-log-after-init 'error-only))
  (init-loader-load "~/Dropbox/emacs.d/inits")
  (setq custom-file (locate-user-emacs-file "custom.el")))


(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
