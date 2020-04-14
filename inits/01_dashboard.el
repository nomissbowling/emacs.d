;;; 01_dashboard.el --- 01_dashboard.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf dashboard
  :bind (([home] . open-dashboard)
	 (:dashboard-mode-map
	  ("c" . browse-calendar)
	  ("w" . browse-weather)
	  ("n" . browse-google-news)
	  ("m" . browse-gmail)
	  ("t" . browse-tweetdeck)
	  ("s" . browse-slack)
	  ("h" . browse-homepage)
	  ("p" . browse-pocket)
	  ("." . dashboard-hydra/body)
	  ;; ([f7] . browse-calendar)
	  ;;	  ([f8] . browse-weather)
	  ([home] . quit-dashboard)))
  :init (dashboard-setup-startup-hook)
  :config
  (setq dashboard-banner-logo-title
	(concat "GNU Emacs " emacs-version " kernel "
		(car (split-string (shell-command-to-string "uname -r")))  " Debian "
		(car (split-string (shell-command-to-string "cat /etc/debian_version"))) " 86_64 GNU/Linux"))
  ;; Set the banner
  (setq dashboard-startup-banner "~/Dropbox/emacs.d/emacs.png")
  ;; Use icons
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  ;; Set the footer
  (setq dashboard-footer-icon
	(all-the-icons-octicon "dashboard" :height 1.1 :v-adjust -0.05 :face 'font-lock-keyword-face))
  ;; (setq dashboard-page-separator "\n\f\f\n")
  (setq dashboard-items '((recents  . 10)))
  ;; Insert custom item
  (defun dashboard-insert-custom (list-size)
    "Insert custom and set LIST-SIZE."
    (interactive)
    (insert (if (display-graphic-p)
		(all-the-icons-faicon "google" :height 1.2 :v-adjust -0.05 :face 'error) " "))
    (insert "    Calendar: (c)    Weather: (w)   📰 News: (n)    Mail: (m)    Twitter: (t)    Pocket: (p)    Slack: (s)    GH: (h) "))
  (add-to-list 'dashboard-item-generators  '(custom . dashboard-insert-custom))
  (add-to-list 'dashboard-items '(custom) t)
  :preface
  (defun open-dashboard ()
    "Open the *dashboard* buffer and jump to the first widget."
    (interactive)
    (delete-other-windows)
    (setq default-directory "~/")
    ;; Refresh dashboard buffer
    (if (get-buffer dashboard-buffer-name)
	(kill-buffer dashboard-buffer-name))
    (dashboard-insert-startupify-lists)
    (switch-to-buffer dashboard-buffer-name)
    ;; Jump to the first section
    (goto-char (point-min))
    (dashboard-goto-recent-files))
  (defvar dashboard-recover-layout-p nil
    "Wether recovers the layout.")
  (defun quit-dashboard ()
    "Quit dashboard window."
    (interactive)
    (quit-window t)
    (when (and dashboard-recover-layout-p
	       (bound-and-true-p winner-mode))
      (winner-undo)
      (setq dashboard-recover-layout-p nil)))
  (defun dashboard-goto-recent-files ()
    "Go to recent files."
    (interactive)
    (funcall (local-key-binding "r"))))

(prog1 "Browse-url"
  (defun browse-calendar ()
    "Open Google-calendar with chrome."
    (interactive)
    (browse-url "https://calendar.google.com/calendar/r"))
  (defun browse-weather ()
    "Open tenki.jp with chrome."
    (interactive)
    (browse-url "https://tenki.jp/week/6/31/"))
  (defun browse-google-news ()
    "Open Google-news with chrome."
    (interactive)
    (browse-url "https://news.google.com/topstories?hl=ja&gl=JP&ceid=JP:ja"))
  (defun browse-pocket ()
    "Open pocket with chrome."
    (interactive)
    (browse-url "https://getpocket.com/a/queue/"))
  (defun browse-homepage ()
    "Open my homepage."
    (interactive)
    (browse-url "https://gospel-haiku.com/"))
  (defun browse-gmail ()
    "Open gmail with chrome."
    (interactive)
    (browse-url "https://mail.google.com/mail/u/0/?tab=rm#inbox"))
  (defun browse-tweetdeck ()
    "Open tweetdeck with chrome."
    (interactive)
    (browse-url "https://tweetdeck.twitter.com/"))
  (defun browse-slack ()
    "Open slack with chrome."
    (interactive)
    (browse-url "https://emacs-jp.slack.com/messages/C1B73BWPJ/")))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 01_dashboard.el ends here
