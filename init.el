;;; init.el --- init.el  -*- lexical-binding: t -*-

;; emacs-initial-setting

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  ;; Basic config
  (set-frame-parameter nil 'fullscreen 'maximized)
  (scroll-bar-mode 0)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)

  ;; Speed up startup
  ;; Fork from https://github.com/seagle0128/.emacs.d/blob/master/init.el
  (defvar centaur-gc-cons-threshold (if (display-graphic-p) 16000000 1600000))
  (defvar centaur-gc-cons-upper-limit (if (display-graphic-p) 400000000 100000000))
  (defvar centaur-gc-timer (run-with-idle-timer 10 t #'garbage-collect))
  (defvar default-file-name-handler-alist file-name-handler-alist)
  (setq file-name-handler-alist nil
        gc-cons-threshold centaur-gc-cons-upper-limit
        gc-cons-percentage 0.5)
  (add-hook 'emacs-startup-hook
            (lambda ()
              "Restore default values after startup."
              (setq file-name-handler-alist default-file-name-handler-alist
                    gc-cons-threshold centaur-gc-cons-threshold
                    gc-cons-percentage 0.1)))

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
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
