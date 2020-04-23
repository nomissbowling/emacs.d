;;; 08_highlight.el --- 08_highlight.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf smartparens :ensure t
  :hook (after-init-hook . smartparens-global-mode))


(leaf aggressive-indent :ensure t
  :hook ((emacs-lisp-mode-hook . aggressive-indent-mode)
	 (css-mode-hook . aggressive-indent-mode)))


(leaf paren
  :custom (show-paren-style . 'mixed)
  :config (show-paren-mode 1)
  :custom-face
  ((show-paren-match '((nil (:background "lime green" :foreground "#f1fa8c"))))))


(leaf hi-line
  :hook (after-init-hook . global-hl-line-mode))


(leaf beacon :ensure t
  :hook (after-init-hook . beacon-mode)
  :custom (beacon-color . "yellow"))


(leaf rainbow-delimiters :ensure t
  :hook (prog-mode-hook . rainbow-delimiters-mode))


(leaf volatile-highlights :ensure t
  :hook (after-init-hook . volatile-highlights-mode)
  :custom-face
  ((vhl/default-face '((nil (:foreground "#FF3333" :background "#FFCDCD"))))))


(leaf hiwin :ensure t
  :config
  (hiwin-activate)
  (set-face-background 'hiwin-face "#364456"))


(leaf whitespace :ensure t
  :bind ("C-c c" . my:cleanup-for-spaces)
  :hook (prog-mode-hook . my:enable-trailing-mode)
  :custom (show-trailing-whitespace . nil)
  :config
  (defun my:enable-trailing-mode ()
    "Show tail whitespace."
    (setq show-trailing-whitespace t))

  (defun my:cleanup-for-spaces ()
    "Remove contiguous line breaks at end of line + end of file."
    (interactive)
    (delete-trailing-whitespace)
    (save-excursion
      (save-restriction
	(widen)
	(goto-char (point-max))
	(delete-blank-lines)))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 08_highlight.el ends here
