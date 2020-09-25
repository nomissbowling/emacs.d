;;; 00_base.el --- emacs base settings  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf cus-start-setting
  :config
  ;; Basic modes
  (savehist-mode)
  (save-place-mode)
  (global-auto-revert-mode)
  (blink-cursor-mode)
  (winner-mode)
  (global-font-lock-mode)
  (global-visual-line-mode)
  (fringe-mode (cons 0 nil))

  ;; UI
  (set-frame-parameter nil 'fullscreen 'maximized)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (setq inhibit-splash-screen t)
  (setq inhibit-startup-message t)
  (add-to-list 'default-frame-alist '(alpha . (1.0 0.9)))

  ;; Misc
  (setq ring-bell-function 'ignore)
  (setq-default bidi-display-reordering nil)
  (setq scroll-preserve-screen-position :always)
  (setq visible-bell nil)
  (setq scroll-preserve-screen-position t)
  (setq ad-redefinition-action 'accept)
  (setq completion-ignore-case t)
  (setq read-file-name-completion-ignore-case t)
  (setq mouse-drag-copy-region t)
  (setq make-backup-files nil)
  (setq auto-save-default nil)
  (setq create-lockfiles nil)
  (setq vc-follow-symlinks t)
  (setq-default tab-width 4)

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
    (advice-add 'emacs-init-time :override #'ad:emacs-init-time)))


(leaf emacs-base-setting
  :config
  ;; Basic code
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8)

  ;; Font
  (add-to-list 'default-frame-alist '(font . "Cica-18"))
  (when (string-match "x250" (shell-command-to-string "uname -n"))
    (add-to-list 'default-frame-alist '(font . "Cica-15")))

  ;; Modifires
  (defalias 'exit 'save-buffers-kill-emacs)
  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; Set buffer that can not be killed
  (with-current-buffer "*scratch*"
    (emacs-lock-mode 'kill))
  (with-current-buffer "*Messages*"
    (emacs-lock-mode 'kill))

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

  :init
  (leaf server
    :require t
    :config
    (unless (server-running-p)
      (server-start)))

  (leaf exec-path-from-shell
    :ensure t
    :when (memq window-system '(mac ns x))
    :hook (emacs-startup-hook . exec-path-from-shell-initialize)
    :config
    (setq exec-path-from-shell-check-startup-files nil))

  (leaf recentf
    :global-minor-mode t
    :config
    (setq recentf-save-file "~/.emacs.d/recentf")
    (setq recentf-max-saved-items 200)
    (setq recentf-auto-cleanup 'never)
  	(setq recentf-exclude
  		  '("recentf" "COMMIT_EDITMSG" "bookmarks" "\\.gitignore"
  			"\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$" ".howm-keys" "\\.emacs.d/" "^/tmp/" "^/scp:"
  			(lambda (file) (file-in-directory-p file package-user-dir))))
  	(push (expand-file-name recentf-save-file) recentf-exclude))

  (leaf display-line-numbers
    :bind ("<f9>" . display-line-numbers-mode)
    :hook ((prog-mode-hook text-mode-hook) . display-line-numbers-mode))

  (leaf hl-line
    :config
    (make-variable-buffer-local 'global-hl-line-mode)
    (add-hook 'dashboard-mode-hook (lambda() (setq global-hl-line-mode nil)))
    :global-minor-mode global-hl-line-mode)

  (leaf paren
    :config
    (setq show-paren-delay '0.1)
    (setq show-paren-style 'mixed)
    :global-minor-mode show-paren-mode)

  (leaf uniquify
    :config
    (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

  (leaf generic-x :require t))


(leaf user-key-modifiers
  :config
  (bind-key* "<muhenkan>" 'minibuffer-keyboard-quit ivy-minibuffer-map)
  (bind-key "C-," 'xref-find-references)
  (bind-key "C-." 'xref-find-definitions)
  (bind-key "s-c" 'cool-copy)
  (bind-key "s-v" 'clipboard-yank)
  (bind-key "M-w" 'clipboard-kill-ring-save)
  (bind-key "C-w" 'my:clipboard-kill-region)
  :init
  (setq select-enable-clipboard t)
  (setq select-enable-primary t)
  (leaf cool-copy :require t
	:el-get blue0513/cool-copy.el
	:config
	(setq cool-copy-show 'posframe))
  :preface
  (defun my:clipboard-kill-region ()
	"If the region is active, `clipboard-kill-region'.
If the region is inactive, `backward-kill-word'."
	(interactive)
	(if (use-region-p)
		(clipboard-kill-region (region-beginning) (region-end))
	  (backward-kill-word 1))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 00_base.el ends here
