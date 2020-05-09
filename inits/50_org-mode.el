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
  (setq org-agenda-files '("~/Dropbox/howm/org/task.org"
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
	   "# haiku: %?\n%U %i")
	  ("m" " Memo" plain (file my:howm-create-file)
	   "# memo: %?\n%U %i")
	  ("e" "★ Emacs" plain (file my:howm-create-file)
	   "# emacs: %?\n%U %i\n\n````emacs-lisp\n%i\n```")
	  ("l" "★ Linux" plain (file my:howm-create-file)
	   "# linux: %?\n%U %i\n\n````emacs-lisp\n%i\n```"))))


;; Local Variables:
;; byte-compile-warnings: (not free-vars callargs)
;; End:

;;; 50_org-mode.el ends here
