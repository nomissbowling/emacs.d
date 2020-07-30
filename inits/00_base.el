;;; 00_base.el --- 00_base.el
;;; Commentary:
;; performs various variable settings and function executions

;;; Code:
;; (setq debug-on-error t)

;; Start the server in Emacs session
(leaf server :require t
  :config
  (unless (server-running-p)
    (server-start)))

;; exec-path-from-shell
(leaf exec-path-from-shell :ensure t
  :when (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize)
  (setq exec-path-from-shell-check-startup-files nil))

;; Save the file specified code with basic utf-8 if it exists
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; font
(add-to-list 'default-frame-alist '(font . "Cica-18"))
;; for sub-machine
(when (string-match "x250" (shell-command-to-string "uname -n"))
  (add-to-list 'default-frame-alist '(font . "Cica-15")))


;; Recentf
(leaf recentf
  :config
  (recentf-mode)
  (setq recentf-save-file "~/.emacs.d/recentf")
  (setq recentf-max-saved-items 200)
  (setq recentf-auto-cleanup 'never)
  (setq recentf-exclud '("recentf" "COMMIT_EDITMSG\\" "bookmarks" "emacs\\．d" "\\.gitignore"
			 "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$" "\\.howm" "^/tmp/" "^/scp:"
			 (lambda (file) (file-in-directory-p file package-user-dir))))
  (push (expand-file-name recentf-save-file) recentf-exclude))

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

;; fringe-mode for right- only
(fringe-mode (cons 0 nil))

;; Interface for display-line-numbers (emacs version >=26)
(leaf display-line-numbers
  :bind ("<f9>" . display-line-numbers-mode)
  :hook ((prog-mode-hook text-mode-hook) . display-line-numbers-mode))

;; Highlight the current line
(global-hl-line-mode)
(make-variable-buffer-local 'global-hl-line-mode)
(add-hook 'dashboard-mode-hook (lambda() (setq global-hl-line-mode nil)))

;; Highlight matching parens
(show-paren-mode)
(setq show-paren-style 'mixed)

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
(bind-key "s-v" 'yank)	;; Like Mac
(bind-key "C-x C-x" 'my:exchange-point-and-mark)


(defun my:clipboard-kill-region ()
  "If the region is active, `clipboard-kill-region'.
If the region is inactive, `backward-kill-word'."
  (interactive)
  (if (use-region-p)
      (clipboard-kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))

(defun my:exchange-point-and-mark ()
  "No mark active `exchange-point-and-mark'."
  (interactive)
  (exchange-point-and-mark)
  (deactivate-mark))

;; Exit Emacs with M-x exitle
(defalias 'exit 'save-buffers-kill-emacs)

;; Input yes or no to y or n (even SPC OK instead of y)
(defalias 'yes-or-no-p 'y-or-n-p)

;; Set transparency (active inactive)
(add-to-list 'default-frame-alist '(alpha . (1.0 0.9)))

;; Set makefle mode
(add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode))

;; M-x info-emacs-manual (C-h r or F1+r)
(add-to-list 'Info-directory-list "~/Dropbox/emacs.d/elisp/info/")
(defun Info-find-node--info-ja (orig-fn filename &rest args)
  "Info as ORIG-FN FILENAME ARGS."
  (apply orig-fn
	 (pcase filename
	   ("emacs" "emacs-ja.info")
	   (_ filename))
	 args))
(advice-add 'Info-find-node :around 'Info-find-node--info-ja)

;; Set buffer that can not be killed
(with-current-buffer "*scratch*"
  (emacs-lock-mode 'kill))
(with-current-buffer "*Messages*"
  (emacs-lock-mode 'kill))

;; Hack emacs-init-time
(with-eval-after-load "time"
  (defun ad:emacs-init-time ()
    "Return a string giving the duration of the Emacs initialization."
    (interactive)
    (let ((str
	   (format "%.3f seconds"
		   (float-time
		    (time-subtract after-init-time before-init-time)))))
      (if (called-interactively-p 'interactive)
	  (message "%s" str)
	str)))
  (advice-add 'emacs-init-time :override #'ad:emacs-init-time))

;; Load user Functions
(add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
(require 'user-dired)
(require 'user-template)


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 00_base.el ends here
