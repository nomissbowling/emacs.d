;;; 60_howm.el --- 60_howm.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf howm
  :ensure t
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
	'(("memo:" . (0 'gnus-group-mail-3))
	  ("note:" . (0 'epa-mark))
	  ("code:" . (0 'compilation-info))
	  ("emacs:" . (0 'compilation-mode-line-fail))
	  ("linux:" . (0 'compilation-error)))))

(leaf open-junk-file
  :ensure t
  :config
  (setq open-junk-file-format "~/Dropbox/howm/junk/%Y/%Y%m%d."
	open-junk-file-find-file-function 'find-file))

(leaf org
  :config
  (setq org-log-done 'time
	org-use-speed-commands t
	org-src-tab-acts-natively t
	org-src-fontify-natively t
	org-agenda-files '("~/Dropbox/howm/org/task.org"
			   "~/Dropbox/howm/org/schedule.org"))

  (bind-key "C-c a" 'org-agenda)
  (bind-key "C-c c" 'org-capture)

  ;; Maximize the org-capture buffer
  (defvar my:org-capture-before-config nil
    "Window configuration before 'org-capture'.")
  (defadvice org-capture (before save-config activate)
    "Save the window configuration before 'org-capture'."
    (setq my:org-capture-before-config (current-window-configuration)))
  (add-hook 'org-capture-mode-hook 'delete-other-windows)

  (defun my:howm-create-file ()
    "Make howm create file with 'org-capture'."
    (interactive)
    (format-time-string "~/Dropbox/howm/%Y/%m/%Y%m%d%H%M.md" (current-time)))

  (setq org-capture-templates
	'(("t" " Task" entry (file+headline "~/Dropbox/howm/org/task.org" "Task")
	   "** TODO %?\n SCHEDULED: %^t \n" :prepend t)
	  ("s" " Shedule" entry (file+headline "~/Dropbox/howm/org/schedule.org" "Schedule")
	   "** %?\n SCHEDULED: %^t \n" :prepend t)
	  ("c" "📌 Code-Links" plain (file my:howm-create-file)
	   "# code: %?\n%U %i\n\n>>>\n\n````code\n%i\n```")
	  ("n" " Note-Draft" plain (file my:howm-create-file)
	   "# note: %?\n%U %i")
	  ("m" " Memo" plain (file my:howm-create-file)
	   "# memo: %?\n%U %i")
	  ("e" "★ Emacs" plain (file my:howm-create-file)
	   "# emacs: %?\n%U %i\n\n```emacs-lisp\n%i\n```")
	  ("l" "★ Linux" plain (file my:howm-create-file)
	   "# linux: %?\n%U %i\n\n````emacs-lisp\n%i\n```"))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 60_howm.el ends here
