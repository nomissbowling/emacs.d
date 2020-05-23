;;; init.el --- init.el  -*- lexical-binding: t -*-

;; emacs-initial-setting

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  ;; Quiet start
  (set-frame-parameter nil 'fullscreen 'maximized)
  (scroll-bar-mode 0)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)

  ;; Speed up startup
  (defvar centaur-gc-cons-threshold (if (display-graphic-p) 16000000 1600000)
    "The default value to use for `gc-cons-threshold'. If you experience freezing,
  decrease this. If you experience stuttering, increase this.")

  (defvar centaur-gc-cons-upper-limit (if (display-graphic-p) 400000000 100000000)
    "The temporary value for `gc-cons-threshold' to defer it.")

  (defvar centaur-gc-timer (run-with-idle-timer 10 t #'garbage-collect)
    "Run garbarge collection when idle 10s.")

  (defvar default-file-name-handler-alist file-name-handler-alist)

  (setq file-name-handler-alist nil)
  (setq gc-cons-threshold centaur-gc-cons-upper-limit
        gc-cons-percentage 0.5)
  (add-hook 'emacs-startup-hook
            (lambda ()
              "Restore defalut values after startup."
              (setq file-name-handler-alist default-file-name-handler-alist)
              (setq gc-cons-threshold centaur-gc-cons-threshold
                    gc-cons-percentage 0.1)

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
                (setq gc-cons-threshold centaur-gc-cons-upper-limit))

              (defun my-minibuffer-exit-hook ()
                (setq gc-cons-threshold centaur-gc-cons-threshold))

              (add-hook 'minibuffer-setup-hook #'my-minibuffer-setup-hook)
              (add-hook 'minibuffer-exit-hook #'my-minibuffer-exit-hook)))

  ;; Increase threshold to fire garbage collection
  ;; (setq gc-cons-threshold (* 128 1024 1024))

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
