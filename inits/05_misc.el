;;; 05_misc.el --- 05_misc.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf popwin
  :hook (after-init-hook . popwin-mode))

(leaf expand-region
  :bind ("C-@" . er/expand-region))

(leaf key-chord
  :config
  (key-chord-mode 1)
  (key-chord-define-global "df" 'counsel-descbinds)
  (key-chord-define-global "l;" 'init-loader-show-log)
  (key-chord-define-global "hj" 'undo)
  (key-chord-define-global "@@" 'howm-list-all)
  (key-chord-define-global ".." 'hydra-work/body))

(leaf sequential-command
  :config
  (leaf sequential-command-config
    :hook (after-init-hook . sequential-command-setup-keys)))

(leaf yasnippet
  :hook (after-init-hook . yas-global-mode)
  :config
  (setq yas-snippet-dirs '("~/Dropbox/emacs.d/snippets")))

(leaf prescient
  :hook ((after-init-hook . prescient-persist-mode)
	 (after-init-hook . company-prescient-mode)
	 (after-init-hook . ivy-prescient-mode)))

(leaf persistent-scratch
  :config
  (persistent-scratch-setup-default))

(leaf quickrun
  :bind ("<f5>" . quickrun))

;; which-key
(leaf which-key
  :hook (after-init-hook . which-key-mode)
  :custom ((which-key-max-description-length . 40)
	   (which-key-use-C-h-commands . t)))

(leaf projectile
  :hook ((after-init-hook . projectile-mode)
	 (after-init-hook . counsel-projectile-mode)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 05_misc.el ends here
