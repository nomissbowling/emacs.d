;;; 06_highlight.el --- 06_highlight.el
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

;; A tomatically insert pairs
(leaf smartparens :ensure t
  :config
  (smartparens-global-mode)
  (sp-pair "`" nil :actions :rem)
  (sp-pair "'" nil :actions :rem)
  (sp-pair "[" nil :actions :rem))


;; Keeps code always indented
(leaf aggressive-indent :ensure t
  :hook ((emacs-lisp-mode-hook css-mode-hook) . aggressive-indent-mode))


;; Highlight the cursor whenever the window scrolls
(leaf beacon :ensure t
  :config
  (beacon-mode)
  (setq beacon-color "yellow"))


;; Highlight brackets according to their depth
(leaf rainbow-delimiters :ensure t
  :hook (prog-mode-hook . rainbow-delimiters-mode))


;; Colorize color names in buffers
(leaf rainbow-mode :ensure t
  :bind ("C-c r" . rainbow-mode))


;; Highlight some operations
(leaf volatile-highlights :ensure t
  :config
  (volatile-highlights-mode)
  (with-no-warnings
    (when (fboundp 'pulse-momentary-highlight-region)
      (defun my-vhl-pulse (beg end &optional _buf face)
	"Pulse the changes."
	(pulse-momentary-highlight-region beg end face))
      (advice-add #'vhl/.make-hl :override #'my-vhl-pulse))))


(leaf dimmer :ensure t
  :config
  (dimmer-mode)
  (setq dimmer-exclusion-regexp-list
	'(".*Minibuf.*" ".*which-key.*" "*direx:direx.*" "*Messages.*" ".*LV.*" ".*howm.*" ".*magit.*" ".*org.*"))
  (setq dimmer-fraction 0.5)
  :preface
  (with-eval-after-load "dimmer"
    (defun dimmer-off ()
      (dimmer-mode -1)
      (dimmer-process-all))
    (defun dimmer-on ()
      (dimmer-mode 1)
      (dimmer-process-all))
    (add-hook 'focus-out-hook #'dimmer-off)
    (add-hook 'focus-in-hook #'dimmer-on)))


(leaf whitespace :ensure t
  :bind ("C-c C-c" . my:cleanup-for-spaces)
  :hook (prog-mode-hook . my:enable-trailing-mode)
  :config
  (setq show-trailing-whitespace nil)
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

;;; 06_highlight.el ends here