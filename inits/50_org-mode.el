;;; 50_org-mode.el --- 50_org-mode.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(leaf org
  :chord (("aa" . org-agenda))
  :config
  (setq org-log-done 'time)
  (setq org-use-speed-commands t)
  (setq org-src-tab-acts-natively t)
  (setq org-src-fontify-natively t)
  (setq calendar-holidays nil)
  (setq org-clock-clocked-in-display 'frame-title)
  (setq howm-directory "~/Dropbox/howm/")
  (setq org-directory "~/Dropbox/howm/org/")
  (setq org-agenda-files '("~/Dropbox/howm/org/task.org"
			   "~/Dropbox/howm/org/schedule.org"))

  ;; Maximize the org-capture buffer
  (defvar my:org-capture-before-config nil
    "Window configuration before `org-capture'.")
  (defadvice org-capture (before save-config activate)
    "Save the window configuration before `org-capture'."
    (setq my:org-capture-before-config (current-window-configuration)))
  (add-hook 'org-capture-mode-hook 'delete-other-windows)

  ;; Agenda Settings
  (setq org-agenda-time-leading-zero t)
  (setq calendar-holidays nil)
  (setq org-log-done 'time)
  (setq org-agenda-skip-deadline-if-done nil)
  (setq org-agenda-skip-scheduled-if-done nil)
  (setq org-use-fast-todo-selection t)
  (setq org-agenda-include-inactive-timestamps t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-agenda-span 30)
  (setq org-agenda-dim-blocked-tasks nil)
  (setq org-agenda-inhibit-startup nil)
  (setq org-agenda-use-tag-inheritance nil)
  (defadvice org-agenda (around org-agenda-fullscreen activate)
    "Agenda open fullscreen."
    (interactive)
    (window-configuration-to-register :org-agenda-fullscreen)
    ad-do-it
    (delete-other-windows))
  (defadvice org-agenda-quit (around org-agenda-quit-fullscreen activate)
    "Agenda quit fullscreen."
    (interactive)
    ad-do-it
    (jump-to-register :org-agenda-fullscreen))
  ;; Customize
  (setq org-agenda-current-time-string "← now")
  (setq org-agenda-time-grid ;; Format is changed from 9.1
  	'((daily today require-timed)
  	  (0900 01000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400)
  	  "-"
  	  "────────────────"))
  (setq org-agenda-custom-commands
  	'(("d" "Daily Action List Detail"
  	   ((agenda "" ((org-agenda-ndays 1)
  			(org-agenda-sorting-strategy
  			 (quote ((agenda time-up priority-down tag-up))))
  			))))
  	  ("y" "Yesterday Action List"
  	   ((agenda "" ((org-agenda-span 1)
  			(org-agenda-start-day "-1d")
  			(org-agenda-entry-types '(:timestamp :sexp))))))
  	  ("w" "Completed and/or deferred tasks from previous week"
  	   ((agenda "" ((org-agenda-span 8)
  			(org-agenda-start-day "-7d")
  			(org-agenda-entry-types '(:timestamp :sexp))))))))

  ;; Make howm-create-file
  (defun my:howm-create-file ()
    "Make howm create file with 'org-capture'."
    (interactive)
    (concat howm-directory
	    (format-time-string "/%Y/%m/%Y%m%d%H%M.md" (current-time))))

  ;; Capture file path
  (setq task-file (concat org-directory "task.org"))
  (setq schedule-file (concat org-directory "schedule.org"))

  (setq org-capture-templates
	'(("t" " Task" entry (file+headline task-file "Task")
	   "** TODO %?\n SCHEDULED: %^t \n" :prepend t)
	  ("s" " Shedule" entry (file+headline schedule-file "Schedule")
	   "** %?\n SCHEDULED: %^t \n" :prepend t)
	  ("c" "📌 Code-Link" plain (file my:howm-create-file)
	   "# code: %?\n%U %i\n\n>>>\n\n````code\n%i\n```")
	  ("i" "👌 Idea" plain (file my:howm-create-file)
	   "# idea: %? %U %i" :prepend t)
	  ("m" " Memo" plain (file my:howm-create-file)
	   "# memo: %?\n%U %i")
	  ("n" " Note" plain (file my:howm-create-file)
	   "# note: %?\n%U %i")
	  ("e" "★ Emacs" plain (file my:howm-create-file)
	   "# emacs: %?\n%U %i\n\n````emacs-lisp\n%i\n```")
	  ("l" "★ Linux" plain (file my:howm-create-file)
	   "# linux: %?\n%U %i\n\n````emacs-lisp\n%i\n```")
	  ("w" "★ Win10" plain (file my:howm-create-file)
	   "# win10: %?\n%U %i\n\n````emacs-lisp\n%i\n```")
	  ("h" "📔 俳句" plain (file my:howm-create-file)
	   "# 俳句: %?\n%U %i")))
  )

;; (setq org-refile-targets
;; 	(quote (("~/Dropbox/howm/org/archives.org" :level . 1)
;; 		("~/Dropbox/howm/org/remember.org" :level . 1)
;; 		(memo-file :level . 1)
;; 		(task-file :level . 1)))))


;; Local Variables:
;; byte-compile-warnings: (not free-vars callargs)
;; End:

;;; 50_org-mode.el ends here
