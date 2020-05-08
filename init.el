;;; init.el --- init.el  -*- lexical-binding: t -*-

;; emacs-initial-setting

;;; Code:
;; (setq debug-on-error t)

;; this enables this running method
;; emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  ;; Quiet start
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (scroll-bar-mode 0)
  (set-frame-parameter nil 'fullscreen 'maximized)
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)

  ;; Increase threshold to fire garbage collection
  (setq gc-cons-threshold (* 128 1024 1024))

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
    (leaf bind-key :ensure t)
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    :config
    (setq el-get-dir "~/.emacs.d/elisp")
    (leaf-keywords-init))

  (leaf init-loader
    :ensure t
    :config
    (custom-set-variables
     '(init-loader-show-log-after-init 'error-only))
    (init-loader-load "~/Dropbox/emacs.d/inits")
    (setq custom-file (locate-user-emacs-file "custom.el"))))


(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
