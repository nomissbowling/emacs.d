;;; 40_neotree.el --- 40_neotree.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; neotree

(use-package neotree
  :bind (	("s-n" . neotree-toggle)
		([f11] . neotree-toggle)
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
  (neo-hidden-regexp-list '("Icon" "^\\." "\\.cs\\.meta$" "\\.pyc$" "~$" "^#.*#$" "\\.elc$"))
  :config
  ;; Patched to allow everything but .DS_Store.
  ;; Tips from https://github.com/syl20bnr/spacemacs/issues/2751
  (with-eval-after-load 'neotree
    (defun neo-util--walk-dir (path)
      "Return the subdirectories and subfiles of the PATH."
      (let* ((full-path (neo-path--file-truename path)))
  	(condition-case nil
  	    (directory-files
  	     path 'full "^\\([^.]\\|\\.[^d.][^S]\\).*")
  	  ('file-error
  	   (message "Walk directory %S failed." path)
  	   nil)))))
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
    (neo-buffer--execute arg 'neo-open-file-hide 'neo-open-dir)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 40_neotree.el ends here
