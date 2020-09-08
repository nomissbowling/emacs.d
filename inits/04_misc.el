;;; 04_misc.el --- 04_misc.el   -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf popwin :ensure t
  :config
  (popwin-mode))


(leaf iedit :ensure t
  :config
  (bind-key "C-;" 'iedit-mode))


(leaf expand-region :ensure t
  :config
  (bind-key "C-@" 'er/expand-region)
  (with-eval-after-load "selected"
    (bind-key "SPC" 'er/expand-region selected-keymap)))


(leaf cool-copy
  :el-get blue0513/cool-copy.el
  :config
  (bind-key "s-c" 'cool-copy)
  (setq cool-copy-show 'posframe))


(leaf flycheck :ensure t
  :hook (emacs-startup-hook . global-flycheck-mode)
  :init
  (setq flycheck-global-modes
  	'(not text-mode markdown-mode fundamental-mode lisp-interaction-mode
  	      org-mode diff-mode toml-mode web-mode eshell-mode makefile-mode css-mode))
  (leaf flycheck-title :ensure t
    :after flycheck
    :config
    (flycheck-title-mode)))


(leaf key-chord
  :el-get zk-phi/key-chord
  :config
  (key-chord-mode 1)
  (key-chord-define-global "df" 'counsel-descbinds)
  (key-chord-define-global "l;" 'init-loader-show-log))


(leaf prescient :ensure t
  :config
  (prescient-persist-mode)
  :init
  (leaf company-prescient :ensure t
    :config
    (company-prescient-mode))
  (leaf ivy-prescient :ensure t
    :config
    (ivy-prescient-mode)))


(leaf quickrun :ensure t
  :bind ("<f5>" . quickrun))


(leaf which-key :ensure t
  :config
  (which-key-mode)
  (setq which-key-max-description-length 40)
  (setq which-key-use-C-h-commands t))


(leaf projectile :ensure t
  :config
  (projectile-mode)
  :init
  (leaf counsel-projectile :ensure t
    :config
    (counsel-projectile-mode)))


(leaf yasnippet :ensure t
  :commands yas-global-mode
  :config
  (yas-global-mode)
  (setq yas-snippet-dirs '("~/Dropbox/emacs.d/snippets"))
  :init
  (leaf yasnippet-snippets :ensure t)
  (leaf ivy-yasnippet :ensure t))


(leaf restart-emacs :ensure t
  :config
  (bind-key "C-x C-c" 'restart-emacs))


(leaf web-mode :ensure t
  :mode "\\.js?\\'" "\\.html?\\'" "\\.php?\\'")


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 04_misc.el ends here
