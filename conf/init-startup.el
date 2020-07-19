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


;; migemo
(leaf migemo :ensure t
  :when (executable-find "cmigemo")
  :hook (after-init-hook . migemo-init)
  :config
  (setq migemo-command (executable-find "cmigemo")
	migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"))


;; (with-eval-after-load "time"
;;   (defun ad:emacs-init-time ()
;;     "Return a string giving the duration of the Emacs initialization."
;;     (interactive)
;;     (let ((str
;;            (format "%.3f seconds"
;;                    (float-time
;;                     (time-subtract after-init-time before-init-time)))))
;;       (if (called-interactively-p 'interactive)
;;           (message "%s" str)
;;         str)))
;;   (advice-add 'emacs-init-time :override #'ad:emacs-init-time))


(provide 'init-startup)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; init-startup.el ends here
