;;; 00_base.el --- 00_base.el -*- lexical-binding: t -*-

;; emacs base setting.
;; performs various variable settings and function executions
;; for emacs standard attachment library.

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  ;; Quiet Startup
  (set-frame-parameter nil 'fullscreen 'maximized)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)

  ;; Save the file specified code with basic utf-8 if it exists
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8)

  ;; Recentf
  (leaf recentf
    :hook (after-init-hook . recentf-mode)
    :config
    (setq recentf-save-file "~/.emacs.d/recentf"
  	  recentf-max-saved-items 200
  	  recentf-auto-cleanup 'never
  	  recentf-exclud '("recentf" "COMMIT_EDITMSG\\" "bookmarks" "emacs\\．d" "\\.gitignore"
  			   "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$" "\\.howm" "^/tmp/" "^/scp:"
  			   (lambda (file) (file-in-directory-p file package-user-dir))))
    (push (expand-file-name recentf-save-file) recentf-exclude))

  ;; Startup hook section
  (add-hook
   'emacs-startup-hook
   (lambda ()
     ;; font
     (add-to-list 'default-frame-alist '(font . "Cica-18"))
     ;; for sub-machine
     (when (string-match "x250" (shell-command-to-string "uname -n"))
       (add-to-list 'default-frame-alist '(font . "Cica-15")))

     ;; Emacs use the $PATH set up by the user's shell
     (leaf exec-path-from-shell :ensure t
       :config
       (setq exec-path-from-shell-check-startup-files nil)
       (exec-path-from-shell-initialize))

     ;; Start the server in Emacs session
     (leaf server :require t
       :config
       (unless (server-running-p)
	 (server-start)))

     ;; Hide menu-bar
     (menu-bar-mode 0)
     ;; Save hist
     (savehist-mode)
     ;;Save plae
     (save-place-mode)
     ;; Automatic reloading of changed files
     (global-auto-revert-mode)
     ;; Do not blink the cursor
     (blink-cursor-mode)
     ;; Window configuration undo/redo
     (winner-mode)
     ;; font-lock
     (global-font-lock-mode)
     ;; word wrapping is used
     (global-visual-line-mode)

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
     ;; Open symbolic link directly
     (setq vc-follow-symlinks t)

     ;; Display file name in title bar: buffername-emacs-version
     (setq frame-title-format "%b")

     ;; Make it easy to see when it is the same name file
     (leaf uniquify
       :config
       (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

     ;; contains many mode setting
     (leaf generic-x :require t)

     ;; Text-scale-adjust
     (bind-key "s-z" 'text-scale-adjust)

     ;; Run muhenkan same as C-g
     (bind-key* "<muhenkan>" 'minibuffer-keyboard-quit ivy-minibuffer-map)

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
     (add-to-list 'default-frame-alist '(alpha . (1.0 0.9)))

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
     (advice-add 'Info-find-node :around 'Info-find-node--info-ja)

     )))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 00_base.el ends here
