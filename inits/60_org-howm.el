;;; 60_memo.el --- 60_memo.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  (leaf howm :ensure t
    :chord ("@@" . howm-list-all)
    :bind (:howm-view-summary-mode-map
	   ([backtab] . howm-view-summary-previous-section))
    :hook (after-init-hook . howm-mode)
    :init
    (setq howm-view-title-header "#")
    (defun my:howm-create-file ()
      "Make howm create file with 'org-capture'."
      (interactive)
      (format-time-string "~/Dropbox/howm/%Y/%m/%Y%m%d%H%M.md" (current-time)))
    :config
    (setq howm-directory "~/Dropbox/howm"
	  howm-view-split-horizontally t
	  howm-view-summary-persistent nil
	  howm-normalizer 'howm-sort-items-by-reverse-date
	  howm-user-font-lock-keywords
	  '(("memo:" . (0 'gnus-group-mail-3))
	    ("note:" . (0 'epa-mark))
	    ("perl:" . (0 'diff-refine-added))
	    ("haiku:" . (0 'compilation-mode-line-exit))
	    ("emacs:" . (0 'compilation-info))
	    ("linux:" . (0 'compilation-error)))))

  (leaf org
    :bind (("C-c a" . org-agenda)
	   ("C-c c" . org-capture))
    :config
    (setq org-log-done 'time
	  org-use-speed-commands t
	  org-src-fontify-natively t
	  org-agenda-files '("~/Dropbox/howm/org/task.org"
			     "~/Dropbox/howm/org/memo.org"))
    (setq org-refile-targets
	  '(("~/Dropbox/howm/org/archives.org" :level . 1)
	    ("~/Dropbox/howm/org/remember.org" :level . 1)
	    ("~/Dropbox/howm/org/task.org" :level . 1)))
    (setq org-capture-templates
	  '(("t" " Task" entry (file+headline "~/Dropbox/howm/org/task.org" "Task")
	     "** TODO %?\n SCHEDULED: %^t \n" :prepend t)
	    ("d" "📕 Diary" entry (file+headline "~/Dropbox/howm/org/memo.org" "Diary")
	     "** %?\n SCHEDULED: %^t \n" :prepend t)
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
    :init
    ;; Maximize the org-capture buffer
    (defvar my:org-capture-before-config nil
      "Window configuration before 'org-capture'.")
    (defadvice org-capture (before save-config activate)
      "Save the window configuration before 'org-capture'."
      (setq my:org-capture-before-config (current-window-configuration)))
    (add-hook 'org-capture-mode-hook 'delete-other-windows))

  (leaf open-junk-file :ensure t
    :config
    (setq open-junk-file-format "~/Dropbox/howm/junk/%Y%m%d."))

  )


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 60_org-howm.el ends here
