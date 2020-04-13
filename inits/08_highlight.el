;;; 08_highlight.el --- 08_highlight.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; smartparen
(add-hook 'after-init-hook 'smartparens-global-mode)

;; aggressive-indent
(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
(add-hook 'css-mode-hook #'aggressive-indent-mode)

;; Brace the corresponding parentheses
(add-hook 'after-init-hook 'show-paren-mode)
(setq show-paren-style 'mixed)

;; Enable hi-line-mode
(add-hook 'after-init-hook 'global-hl-line-mode)

;; Enable beacon-mode ... flush the current line
(add-hook 'after-init-hook 'beacon-mode 1)
(setq beacon-color "yellow")

;; rainbow delimiters
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; volatile-highlights
(add-hook 'after-init-hook 'volatile-highlights-mode)
(custom-set-faces
 '(vhl/default-face ((nil (:foreground "#FF3333" :background "#FFCDCD")))))

;; Set background color of inactive window
(hiwin-activate)
(set-face-background 'hiwin-face "#364456")

;; Whitespace
(leaf whitespace
  :hook
  (prog-mode-hook . my:enable-trailing-mode)
  :config
  (setq-default show-trailing-whitespace nil)
  :preface
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
