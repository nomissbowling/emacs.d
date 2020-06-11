;;; 60_memo.el --- 60_memo.el  -*- lexical-binding: t -*-
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
	  ("idea:" . (0 'epa-mark))
	  ("perl:" . (0 'compilation-info))
	  ("haiku:" . (0 'compilation-mode-line-exit))
	  ("emacs:" . (0 'compilation-mode-line-fail))
	  ("linux:" . (0 'compilation-error)))))


(leaf org
  :ensure nil
  :bind (("C-c a" . org-agenda)
	 ("C-c c" . org-capture))
  :config
  (setq org-log-done 'time
	org-use-speed-commands t
	org-src-fontify-natively t
	org-agenda-files '("~/Dropbox/howm/org/task.org"
			   "~/Dropbox/howm/org/schedule.org"))
  (setq org-refile-targets
	(quote (("~/Dropbox/howm/org/archives.org" :level . 1)
		("~/Dropbox/howm/org/remember.org" :level . 1)
		("~/Dropbox/howm/org/idea.org" :level . 1)
		("~/Dropbox/howm/org/task.org" :level . 1))))
  (setq org-capture-templates
	'(("t" " Task" entry (file+headline "~/Dropbox/howm/org/task.org" "Task")
	   "** TODO %?\n SCHEDULED: %^t \n" :prepend t)
	  ("s" " Shedule" entry (file+headline "~/Dropbox/howm/org/schedule.org" "Schedule")
	   "** %?\n SCHEDULED: %^t \n" :prepend t)
	  ("i" "✌ Idea" entry (file+headline "~/Dropbox/howm/org/idea.org" "Idea")
	   "* %? %U %i" :prepend)
	  ("r" "🐾 Remember" entry (file+headline "~/Dropbox/howm/org/remember.org" "Remember")
	   "* %? %U %i" :prepend)
	  ("m" " Memo" plain (file my:howm-create-file)
	   "# memo: %?\n%U %i")
	  ("n" " Note" plain (file my:howm-create-file)
	   "# note: %?\n%U %i")
	  ("p" "★ Perl" plain (file my:howm-create-file)
	   "# Perl: %?\n%U %i\n\n>>>\n\n```perl\n%i\n```")
	  ("e" "★ Emacs" plain (file my:howm-create-file)
	   "# emacs: %?\n%U %i\n\n```emacs-lisp\n%i\n```")
	  ("l" "★ Linux" plain (file my:howm-create-file)
	   "# linux: %?\n%U %i")))
  :preface
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
    (format-time-string "~/Dropbox/howm/%Y/%m/%Y%m%d%H%M.md" (current-time))))


(leaf clmemo
  :ensure t
  :bind (("C-x m" . clmemo)
	 (:clmemo-mode-map
	  ("C-c C-c" . clmemo-exit)))
  :config
  (autoload 'clmemo "clmemo" "ChangeLog memo mode." t)
  (setq clmemo-file-name "~/Dropbox/howm/ChangeLog"
	clmemo-title-list '("emacs" "win10" "debian" "memo" "idea" "GH")
	clmemo-time-string-with-weekday 't))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 60_memo.el ends here
