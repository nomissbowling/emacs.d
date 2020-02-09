;;; 05_misc.el --- 05_misc.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; popwin
(use-package popwin)
(add-hook 'after-init-hook 'popwin-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; expand-region
(bind-key "C-@" 'er/expand-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sequential-command
(use-package sequential-command-config
  :commands sequential-command-setup-keys
  :hook (after-init . sequential-command-setup-keys))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; yasnippet
(add-hook 'after-init-hook 'yas-global-mode)
(setq yas-snippet-dirs '("~/Dropbox/emacs.d/snippets"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; prescient
(add-hook 'after-init-hook 'prescient-persist-mode)
(add-hook 'after-init-hook 'company-prescient-mode)
(add-hook 'after-init-hook 'ivy-prescient-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; persistent-scratch
(persistent-scratch-setup-default)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally
      ediff-diff-options "-twB")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; quickrun
(bind-key [f5] 'quickrun)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; which-key
(add-hook 'after-init-hook #'which-key-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; projectile
(add-hook 'after-init-hook 'projectile-mode)
(add-hook 'after-init-hook 'counsel-projectile-mode)

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 05_misc.el ends here
