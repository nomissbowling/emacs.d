;;; 08_ui.el --- 08_ui.el
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

;; Cycle custom theme
(add-to-list 'custom-theme-load-path "~/Dropbox/emacs.d/elisp/iceberg-theme")
(leaf doom-themes :ensure t)

(setq my-themes (list 'iceberg 'doom-dracula))
(defun my:cycle-theme ()
  "Cycle custom theme."
  (interactive)
  (disable-theme (car curr-theme))
  (setq curr-theme (cdr curr-theme))
  (if (null curr-theme) (setq curr-theme my-themes))
  (load-theme (car curr-theme) t)
  (message "%s" (car curr-theme)))
(setq curr-theme my-themes)
(load-theme (car curr-theme) t)


(leaf doom-modeline :ensure t
  :config
  (doom-modeline-mode)
  (line-number-mode 0)
  (column-number-mode 0)
  (setq doom-modeline-buffer-file-name-style 'truncate-with-project)
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon nil)
  (setq doom-modeline-minor-modes nil)
  :init
  (leaf hide-mode-line :ensure t
    :hook ((imenu-list-minor-mode-hook direx:direx-mode-hook diff-mode-hook) . hide-mode-line-mode))
  (leaf nyan-mode :ensure t
    :config
    (autoload 'nyan-mode "nyan-mode" nil t)
    (nyan-mode)
    (setq nyan-cat-face-number 4)
    (setq nyan-animate-nyancat t)))


;; Show clock in in the mode line
(setq display-time-format "%H:%M") ;; %y%m%d. ;; "%H%M.%S"
(setq display-time-interval 1)
(setq display-time-default-load-average nil)
(unless noninteractive
  (display-time-mode 1))


(leaf all-the-icons :ensure t
  :hook (dired-mode-hook . all-the-icons-dired-mode)
  :init
  (leaf all-the-icons-dired :ensure t)
  (leaf all-the-icons-ivy-rich :ensure t)
  :config
  (setq all-the-icons-scale-factor 1.0)
  (all-the-icons-ivy-rich-mode))


(leaf darkroom :ensure t
  :config
  (bind-key "<f12>" 'my:darkroom-mode-in)
  (defun my:darkroom-mode-in ()
    "Darkroom mode in."
    (interactive)
    (display-line-numbers-mode 0)
    (diff-hl-mode 0)
    (flymake-mode 0)
    (setq line-spacing 0.4)
    (darkroom-mode 1)
    (bind-key "<f12>" 'my:darkroom-mode-out darkroom-mode-map))
  (defun my:darkroom-mode-out ()
    "Darkroom mode out."
    (interactive)
    (darkroom-mode 0)
    (flymake-mode 1)
    (diff-hl-mode 1)
    (setq line-spacing 0.1)
    (display-line-numbers-mode 1)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 08_ui.el ends here
