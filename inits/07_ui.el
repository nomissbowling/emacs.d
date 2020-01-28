;;; 07_ui.el --- 07_ui.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme

(load-theme 'doom-dracula t)
(doom-themes-neotree-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; all-the-icons

(with-eval-after-load "all-the-icons"
  (setq all-the-icons-scale-factor 1.0))

(use-package doom-modeline
  :commands (doom-modeline-def-modeline)
  :custom
  (doom-modeline-buffer-file-name-style 'truncate-with-project)
  (doom-modeline-icon t)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-minor-modes nil)
  :hook
  (after-init . doom-modeline-mode)
  :config
  (line-number-mode 0)
  (column-number-mode 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Nyan-cat

(use-package nyan-mode
  :hook (after-init . nyan-mode)
  :custom
  (nyan-cat-face-number 4)
  (nyan-animate-nyancat t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Display-line-numbers-mode (Emacs 26.0.50 and newer versions)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)
(bind-key [f9] 'display-line-numbers-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fullscreen

(bind-key [S-return] 'toggle-frame-fullscreen)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Darkroom

(use-package darkroom
  :bind (([f12] . my:darkroom-mode-in)
	 :map darkroom-mode-map
	 ([f12] . my:darkroom-mode-out ))
  :config
  (defun my:darkroom-mode-in ()
    "Darkroom mode in."
    (interactive)
    (display-line-numbers-mode 0)
    (flymake-mode 0)
    (diff-hl-mode 0)
    (darkroom-mode 1))
  (defun my:darkroom-mode-out ()
    "Darkroom mode out."
    (interactive)
    (darkroom-mode 0)
    (diff-hl-mode 1)
    (flymake-mode 1)
    (display-line-numbers-mode 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Calendar

(use-package calendar
  :commands calendar
  :bind (([f7] . calendar)
	 :map calendar-mode-map
	 ("n" . calendar-forward-day)
	 ("b" . calendar-backward-day)
	 ([f7] . calendar-exit))
  :config
  (setq calendar-mark-holidays-flag t))

;; japanese-holidays
(use-package japanese-holidays
  :after calendar
  :config
  (setq calendar-holidays
	(append japanese-holidays holiday-local-holidays holiday-other-holidays)
	japanese-holiday-weekend '(0 6)    ;; Show weekends as holidays
	japanese-holiday-weekend-marker    ;; Shows Saturday in light blue
	'(holiday nil nil nil nil nil japanese-holiday-saturday))
  (add-hook 'calendar-today-visible-hook 'japanese-holiday-mark-weekend)
  (add-hook 'calendar-today-visible-hook 'calendar-mark-today))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 07_ui.el ends here
