;;; 60_howm.el --- 60_howm.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf howm
  :ensure t
  :commands
  (howm-create howm-remember howm-list-all)
  :bind (:howm-view-summary-mode-map
	 ([backtab] . howm-view-summary-previous-section))
  :chord ("@@" . howm-list-all)
  :hook
  (after-init-hook . howm-mode)
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
	  ("note:" . (0 'diff-changed prepend))))

  :hydra
  (hydra-howm
   (:hint nil :exit t)
   "
 📝 howm:  memo_,_  _i_dea  _h_ack  _n_ote  _d_iary  _p_age  _b_log  _m_ail  list_@_  "
   ("," my:howm-memo)
   ("i" my:howm-idea)
   ("h" my:howm-hack)
   ("n" my:howm-note)
   ("d" my:howm-dia)
   ("p" my:howm-page)
   ("b" my:howm-blog)
   ("m" my:howm-mail)
   ("@" howm-list-all)
   ("q" nil)))


(leaf Create-menu
  :config
  (defun my:howm-memo ()
    "My howm remember for memo."
    (interactive)
    (setq howm-template (concat howm-view-title-header "%title memo: %cursor\n"))
    (howm-remember))
  (defun my:howm-idea ()
    "My howm remember for idea."
    (interactive)
    (setq howm-template (concat howm-view-title-header "%title idea: %cursor\n"))
    (howm-create))
  (defun my:howm-hack ()
    "My howm create for hack."
    (interactive)
    (setq howm-template (concat howm-view-title-header "%title hack: %cursor\nurl:\n"))
    (howm-create))
  (defun my:howm-mail ()
    "My howm remember for mail draft."
    (interactive)
    (setq howm-template (concat howm-view-title-header "%title mail: %cursor\n"))
    (howm-create))
  (defun my:howm-blog ()
    "My howm create for blog draft."
    (interactive)
    (setq howm-template (concat howm-view-title-header "%title blog: %cursor\n%date\n"))
    (howm-create))
  (defun my:howm-dia ()
    "My howm create for diary draft."
    (interactive)
    (setq howm-template (concat howm-view-title-header "%title 日記: %cursor\n%date\n"))
    (howm-create))
  (defun my:howm-page ()
    "My howm create for page draft."
    (interactive)
    (setq howm-template (concat howm-view-title-header "%title page: %cursor\n%date\n"))
    (howm-create))
  (defun my:howm-note ()
    "My howm create for note draft."
    (interactive)
    (setq howm-template (concat howm-view-title-header "%title note: %cursor\n%date\n"))
    (howm-create))
  (defun my:haiku-note ()
    "Open haiku note file."
    (interactive)
    (find-file (format-time-string "~/Dropbox/howm/haiku/haikunote.%Y.md"))
    (goto-char (point-min)))
  (defun my:haiku-note-post ()
    "Insert template."
    (interactive)
    (find-file (format-time-string "~/Dropbox/howm/haiku/haikunote.%Y.md"))
    (goto-char (point-min))
    (forward-line 2)
    (insert
     (format-time-string "> %Y年%m月%d日 (%a)\n")
     (format-time-string "PLACE:\n\n"))
    (forward-line -2)
    (forward-char 6)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 60_howm.el ends here
