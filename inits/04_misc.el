;;; 04_misc.el --- 04_misc.el   -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf popwin
  :ensure t
  :global-minor-mode t)

(leaf iedit
  :ensure t
  :bind ("C-;" . iedit-mode))

(leaf expand-region
  :ensure t
  :bind ("C-@" . er/expand-region))

(leaf cool-copy
  :el-get blue0513/cool-copy.el
  :bind ("s-c" . cool-copy)
  :config
  (setq cool-copy-show 'posframe))

(leaf flycheck
  :ensure t
  :hook (emacs-startup-hook . global-flycheck-mode)
  :init
  (setq flycheck-global-modes
		'(not text-mode markdown-mode fundamental-mode lisp-interaction-mode
			  org-mode diff-mode toml-mode web-mode eshell-mode makefile-mode css-mode))
  (leaf flycheck-title :ensure t
    :after flycheck
    :global-minor-mode t))

(leaf key-chord
  :el-get zk-phi/key-chord
  :config
  (key-chord-define-global "df" 'counsel-descbinds)
  (key-chord-define-global "l;" 'init-loader-show-log)
  :global-minor-mode t)

(leaf prescient
  :ensure t
  :global-minor-mode prescient-persist-mode
  :init
  (leaf company-prescient :ensure t
    :after prescient company
    :global-minor-mode t)
  (leaf ivy-prescient :ensure t
    :after prescient ivy
    :global-minor-mode t))

(leaf quickrun
  :ensure t
  :bind ("<f5>" . quickrun))

(leaf which-key
  :ensure t
  :config
  (setq which-key-max-description-length 40)
  (setq which-key-use-C-h-commands t)
  :global-minor-mode t)

(leaf projectile
  :ensure t
  :global-minor-mode t
  :init
  (leaf counsel-projectile
    :ensure t
    :global-minor-mode t))

(leaf yasnippet
  :ensure t
  :commands yas-global-mode
  :config
  (yas-global-mode)
  (setq yas-snippet-dirs '("~/Dropbox/emacs.d/snippets"))
  :init
  (leaf yasnippet-snippets :ensure t)
  (leaf ivy-yasnippet :ensure t))

(leaf restart-emacs
  :ensure t
  :bind ("C-x C-c" . restart-emacs))

(leaf web-mode
  :ensure t
  :mode "\\.js?\\'" "\\.html?\\'" "\\.php?\\'")


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 04_misc.el ends here
