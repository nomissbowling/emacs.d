;;; init-config.el   -*- lexical-binding: t -*-

;; an extensible emacs startup screen

;;; Code:
;; (setq debug-on-error t)

;; Quiet Startup
(set-frame-parameter nil 'fullscreen 'maximized)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)


;; exec-path-from-shell
(leaf exec-path-from-shell :ensure t
  :when (memq window-system '(mac ns x))
  :hook (after-init-hook . exec-path-from-shell-initialize)
  :config
  (setq exec-path-from-shell-check-startup-files nil))


;; Load user functions
(add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
(require 'user-test)
(add-hook
 'after-init-hook
 (lambda ()
   (require 'user-dired)
   (require 'user-template)))


;; user custom dashboard
(leaf dashboard :ensure t
  :bind (("<home>" . open-dashboard)
	 (:dashboard-mode-map
	  ("c" . browse-calendar)
	  ("w" . browse-weather)
	  ("n" . browse-google-news)
	  ("k" . browse-keep)
	  ("m" . browse-gmail)
	  ("t" . browse-tweetdeck)
	  ("s" . browse-slack)
	  ("h" . browse-homepage)
	  ("p" . browse-pocket)
	  ("e" . easy-hugo)
	  ("." . hydra-browse/body)
	  ("<home>" . quit-dashboard)))
  :hook (after-init-hook . dashboard-setup-startup-hook)
  :config
  (setq dashboard-startup-banner "~/Dropbox/emacs.d/emacs.png"
	dashboard-set-heading-icons t
	dashboard-set-file-icons t
	;; dashboard-page-separator "\n\f\f\n"
	show-week-agenda-p t
	dashboard-items '((recents  . 10)
			  (agenda . 5)))
  (setq dashboard-banner-logo-title
	(concat "GNU Emacs " emacs-version " kernel "
		(car (split-string (shell-command-to-string "uname -r")))  " Debian "
		(car (split-string (shell-command-to-string "cat /etc/debian_version"))) " 86_64 GNU/Linux"))
  ;; for sub machine
  (when (string-match "x250" (shell-command-to-string "uname -n"))
    (setq dashboard-items '((recents  . 5)
			    (agenda . 5))))

  ;; Set the footer
  (setq dashboard-footer-icon
	(all-the-icons-octicon "dashboard" :height 1.1 :v-adjust -0.05 :face 'font-lock-keyword-face))
  (setq dashboard-footer-messages '("Always be joyful. Never stop praying. Be thankful in all circumstances!"))
  ;; Insert custom item
  (add-to-list 'dashboard-item-generators  '(custom . dashboard-insert-custom))
  (add-to-list 'dashboard-items '(custom) t)
  :init
  (defun dashboard-insert-custom (list-size)
    "Insert custom and set LIST-SIZE."
    (interactive)
    (insert (if (display-graphic-p)
		(all-the-icons-faicon "google" :height 1.2 :v-adjust -0.05 :face 'dashboard-heading) " "))
    (insert "    Calendar: (c)   📰 News: (n)   📝 Keep: (k)    mail: (m)    Twitter: (t)    Pocket: (p)    Slack: (s)    GH: (h) "))

  (defvar dashboard-recover-layout-p nil
    "Wether recovers the layout.")

  (defun restore-previous-session ()
    "Restore the previous session."
    (interactive)
    (when (bound-and-true-p persp-mode)
      (restore-session persp-auto-save-fname)))

  (defun restore-session (fname)
    "Restore the specified session."
    (interactive (list (read-file-name "Load perspectives from a file: "
				       persp-save-dir)))
    (when (bound-and-true-p persp-mode)
      (message "Restoring session...")
      (quit-window t)
      (condition-case-unless-debug err
	  (persp-load-state-from-file fname)
	(error "Error: Unable to restore session -- %s" err))
      (message "Done")))

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

(provide 'init-config)


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; init-config.el ends here
