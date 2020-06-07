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
	  ("code:" . (0 'compilation-info))
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
	   "# linux: %?\n%U %i\n\n````emacs-lisp\n%i\n```")))
  (setq org-refile-targets
	(quote (("~/Dropbox/howm/org/archives.org" :level . 1)
		("~/Dropbox/howme/org/schedule.org" :level . 1)
		("~/Dropbox/howm/org/task.org" :level . 1))))
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


;; ChangeLog memo
(leaf clmemo
  :ensure t
  :bind ("C-x m" . clmemo)
  :config
  (autoload 'clmemo "clmemo" "ChangeLog memo mode." t)
  (setq clmemo-file-name "~/Dropbox/howm/ChangeLog"
	clmemo-title-list '("emacs" "win10" "debian" "memo" "idea" "GH"))
  :preface
  (leaf blgrep
    :ensure t
    :config
    (autoload 'clgrep "clgrep" "grep mode for ChangeLog file." t)
    (add-hook 'change-log-mode-hook
	      '(lambda ()
		 (bind-key* "C-c C-c" 'clmemo-exit change-log-mode-map)
		 (bind-key "C-c C-g" 'clgrep change-log-mode-map)
		 ))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 60_memo.el ends here
