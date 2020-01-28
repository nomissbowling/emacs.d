;;; 90_eshell.el --- 90_eshell.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; use popwin
(with-eval-after-load "popwin"
  (push '("*eshell*" :height 0.6) popwin:special-display-config)
  (key-chord-define-global "zz" 'eshell))

;; Not case sensitive
(setq eshell-cmpl-ignore-case t)
;; Save history without confirmation
(setq eshell-ask-to-save-history (quote always))
;; Cycle on completing completion
(setq eshell-cmpl-cycle-completions t)
;; Without cycling if completion candidate is less than this number
(setq eshell-cmpl-cycle-cutoff-length 5)
;; Ignore duplicates in history
(setq eshell-hist-ignoredups t)

;; Prompt change string
(defun my-eshell-prompt ()
  "Prompt change string."
  (concat (eshell/pwd)
	  (if (= (user-uid) 0) "\n# " "\n$ ")))
(setq eshell-prompt-function 'my-eshell-prompt)
(setq eshell-prompt-regexp "^[^#$\n]*[$#] ")

;; written by Stefan Reichoer <reichoer@web.de>
(setq eshell-command-aliases-list
      (append
       (list
        (list "cl" "clear")
	(list "ll" "ls -ltr -S")
        (list "la" "ls -a -S")
        (list "ex" "exit"))))

(with-eval-after-load 'eshell
  ;; Clear command.
  (defun eshell/clear ()
    "Clear the current buffer, leaving one prompt at the top."
    (interactive)
    (let ((inhibit-read-only t))
      (erase-buffer)))
  ;; Fish-like history autosuggestions
  (use-package esh-autosuggest
    :defines ivy-display-functions-alist
    :preface
    (defun setup-eshell-ivy-completion ()
      (setq-local ivy-display-functions-alist
		  (remq (assoc 'ivy-completion-in-region ivy-display-functions-alist)
			ivy-display-functions-alist)))
    :bind (:map eshell-mode-map
		([remap eshell-pcomplete] . completion-at-point))
    :hook ((eshell-mode . esh-autosuggest-mode)
	   (eshell-mode . setup-eshell-ivy-completion)))
  ;; `cd' to frequent directory in eshell
  (use-package eshell-z
    :hook (eshell-mode . (lambda () (require 'eshell-z)))))

;; Launch eshell with Current buffer
(defun eshell-on-current-buffer ()
  "Set the eshell directory to the current buffer."
  (interactive)
  (let ((path (file-name-directory (or  (buffer-file-name) default-directory))))
    (with-current-buffer "*eshell*"
      (cd path)
      (eshell-emit-prompt))))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 90_eshell.el ends here
