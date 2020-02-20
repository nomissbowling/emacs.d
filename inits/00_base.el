;;; 00_base.el --- 00_base.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; Language setting, default encode
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; Key Modifiers
(bind-key [insert] 'clipboard-yank)
(bind-key "C-." 'xref-find-definitions)
(bind-key* "<muhenkan>" 'minibuffer-keyboard-quit)

;; Enter a backslash instead of ¥
(define-key global-map [?¥] [?\\])

;; Iconify-frame
(bind-key* "C-x C-c" 'iconify-frame)

;; Font setting
(when (string-match "e590" (shell-command-to-string "uname -n"))
  (add-to-list 'default-frame-alist '(font . "Cica-15.5"))
  (if (getenv "WSLENV")
      (add-to-list 'default-frame-alist '(font . "Cica-18.5"))))
;; For submachine
(when (string-match "x250" (shell-command-to-string "uname -n"))
  (add-to-list 'default-frame-alist '(font . "Cica-14.5")))

;; exec-path-from-shell
(setq exec-path-from-shell-check-startup-files nil)
(add-hook 'after-init-hook 'exec-path-from-shell-initialize)

;; Recentf
(add-hook 'after-init-hook 'recentf-mode)
(setq recentf-save-file "~/.emacs.d/recentf"
      recentf-max-saved-items 200
      recentf-auto-cleanup 'never
      recentf-exclude
      '("recentf" "COMMIT_EDITMSG\\" "bookmarks" "emacs\\．d" "\\.gitignore"
	"\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$" "\\.howm" "^/tmp/" "^/ssh:" "^/scp"
	(lambda (file) (file-in-directory-p file package-user-dir))))
(push (expand-file-name recentf-save-file) recentf-exclude)

;; server start for emacs-client
(require 'server)
(unless (server-running-p)
  (server-start))

;; History;;
(add-hook 'after-init-hook 'save-place-mode)

;; Save history of minibuffer
(add-hook 'after-init-hook 'savehist-mode)
(setq history-length 1000)

;; Faster rendering by not corresponding to right-to-left language
(setq-default bidi-display-reordering nil)

;; between the lines
(setq-default line-spacing 0.1)

;; Do not make a backup filie like *.~
(setq make-backup-files nil)

;; Do not use auto save
(setq auto-save-default nil)

;; Do not create lock file
(setq create-lockfiles nil)

;; Disable automatic save
(setq auto-save-default nil)

;; Display file name in title bar: buffername-emacs-version
;; (setq frame-title-format '("%b - on GNU Emacs " emacs-version))
(setq frame-title-format "%b")

;; Do not distinguish uppercase and lowercase letters on completion
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; Make it easy to see when it is the same name file
(use-package uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Do not record the same content in the history
(setq history-delete-duplicates t)

;; Point keeps its screen position when scroll
(setq scroll-preserve-screen-position :always)

;; Turn Off warning sound screen flash
(setq visible-bell nil)

;; All warning sounds and flash are invalid (note that the warning sound does not sound completely)
(setq ring-bell-function 'ignore)

;; Do not change the position of the cursor when scrolling pages
(setq scroll-preserve-screen-position t)

;; Set major mode by extension
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode))

;; Copy with mouse drag
(setq mouse-drag-copy-region t)

;; Use the X11 clipboard
(setq select-enable-clipboard  t)
(bind-key "M-w" 'clipboard-kill-ring-save)
(bind-key "C-w" 'my:clipboard-kill-region)
(defun my:clipboard-kill-region ()
  "If the region is active, `clipboard-kill-region'.
If the region is inactive, `backward-kill-word'."
  (interactive)
  (if (use-region-p)
      (clipboard-kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))

;; Exit Emacs with M-x exit
(defalias 'exit 'save-buffers-kill-emacs)

;; Input yes or no to y or n (even SPC OK instead of y)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Automatic reloading of changed files
(add-hook 'after-init-hook 'global-auto-revert-mode)

;; Do not blink the cursor
(add-hook 'after-init-hook 'blink-cursor-mode 0)

;; font-lock
(add-hook 'after-init-hook 'global-font-lock-mode)

;; word wrapping is used
(add-hook 'after-init-hook 'global-visual-line-mode)

;; Set transparency (active inactive)
(add-to-list 'default-frame-alist '(alpha . (1.0 0.8)))

;; Turn off 'Suspicious line XXX of Makefile.' makefile warning
(add-hook 'makefile-mode-hook
	  (lambda ()
	    (fset 'makefile-warn-suspicious-lines 'ignore)))

;; Suppress warnings for 'ad-handle-definition:'
(setq ad-redefinition-action 'accept)

;; contains many mode setting
(use-package generic-x)

;; M-x info-emacs-manual (C-h r or F1+r)
(add-to-list 'Info-directory-list "~/Dropbox/emacs.d/info/")
(defun Info-find-node--info-ja (orig-fn filename &rest args)
  "Info as ORIG-FN FILENAME ARGS."
  (apply orig-fn
	 (pcase filename
	   ("emacs" "emacs-ja.info")
	   (_ filename))
	 args))
(advice-add 'Info-find-node :around 'Info-find-node--info-ja)

;; Load my-lisp
(use-package my-dired)
(use-package my-template)

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 00_base.el ends here
