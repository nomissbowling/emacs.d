;;; 07_ui.el --- 07_ui.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf *user-cycle-theme
  :init
  (defun my-cycle-theme ()
    "Cycle custom theme."
    (interactive)
    (disable-theme (car curr-theme))
    (setq curr-theme (cdr curr-theme))
    (if (null curr-theme) (setq curr-theme my-themes))
    (load-theme (car curr-theme) t)
    (message "%s" (car curr-theme)))
  :config
  (setq my-themes (list 'iceberg 'doom-dracula))
  (setq curr-theme my-themes)
  (load-theme (car curr-theme) t)
  (bind-key "<f8>" 'my-cycle-theme)
  :preface
  (leaf iceberg-theme :ensure nil
    :init
    (add-to-list 'custom-theme-load-path "~/Dropbox/emacs.d/elisp/iceberg-emacs/"))
  (leaf doom-themes :ensure t))


(leaf doom-modeline
  :ensure t
  :hook (after-init-hook . doom-modeline-mode)
  :custom
  ((doom-modeline-buffer-file-name-style . 'truncate-with-project)
   (doom-modeline-icon . t)
   (doom-modeline-major-mode-icon . nil)
   (doom-modeline-minor-modes . nil))
  :config
  (line-number-mode 0)
  (column-number-mode 0)
  :preface
  (leaf hide-mode-line
    :ensure t
    :hook ((neotree-mode-hook imenu-list-minor-mode-hook diff-mode-hook ) . hide-mode-line-mode))
  (leaf nyan-mode
    :ensure t
    :hook (after-init-hook . nyan-mode)
    :custom
    ((nyan-cat-face-number . 4)
     (nyan-animate-nyancat . t))))


(leaf all-the-icons
  :ensure t
  :custom (all-the-icons-scale-factor . 1.0)
  :config
  (leaf all-the-icons-dired
    :ensure t
    :hook (dired-mode-hook . all-the-icons-dired-mode)))


;; Remove visual distractions and focus on writing
(leaf darkroom
  :el-get joaotavora/darkroom
  :bind (("<f12>" . my:darkroom-mode-in)
	 (:darkroom-mode-map
	  ("<f12>" . my:darkroom-mode-out)))
  :config
  (defun my:darkroom-mode-in ()
    "Darkroom mode in."
    (interactive)
    (display-line-numbers-mode 0)
    (flymake-mode 0)
    (darkroom-mode 1))

  (defun my:darkroom-mode-out ()
    "Darkroom mode out."
    (interactive)
    (darkroom-mode 0)
    (flymake-mode 1)
    (display-line-numbers-mode 1)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 07_ui.el ends here
