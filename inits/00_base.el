;;; 00_base.el --- 00_base.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)


(leaf exec-path-from-shell
  :when  (memq window-system '(mac ns x))
  :hook (after-init-hook . exec-path-from-shell-initialize)
  :config
  (setq exec-path-from-shell-check-startup-files nil))


(leaf server
  :require t
  :config
  (unless (server-running-p)
    (server-start)))


(leaf *standard-configuration
  :config
  ;; unable right-to-left language reordering
  (setq-default bidi-display-reordering nil)

  ;; Save the file specified code with basic utf-8 if it exists
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8)

  ;; Display file name in title bar: buffername-emacs-version
  (setq frame-title-format "%b")

  ;; Point keeps its screen position when scroll
  (setq scroll-preserve-screen-position :always)

  ;; Turn Off warning sound screen flash
  (setq visible-bell nil)

  ;; All warning sounds and flash are invalid (note that the warning sound does not sound completely)
  (setq ring-bell-function 'ignore)

  ;; Do not change the position of the cursor when scrolling pages
  (setq scroll-preserve-screen-position t)

  ;; Suppress warnings for 'ad-handle-definition:'
  (ad-redefinition-action 'accept)

  ;; between the lines
  (setq line-spacing 0.1)

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
  (create-lockfiles . nil)
  ;; Do not record the same content in the history
  (history-delete-duplicates . t)

  :hook
  (;; Save hist
   (after-init-hook . savehist-mode)

   ;;Save place
   (after-init-hook . save-place-mode)

   ;; Automatic reloading of changed files
   (after-init-hook . global-auto-revert-mode)

   ;; Do not blink the cursor
   (after-init-hook . blink-cursor-mode)

   ;; font-lock
   (after-init-hook . global-font-lock-mode)

   ;; word wrapping is used
   (after-init-hook . global-visual-line-mode)

   ;; Turn off 'Suspicious line XXX of Makefile.' makefile warning
   (makefile-mode-hook
    (lambda ()
      (fset 'makefile-warn-suspicious-lines 'ignore)))))


(leaf *user-configuration
  :config
  ;; font for main-machine
  (when (string-match "e590" (shell-command-to-string "uname -n"))
    (add-to-list 'default-frame-alist '(font . "Cica-15.5"))
    (if (getenv "WSLENV")
	(add-to-list 'default-frame-alist '(font . "Cica-18.5"))))

  ;; font for sub-machine
  (when (string-match "x250" (shell-command-to-string "uname -n"))
    (add-to-list 'default-frame-alist '(font . "Cica-14.5")))

  ;; Exit Emacs with M-x exitle
  (defalias 'exit 'save-buffers-kill-emacs)

  ;; Input yes or no to y or n (even SPC OK instead of y)
  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; Set transparency (active inactive)
  (add-to-list 'default-frame-alist '(alpha . (1.0 0.8)))

  ;; Set makefle mode
  (add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode))

  ;; Set buffer that can not be killed
  (with-current-buffer "*scratch*"
    (emacs-lock-mode 'kill))
  (with-current-buffer "*Messages*"
    (emacs-lock-mode 'kill)))


;; Make it easy to see when it is the same name file
(leaf uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets
	uniquify-min-dir-content 1))


;; contains many mode setting
(leaf generic-x)


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


(leaf bind-key
  :ensure t
  :bind (("C-." . xref-find-definitions)
	 ("M-w" . clipboard-kill-ring-save)
	 ("C-w" . my:clipboard-kill-region)
	 ("M-/" . kill-buffer)
	 ("C-M-/" . kill-other-buffers))
  :bind* (("<muhenkan>" . minibuffer-keyboard-quit))
  :config
  ;; Use the X11 clipboard
  (setq select-enable-clipboard t
	select-enable-primary t)

  (defun my:clipboard-kill-region ()
    "If the region is active, `clipboard-kill-region'.
If the region is inactive, `backward-kill-word'."
    (interactive)
    (if (use-region-p)
	(clipboard-kill-region (region-beginning) (region-end))
      (backward-kill-word 1)))

  (defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
    (message "Killed other buffers!")))


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


;; Load user defined elisp
(load "~/Dropbox/emacs.d/elisp/user-defined.el")


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 00_base.el ends here
