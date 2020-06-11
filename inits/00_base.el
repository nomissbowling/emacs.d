;;; 00_base.el --- 00_base.el -*- lexical-binding: t -*-

;; emacs base setting.
;; performs various variable settings and function executions
;; for emacs standard attachment library.

;;; Code:
;; (setq debug-on-error t)

(leaf *standard-configuration
  :init
  ;; Emacs use the $PATH set up by the user's shell
  (leaf exec-path-from-shell
    :ensure t
    :hook (after-init-hook . exec-path-from-shell-initialize)
    :config
    (setq exec-path-from-shell-check-startup-files nil))

  ;; Start the server in Emacs session
  (leaf server
    :require t
    :config
    (unless (server-running-p)
      (add-hook 'emacs-startup-hook 'server-start)))

  ;; Save the file specified code with basic utf-8 if it exists
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8)

  ;; font
  (add-to-list 'default-frame-alist '(font . "Cica-18"))
  ;; for sub-machine
  (when (string-match "x250" (shell-command-to-string "uname -n"))
    (add-to-list 'default-frame-alist '(font . "Cica-14.5")))

  ;; All warning sounds and flash are invalid (note that the warning sound does not sound completely)
  (setq ring-bell-function 'ignore)

  ;; unable right-to-left language reordering
  (setq-default bidi-display-reordering nil)

  ;; Point keeps its screen position when scroll
  (setq scroll-preserve-screen-position :always)

  ;; Turn Off warning sound screen flash
  (setq visible-bell nil)

  ;; Do not change the position of the cursor when scrolling pages
  (setq scroll-preserve-screen-position t)

  ;; Suppress warnings for 'ad-handle-definition:'
  (setq ad-redefinition-action 'accept)

  ;; Do not distinguish uppercase and lowercase letters on completion
  (setq completion-ignore-case t)
  (setq read-file-name-completion-ignore-case t)

  ;; Copy with mouse drag
  (setq mouse-drag-copy-region t)

  ;; Do not make a backup filie like *.~
  (setq make-backup-files nil)

  ;; Do not use auto save
  (setq auto-save-default nil)

  ;; Do not create lock file
  (setq create-lockfiles nil)

  ;; Do not record the same content in the history
  (setq history-delete-duplicates t)

  ;; Display file name in title bar: buffername-emacs-version
  (setq frame-title-format "%b")

  ;; Turn off 'Suspicious line XXX of Makefile.' makefile warning
  (add-hook 'makefile-mode-hook
	    (lambda ()
	      (fset 'makefile-warn-suspicious-lines 'ignore)))

  ;; Interface for display-line-numbers
  (leaf display-line-numbers
    :bind ("<f9>" . display-line-numbers-mode)
    :hook ((prog-mode-hook text-mode-hook) . display-line-numbers-mode))

  ;; Make it easy to see when it is the same name file
  (leaf uniquify
    :config
    (setq uniquify-buffer-name-style 'post-forward-angle-brackets
	  uniquify-min-dir-content 1))

  ;; contains many mode setting
  (leaf generic-x :require t)

  ;; Recentf
  (leaf recentf
    :hook (after-init-hook . recentf-mode)
    :config
    (setq recentf-save-file "~/.emacs.d/recentf"
  	  recentf-max-saved-items 200
  	  recentf-auto-cleanup 'never
  	  recentf-exclud '("recentf" "COMMIT_EDITMSG\\" "bookmarks" "emacs\\．d" "\\.gitignore"
  			   "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$" "\\.howm" "^/tmp/" "^/ssh:" "^/scp"
  			   (lambda (file) (file-in-directory-p file package-user-dir))))
    (push (expand-file-name recentf-save-file) recentf-exclude))

  :hook
  ;; Save hist
  (after-init-hook . savehist-mode)

  ;;Save plae
  (after-init-hook . save-place-mode)

  ;; Automatic reloading of changed files
  (after-init-hook . global-auto-revert-mode)

  ;; Do not blink the cursor
  (after-init-hook . blink-cursor-mode)

  ;; Window configuration undo/redo
  (after-init-hook . winner-mode)

  ;; font-lock
  (after-init-hook . global-font-lock-mode)

  ;; Highlight the current line
  ((after-init-hook . global-hl-line-mode)
   (dashboard-mode-hook eshell-mode-hook) .
   (lambda () (setq-local global-hl-line-mode nil)))

  ;; word wrapping is used
  (after-init-hook . global-visual-line-mode))


(leaf *user-configuration
  :init
  ;; Run muhenkan same minibuffer-keyboard-quit as C-g
  (bind-key* "<muhenkan>" 'minibuffer-keyboard-quit)

  ;; xref-find-* key
  (bind-key "C-," 'xref-find-references)
  (bind-key "C-." 'xref-find-definitions)

  ;; Use the X11 clipboard
  (setq select-enable-clipboard  t)
  (setq select-enable-primary  t)
  (bind-key "M-w" 'clipboard-kill-ring-save)
  (bind-key "C-w" 'my:clipboard-kill-region)

  (defun my:clipboard-kill-region ()
    "If the region is active, `clipboard-kill-region'.
If the region is inactive, `backward-kill-word'."
    (interactive)
    (if (use-region-p)
	(clipboard-kill-region (region-beginning) (region-end))
      (backward-kill-word 1)))

  ;; Exit Emacs with M-x exitle
  (defalias 'exit 'save-buffers-kill-emacs)

  ;; Input yes or no to y or n (even SPC OK instead of y)
  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; Set transparency (active inactive)
  (add-to-list 'default-frame-alist '(alpha . (1.0 0.8)))

  ;; Set makefle mode
  (add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode))

  ;; M-x info-emacs-manual (C-h r or F1+r)
  (add-to-list 'Info-directory-list "~/Dropbox/emacs.d/info/")
  (defun Info-find-node--info-ja (orig-fn filename &rest args)
    "Info as ORIG-FN FILENAME ARGS."
    (apply orig-fn
	   (pcase filename
	     ("emacs" "emacs-ja.info")
	     (_ filename))
	   args))
  (advice-add 'Info-find-node :around 'Info-find-node--info-ja))

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 00_base.el ends here
