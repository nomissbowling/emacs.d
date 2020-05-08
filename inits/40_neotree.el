;;; 40_neotree.el --- 40_neotree.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; Yet another dired for tree display
(leaf neotree
  :ensure t
  :bind (("<f10>" . neotree-find)
	 (:neotree-mode-map
	  ("RET" . neotree-enter-hide)
	  ("a" . neotree-hidden-file-toggle)
	  ("<left>" . neotree-select-up-node)
	  ("<right>" . neotree-change-root)
	  ("<f10>" . neotree-hide)))
  :init
  (setq-default neo-keymap-style 'concise)
  :config
  (setq neo-create-file-auto-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-hidden-regexp-list '("^\\." "\\.cs\\.meta$" "\\.pyc$" "~$" "^#.*#$" "\\.elc$" "^\\desktop.ini"))

  ;; neotree enter hide
  ;; Tips from https://github.com/jaypei/emacs-neotree/issues/77
  (defun neo-open-file-hide (full-path &optional arg)
    "Open file and hiding neotree.
The description of FULL-PATH & ARG is in `neotree-enter'."
    (neo-global--select-mru-window arg)
    (find-file full-path)
    (neotree-hide))

  (defun neotree-enter-hide (&optional arg)
    "Neo-open-file-hide if file, Neo-open-dir if dir.
The description of ARG is in `neo-buffer--execute'."
    (interactive "P")
    (neo-buffer--execute arg 'neo-open-file-hide 'neo-open-dir)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 40_neotree.el ends here
