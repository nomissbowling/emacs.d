;;; 20_migemo.el --- 20_migemo.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; migemo
(use-package migemo
  :hook (after-init . migemo-init)
  :custom
  (migemo-options '("-q" "--emacs"))
  (migemo-user-dictionary nil)
  (migemo-regex-dictionary nil)
  (migemo-coding-system 'utf-8-unix)
  :config
  ;; migemo-dict installed path
  (setq migemo-command "/usr/bin/cmigemo"
	migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"))


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 20_migemo.el ends here
