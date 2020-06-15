;;; 05_misc.el --- 05_misc.el  -*- lexical-binding t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf popwin
  :ensure t
  :hook (after-init-hook . popwin-mode))


(leaf expand-region
  :ensure t
  :bind ("C-@" . er/expand-region))


(leaf key-chord
  :el-get zk-phi/key-chord
  :require t
  :config
  (key-chord-mode 1)
  :chord (("df" . counsel-descbinds)
	  ("l;" . init-loader-show-log)))


(leaf sequential-command-config
  :hook (after-init-hook . sequential-command-setup-keys)
  :init
  (leaf sequential-command :ensure t))


(leaf yasnippet
  :ensure t
  :bind ("<backtab>" . ivy-yasnippet)
  :hook (after-init-hook . yas-global-mode)
  :config
  (setq yas-snippet-dirs '("~/Dropbox/emacs.d/snippets"))
  :init
  (leaf ivy-yasnippet :ensure t))


(leaf prescient
  :ensure t
  :hook (after-init-hook . prescient-persist-mode)
  :init
  (leaf company-prescient :ensure t
    :hook (after-init-hook . company-prescient-mode))
  (leaf ivy-prescient :ensure t
    :hook (after-init-hook . ivy-prescient-mode)))


(leaf quickrun
  :ensure t
  :bind ("<f5>" . quickrun))


(leaf which-key
  :ensure t
  :hook (after-init-hook . which-key-mode)
  :config
  (setq which-key-max-description-length 40
	which-key-use-C-h-commands t))


(leaf projectile
  :ensure t
  :hook (after-init-hook . projectile-mode)
  :init
  (leaf counsel-projectile :ensure t
    :hook (after-init-hook . counsel-projectile-mode)))


(leaf espy
  :ensure t
  :config
  (setq espy-password-file "~/Dropbox/backup/passwd/password.org.gpg"))


(leaf restart-emacs
  :ensure t
  :bind (("C-x C-c" . restart-emacs)))


(leaf web-mode
  :ensure t
  :mode "\\.js\\'" "\\.html?\\'")


(leaf php-mode
  :ensure t
  :mode "\\.php\\'"  "\\.inc\\'" "\\.ctp\\'" "\\.lock\\'")


(leaf rainbow-mode
  :ensure t
  :bind ("C-c r" . rainbow-mode))


(leaf edit-indirect
  :ensure t
  :bind ("C-c i" . edit-indirect-region))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 05_misc.el ends here
