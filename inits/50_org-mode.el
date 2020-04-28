;;; 50_org-mode.el --- 50_org-mode.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(leaf org
  :config
  (setq org-log-done 'time)
  (setq org-use-speed-commands t)
  (setq org-src-tab-acts-natively t)
  (setq org-src-fontify-natively t)
  ;;  (setq org-return-follows-link t)
  ;; (setq org-startup-folded 'content)
  (setq calendar-holidays nil)
  (setq org-clock-clocked-in-display 'frame-title)
  (setq org-directory "~/Dropbox/howm/org/")
  (setq org-agenda-files '("~/Dropbox/howm/org/task.org"
			   "~/Dropbox/howm/org/memo.org"
			   "~/Dropbox/howm/org/idea.org"))

  ;; Maximize the org-capture buffer
  (defvar my-org-capture-before-config nil
    "Window configuration before `org-capture'.")
  (defadvice org-capture (before save-config activate)
    "Save the window configuration before `org-capture'."
    (setq my-org-capture-before-config (current-window-configuration)))
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

  ;; Key-bind
  (bind-key "C-c a" 'org-agenda)
  (bind-key "C-c c" 'org-capture)
  ;; Capture file path
  ;; (setq capture-file (concat org-directory "capture.org"))
  (setq remember-file (concat org-directory "remember.org"))
  (setq experiment-file (concat org-directory "experiment.org"))
  (setq idea-file (concat org-directory "idea.org"))
  (setq memo-file (concat org-directory "memo.org"))
  (setq task-file (concat org-directory "task.org"))

  (setq org-capture-templates
	'(("e" " Experiment" entry (file+headline experiment-file "Experiment")
	   "* %? %U %i\n#+BEGIN_SRC emacs-lisp\n%i\n#+END_SRC" :prepend t)
	  ("i" "👌 Idea" entry (file+headline idea-file "Idea")
	   "* %? %U %i" :prepend t)
	  ("m" " Memo" entry (file+headline memo-file "Memo")
	   "* %? %U\n"  :unnarrowed 1 :prepend t)
	  ("h" " Howm" plain (file my:howm-create-file)
	   "# %?\n%U %i")
	  ("t" " Task" entry (file+headline task-file "Task")
	   "** TODO %?\n SCHEDULED: %^t \n" :prepend t)))

  (setq org-refile-targets
	(quote (("~/Dropbox/howm/org/archives.org" :level . 1)
		("~/Dropbox/howm/org/remember.org" :level . 1)
		(memo-file :level . 1)
		(task-file :level . 1))))
  )


;; Local Variables:
;; byte-compile-warnings: (not free-vars callargs)
;; End:

;;; 50_org-mode.el ends here
