;;; 40_neotree.el --- 40_neotree.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package neotree
  :bind (	("s-n" . neotree-toggle)
		:map neotree-mode-map
		("RET" . neotree-enter-hide)
		("C-g" . neotree-toggle)
		("a" . neotree-hidden-file-toggle)
		([left] . neotree-select-up-node)
		([right] . neotree-change-root))
  :init
  (setq-default neo-keymap-style 'concise)
  :custom
  (neo-smart-open t)
  (neo-create-file-auto-open t)
  (neo-hidden-regexp-list '("^\\." "\\.cs\\.meta$" "\\.pyc$" "~$" "^#.*#$" "\\.elc$" "\\.ini$"))
  :preface
  ;; Change neotree's font size
  ;; Tips from https://github.com/jaypei/emacs-neotree/issues/218
  (defun neotree-text-scale ()
    "Text scale for neotree."
    (interactive)
    (text-scale-adjust 0)
    (text-scale-decrease 1)
    (message nil))
  (add-hook 'neo-after-create-hook
	    (lambda (_)
	      (call-interactively 'neotree-text-scale)))
  ;; neotree enter hide
  ;; Tips from https://github.com/jaypei/emacs-neotree/issues/77
  (defun neo-open-file-hide (full-path &optional arg)
    "The description of FULL-PATH & ARG is in `neotree-enter'."
    (neo-global--select-mru-window arg)
    (find-file full-path)
    (neotree-hide))
  (defun neotree-enter-hide (&optional arg)
    "`The description of ARG is in `neo-buffer--execute'."
    (interactive "P")
    (neo-buffer--execute arg 'neo-open-file-hide 'neo-open-dir))
  ;; Set for WSL
  (bind-key
   [f11]
   (defun open-neotree-or-dired-jump ()
     "In WSL-mode open dired-jump. If not by neotree."
     (interactive)
     (when (getenv "WSLENV")
       (split-window-horizontally)
       (dired-jump-other-window)
       (dired-hide-details-mode))
     (unless (getenv "WSLENV")
       (neotree-toggle)))))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 40_neotree.el ends here
