;;; init-startup.el --- init-startup.el -*- lexical-binding: t -*-
;; emacs startup settings.

;;; Code:
;; (setq debug-on-error t)

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


;; migemo
(leaf migemo :ensure t
  :when (executable-find "cmigemo")
  :hook (after-init-hook . migemo-init)
  :config
  (setq migemo-command (executable-find "cmigemo")
	migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (autoload 'migemo-init "migemo" nil t))


(provide 'init-startup)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; init-startup.el ends here
