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
	  ("l;" . init-loader-show-log)
	  ("hj" . undo)))

(leaf sequential-command-config
  :hook (after-init-hook . sequential-command-setup-keys)
  :init
  (leaf sequential-command :ensure t))

(leaf yasnippet
  :ensure t
  :hook (after-init-hook . yas-global-mode)
  :custom
  (yas-snippet-dirs . '("~/Dropbox/emacs.d/snippets"))
  :init
  (leaf ivy-yasnippet :ensure t))

(leaf prescient
  :ensure t
  :hook (after-init-hook . prescient-persist-mode)
  :config
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
  :custom
  ((which-key-max-description-length . 40)
   (which-key-use-C-h-commands . t)))

(leaf projectile
  :ensure t
  :hook (after-init-hook . projectile-mode)
  :config
  (leaf counsel-projectile :ensure t
    :hook (after-init-hook . counsel-projectile-mode)))

(leaf restart-emacs
  :ensure t
  :bind (("C-x C-c" . restart-emacs)))

(leaf macrostep
  :ensure t
  :bind (("C-c e" . macrostep-expand)))

(leaf web-mode
  :ensure t
  :mode "\\.js\\'" "\\.p.html?\\'")

(leaf php-mode
  :el-get emacs-php/php-mode
  :mode "\\.php\\'"  "\\.inc\\'" "\\.ctp\\'" "\\.lock\\'")


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 05_misc.el ends here
