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
   (defun open-neotree-or-direx-jump ()
     "In WSL-mode open direx:jump-to-other-buffer."
     (interactive)
     (when (getenv "WSLENV")
       (direx:jump-to-project-directory))
     (unless (getenv "WSLENV")
       (neotree-toggle)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Using the direx when the WSL
(use-package direx)
(setq direx:leaf-icon "  " direx:open-icon "📂" direx:closed-icon "📁")
(push '(direx:direx-mode :position left :width 30 :dedicated t)
      popwin:special-display-config)
;; use direx-project.el
;; https://blog.shibayu36.org/entry/2013/02/12/191459
(defun direx:jump-to-project-directory ()
  "If in project, launch direx-project otherwise start direx."
  (interactive)
  (let ((result (ignore-errors
		  (direx-project:jump-to-project-root-other-window)
		  t)))
    (unless result
      (direx:jump-to-directory-other-window))))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 40_neotree.el ends here
