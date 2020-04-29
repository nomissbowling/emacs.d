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
	howm-file-name-format "%Y/%m/%Y%m%d%H%M.md"
	howm-keyword-file "~/Dropbox/dotfiles/howm-conf/.howm-keys"
	howm-history-file "~/Dropbox/dotfiles/howm-conf/.howm-history"
	howm-view-split-horizontally t
	howm-view-summary-persistent nil
	howm-normalizer 'howm-sort-items-by-reverse-date
	howm-user-font-lock-keywords
	'(("memo:" . (0 'dired-mark prepend))
	  ("blog:" . (0 'error prepend))
	  ("idea:" . (0 'diff-added prepend))
	  ("hack:" . (0 'dired-marked prepend))
	  ("mail:" . (0 'all-the-icons-silver prepend))
	  ("page:" . (0 'all-the-icons-dgreen prepend))
	  ("日記:" . (0 'diary prepend))
	  ("note:" . (0 'diff-changed prepend)))))


(leaf open-junk-file
  :ensure t
  :config
  (setq open-junk-file-format "~/Dropbox/howm/junk/%Y/%Y%m%d.")
  (setq open-junk-file-find-file-function 'find-file))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 60_howm.el ends here
