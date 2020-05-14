;;; 06_flymake.el --- 06_flymake.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf flymake
  :hook (prog-mode-hook . flymake-mode)
  :init
  (leaf flymake-diagnostic-at-point
    :ensure t
    :after flymake
    :hook
    (flymake-mode-hook . flymake-diagnostic-at-point-mode)
    (remove-hook 'flymake-diagnostic-functions 'flymake-proc-legacy-flymake))

  :config
  (defvar flymake-posframe-hide-posframe-hooks
    '(pre-command-hook post-command-hook focus-out-hook)
    "The hooks which should trigger automatic removal of the posframe.")

  (defun flymake-posframe-hide-posframe ()
    "Hide messages currently being shown if any."
    (posframe-hide " *flymake-posframe-buffer*")
    (dolist (hook flymake-posframe-hide-posframe-hooks)
      (remove-hook hook #'flymake-posframe-hide-posframe t)))

  (defun my:flymake-diagnostic-at-point-display-popup (text)
    "Display the flymake diagnostic TEXT inside a posframe."
    (posframe-show " *flymake-posframe-buffer*"
  		   :string (concat flymake-diagnostic-at-point-error-prefix
  				   (flymake--diag-text
  				    (get-char-property (point) 'flymake-diagnostic)))
  		   :position (point)
  		   :foreground-color "cyan"
  		   :internal-border-width 2
  		   :internal-border-color "red"
  		   :poshandler 'posframe-poshandler-window-bottom-left-corner)
    (dolist (hook flymake-posframe-hide-posframe-hooks)
      (add-hook hook #'flymake-posframe-hide-posframe nil t)))
  (advice-add 'flymake-diagnostic-at-point-display-popup :override 'my:flymake-diagnostic-at-point-display-popup))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 06_flymake.el ends here
