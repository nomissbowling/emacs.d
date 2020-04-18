;;; 08_highlight.el --- 08_highlight.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf smartparens
  :hook (after-init-hook . smartparens-global-mode))

(leaf aggressive-indent
  :hook ((emacs-lisp-mode-hook . aggressive-indent-mode)
	 (css-mode-hook . aggressive-indent-mode)))

(leaf paren
  :custom (show-paren-style . 'mixed)
  :config
  (show-paren-mode 1)
  (custom-set-faces
   '(show-paren-match ((nil (:background "lime green" :foreground "#f1fa8c"))))))

(leaf hi-line
  :hook (after-init-hook . global-hl-line-mode))

(leaf beacon
  :doc "Enable beacon-mode ... flush the current line."
  :hook (after-init-hook . beacon-mode)
  :custom (beacon-color . "yellow"))

(leaf rainbow-delimiters
  :hook (prog-mode-hook . rainbow-delimiters-mode))

(leaf volatile-highlights
  :hook (after-init-hook . volatile-highlights-mode)
  :config
  (custom-set-faces
   '(vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD"))))))

(leaf hiwin
  :doc "Set background color of inactive window."
  :config
  (hiwin-activate)
  (set-face-background 'hiwin-face "#364456"))

(leaf whitespace
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
