;;; 20_migemo.el --- 20_migemo.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf migemo
  :when (executable-find "cmigemo")
  :hook (after-init-hook . migemo-init)
  :config
  (setq migemo-command (executable-find "cmigemo"))
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 20_migemo.el ends here
