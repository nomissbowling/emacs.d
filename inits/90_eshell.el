;;; 89_eshell.el --- 90_eshell.el
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf eshell
  :after popwin
  :bind* ("C-z" . eshell)
  :config
  (setq eshell-cmpl-ignore-case t)
  (setq eshell-ask-to-save-history (quote always))
  (setq eshell-cmpl-cycle-completions t)
  (setq eshell-cmpl-cycle-cutoff-length 5)
  (setq eshell-hist-ignoredups t)
  (setq eshell-prompt-function 'my:eshell-prompt)
  (setq eshell-prompt-regexp "^[^#$]*[$#] ")
  (setq eshell-command-aliases-list
	(append (list
		 (list "cl" "clear")
		 (list "ll" "ls -ltr -S")
		 (list "la" "ls -a -S")
		 (list "ex" "exit"))))
  :init
  (push '("*eshell*" :height 0.6) popwin:special-display-config))


(leaf *user-custom-function
  :init
  (defun my:eshell-prompt ()
    "Prompt change string."
    (concat (eshell/pwd)
	    (if (= (user-uid) 0) "\n# " "\n$ ")))

  (defun eshell/clear ()
    "Clear the current buffer, leaving one prompt at the top."
    (interactive)
    (let ((inhibit-read-only t))
      (erase-buffer)))

  (defun eshell-on-current-buffer ()
    "Set the eshell directory to the current buffer."
    (interactive)
    (let ((path (file-name-directory (or  (buffer-file-name) default-directory))))
      (with-current-buffer "*eshell*"
	(cd path)
	(eshell-emit-prompt)))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 90_eshell.el ends here
