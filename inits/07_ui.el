;;; 07_ui.el --- 07_ui.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

;; custom-theme
(add-to-list 'custom-theme-load-path "~/Dropbox/emacs.d/elisp/iceberg-theme")
(load-theme 'iceberg t)


(leaf doom-modeline :ensure t
  :config
  (add-hook 'emacs-startup-hook 'doom-modeline-mode)
  (line-number-mode 0)
  (column-number-mode 0)
  (setq doom-modeline-buffer-file-name-style 'truncate-with-project
	doom-modeline-icon t
	doom-modeline-major-mode-icon nil
	doom-modeline-minor-modes nil)
  :init
  (leaf hide-mode-line :ensure t
    :hook ((imenu-list-minor-mode-hook direx:direx-mode-hook diff-mode-hook) . hide-mode-line-mode))
  (leaf nyan-mode :ensure t
    :config
    (nyan-mode)
    (setq nyan-cat-face-number 4
  	  nyan-animate-nyancat t)))


(leaf all-the-icons :ensure t
  :config
  (setq all-the-icons-scale-factor 1.0)
  :init
  (leaf all-the-icons-dired :ensure t
    :hook (dired-mode-hook . all-the-icons-dired-mode))
  (leaf all-the-icons-ivy-rich :ensure t
    :config
    (all-the-icons-ivy-rich-mode)))


(leaf darkroom :ensure t
  :bind ("<f12>" . my:darkroom-mode-in)
  :config
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

;;; 07_ui.el ends here
