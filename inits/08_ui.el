;;; 08_ui.el --- UI tools  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf cycle-theme-setting
  :bind ("C-x t" . my:cycle-theme)
  :init
  (leaf doom-themes :ensure t)
  (add-to-list 'custom-theme-load-path "~/Dropbox/emacs.d/elisp/iceberg-theme")
  (setq my-themes (list 'iceberg 'doom-dracula)
		curr-theme my-themes)
  (load-theme (car curr-theme) t)
  (defun my:cycle-theme ()
	"Cycle custom theme."
	(interactive)
	(disable-theme (car curr-theme))
	(setq curr-theme (cdr curr-theme))
	(if (null curr-theme) (setq curr-theme my-themes))
	(load-theme (car curr-theme) t)
	(message "%s" (car curr-theme))))


(leaf doom-modeline
  :ensure t
  :global-minor-mode t
  :config
  (setq doom-modeline-buffer-file-name-style 'truncate-with-project
		doom-modeline-icon t
		doom-modeline-major-mode-icon nil
		doom-modeline-minor-modes nil)
  (line-number-mode 0)
  (column-number-mode 0)
  :init
  (leaf hide-mode-line
	:ensure t
	:hook ((fundamental-mode-hook dashboard-mode-hook imenu-list-minor-mode-hook direx:direx-mode-hook diff-mode-hook) . hide-mode-line-mode))
  (leaf nyan-mode
	:ensure t
	:global-minor-mode t
	:config
	(autoload 'nyan-mode "nyan-mode" nil t)
	(setq nyan-cat-face-number 4
		  nyan-animate-nyancat t)))


(leaf all-the-icons
  :ensure t
  :hook (dired-mode-hook . all-the-icons-dired-mode)
  :config
  (setq all-the-icons-scale-factor 1.0)
  (all-the-icons-ivy-rich-mode)
  :init
  (leaf all-the-icons-dired :ensure t)
  (leaf all-the-icons-ivy-rich :ensure t))


(leaf darkroom
  :ensure t
  :bind ("<f12>" . my:darkroom-mode-in)
  :config
  (defun my:darkroom-mode-in ()
    (interactive)
    (display-line-numbers-mode 0)
    (diff-hl-mode 0)
    (flymake-mode 0)
    (setq line-spacing 0.4)
    (darkroom-mode 1)
    (bind-key "<f12>" 'my:darkroom-mode-out darkroom-mode-map))

  (defun my:darkroom-mode-out ()
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
