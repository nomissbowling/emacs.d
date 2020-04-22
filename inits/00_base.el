;;; 00_base.el --- 00_base.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf server
  :require t
  :config
  (unless (server-running-p)
    (server-start)))

(leaf Language
  :doc "Save the file specified code with basic utf-8 if it exists"
  :config
  (set-language-environment "Japanese")
  (prefer-coding-system 'utf-8))

(leaf Font
  :config
  ;; font for main-machine
  (when (string-match "e590" (shell-command-to-string "uname -n"))
    (add-to-list 'default-frame-alist '(font . "Cica-15.5"))
    (if (getenv "WSLENV")
	(add-to-list 'default-frame-alist '(font . "Cica-18.5"))))
  ;; font for sub-machine
  (when (string-match "x250" (shell-command-to-string "uname -n"))
    (add-to-list 'default-frame-alist '(font . "Cica-14.5"))))

(leaf exec-path-from-shell
  :require t
  :when  (member window-system '(mac ns x))
  :hook (after-init-hook . exec-path-from-shell-initialize)
  :config
  (setq exec-path-from-shell-check-startup-files nil))

(leaf Cus-start
  :custom
  (;; Display file name in title bar: buffername-emacs-version
   (frame-title-format . "%b")
   ;; Point keeps its screen position when scroll
   (scroll-preserve-screen-position . :always)
   ;; Turn Off warning sound screen flash
   (visible-bell . nil)
   ;; All warning sounds and flash are invalid (note that the warning sound does not sound completely)
   (ring-bell-function . 'ignore)
   ;; Do not change the position of the cursor when scrolling pages
   (scroll-preserve-screen-position . t)
   ;; Suppress warnings for 'ad-handle-definition:'
   (ad-redefinition-action . 'accept)
   ;; Faster rendering by not corresponding to right-to-left language
   (bidi-display-reordering . nil)
   ;; between the lines
   (line-spacing . 0.1)
   ;; Do not distinguish uppercase and lowercase letters on completion
   (completion-ignore-case . t)
   (read-file-name-completion-ignore-case . t)
   ;; Copy with mouse drag
   (mouse-drag-copy-region . t)
   ;; Do not make a backup filie like *.~
   (make-backup-files . nil)
   ;; Do not use auto save
   (auto-save-default . nil)
   ;; Do not create lock file
   (create-lockfiles . nil)
   ;; Do not record the same content in the history
   (history-delete-duplicates . t))

  :hook
  (;; Automatic reloading of changed files
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
      (fset 'makefile-warn-suspicious-lines 'ignore))))

  :init
  ;; Set makefle mode
  (add-to-list 'auto-mode-alist '("\\.mak\\'" . makefile-mode))

  ;; Exit Emacs with M-x exitle
  (defalias 'exit 'save-buffers-kill-emacs)

  ;; Input yes or no to y or n (even SPC OK instead of y)
  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; Set transparency (active inactive)
  (add-to-list 'default-frame-alist '(alpha . (1.0 0.8))))

(leaf leaf
  :config
  (leaf save-place
    :hook (after-init-hook . save-place-mode))

  (leaf savehist
    :doc "Save history of minibuffer."
    :hook (after-init-hook . savehist-mode)
    :custom (history-length . 1000))

  (leaf uniquify
    :doc "Make it easy to see when it is the same name file."
    :custom ((uniquify-buffer-name-style . 'post-forward-angle-brackets)
	     (uniquify-min-dir-content . 1)))

  (leaf generic-x
    :doc "contains many mode setting")

  (leaf select
    :doc "use the X11 clipboard."
    :bind (("M-w" . clipboard-kill-ring-save)
	   ("C-w" . my:clipboard-kill-region))
    :custom (select-enable-clipboard . t)
    :preface
    (defun my:clipboard-kill-region ()
      "If the region is active, `clipboard-kill-region'. If the region is inactive, `backward-kill-word'."
      (interactive)
      (if (use-region-p)
	  (clipboard-kill-region (region-beginning) (region-end))
	(backward-kill-word 1))))

  (leaf recentf
    :hook (after-init-hook . recentf-mode)
    :custom((recentf-save-file . "~/.emacs.d/recentf")
	    (recentf-max-saved-items . 200)
	    (recentf-auto-cleanup . 'never)
	    (recentf-exclude
	     . '("recentf" "COMMIT_EDITMSG\\" "bookmarks" "emacs\\．d" "\\.gitignore"
		 "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\)$" "\\.howm" "^/tmp/" "^/ssh:" "^/scp"
		 (lambda (file) (file-in-directory-p file package-user-dir)))))
    :config
    (push (expand-file-name recentf-save-file) recentf-exclude))

  (leaf bind-key
    :ensure t
    :bind (("<insert>" . clipboard-yank)
	   ("C-." . xref-find-definitions)
	   ("M-/" . kill-buffer)
	   ("C-M-/" . kill-other-buffer))
    :bind* (("<muhenkan>" . minibuffer-keyboard-quit)
	    ("C-x C-c" . iconify-frame))
    :config
    (defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
      (message "Killed other buffers!")))

  (leaf web-mode
    :ensure t
    :mode (("\\.html?\\'" . web-mode))))


(leaf Emacs-manual
  :doc "M-x info-emacs-manual (C-h r or F1+r)"
  :config
  (add-to-list 'Info-directory-list "~/Dropbox/emacs.d/info/")
  (advice-add 'Info-find-node :around 'Info-find-node--info-ja)
  (defun Info-find-node--info-ja (orig-fn filename &rest args)
    "Info as ORIG-FN FILENAME ARGS."
    (apply orig-fn
	   (pcase filename
	     ("emacs" "emacs-ja.info")
	     (_ filename))
	   args)))


(leaf my-template :require t
  :init
  (add-to-list 'load-path "~/Dropbox/emacs.d/elisp"))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 00_base.el ends here
