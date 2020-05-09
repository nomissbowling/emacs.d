;;; 60_howm.el --- 60_howm.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf howm
  :ensure t
  :commands (howm-create howm-remember howm-list-all)
  :chord ("@@" . howm-list-all)
  :bind (:howm-view-summary-mode-map
	 ([backtab] . howm-view-summary-previous-section))
  :hook (after-init-hook . howm-mode)
  :init
  (setq howm-view-title-header "#")
  :config
  (setq howm-directory "~/Dropbox/howm"
	howm-view-split-horizontally t
	howm-view-summary-persistent nil
	howm-normalizer 'howm-sort-items-by-reverse-date
	howm-user-font-lock-keywords
	'(("memo:" . (0 'dired-mark prepend))
	  ("code:" . (0 'ivy-org))
	  ("haiku:" . (0 'company-template-field))
	  ("emacs:" . (0 'counsel-outline-2))
	  ("linux:" . (0 'compilation-error))
	  ("note:" . (0 'company-template-field)))))


(leaf open-junk-file
  :ensure t
  :config
  (setq open-junk-file-format "~/Dropbox/howm/junk/%Y/%Y%m%d.")
  (setq open-junk-file-find-file-function 'find-file))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 60_howm.el ends here
