;;; 00_base.el --- Emacs base settings  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf emacs-startup-setting
  :config
  ;; Quiet Startup
  (set-frame-parameter nil 'fullscreen 'maximized)
  (scroll-bar-mode 0)
  (tool-bar-mode 0)
  (menu-bar-mode 0)
  (setq inhibit-splash-screen t
		inhibit-startup-message t)


  ;; Basic modes
  (savehist-mode)
  (save-place-mode)
  (global-auto-revert-mode)
  (blink-cursor-mode)
  (winner-mode)
  (global-font-lock-mode)
  (global-visual-line-mode)

  ;; Misc
  (setq frame-title-format (concat "%b - emacs@" (system-name))
		ring-bell-function 'ignore
		scroll-preserve-screen-position :always
		visible-bell nil
		scroll-preserve-screen-position t
		ad-redefinition-action 'accept
		completion-ignore-case t
		read-file-name-completion-ignore-case t
		mouse-drag-copy-region t
		make-backup-files nil
		auto-save-default nil
		create-lockfiles nil
		vc-follow-symlinks t)
  (setq-default bidi-display-reordering nil)
  (setq-default tab-width 4)
  (add-to-list 'default-frame-alist '(alpha . (1.0 0.9)))

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
  ;; Basic encoding
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

  ;; key modifiers
  (bind-key* "<muhenkan>" 'minibuffer-keyboard-quit ivy-minibuffer-map)
  (bind-key "C-," 'xref-find-references)
  (bind-key "C-." 'xref-find-definitions)
  (bind-key "s-c" 'cool-copy)
  (bind-key "s-v" 'clipboard-yank)
  (bind-key "M-w" 'clipboard-kill-ring-save)
  (bind-key "C-w" 'clipboard-kill-region)
  (setq select-enable-clipboard t
		select-enable-primary t)
  ;; Helpful copy tool
  (leaf cool-copy :require t
	:el-get blue0513/cool-copy.el
	:config
	(setq cool-copy-show 'posframe))

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
    (setq recentf-save-file "~/.emacs.d/recentf"
		  recentf-max-saved-items 200
		  recentf-auto-cleanup 'never
		  recentf-exclude
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
    (setq show-paren-delay '0.1
		  show-paren-style 'mixed)
	;; (setq show-paren-style 'parenthesis)
    :global-minor-mode show-paren-mode)

  (leaf uniquify
    :config
    (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

  (leaf generic-x :require t))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 00_base.el ends here
