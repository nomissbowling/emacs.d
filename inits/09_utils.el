;;; 09_utils.el --- 09_utils.el   -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf migemo
  :ensure t
  :if (executable-find "cmigemo")
  :config
  (setq migemo-command (executable-find "cmigemo"))
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (autoload 'migemo-init "migemo" nil t)
  (migemo-init))


(leaf imenu-list
  :ensure t
  :config
  (bind-key "<f2>" 'imenu-list-smart-toggle)
  (setq imenu-list-size 30)
  (setq imenu-list-position 'left)
  (setq imenu-list-focus-after-activation t))


(leaf sequential-command-config
  :hook (emacs-startup-hook . sequential-command-setup-keys)
  :config
  (bind-key "C-a" 'seq-home)
  (bind-key "C-e" 'seq-end)
  :init
  (leaf sequential-command
    :el-get HKey/sequential-command))


(leaf browse-at-remote
  :ensure t
  :config
  (defalias 'my:github-show 'browse-at-remote))


(leaf ps-print-setting
  :init
  (setq ps-multibyte-buffer 'non-latin-printer)
  (defalias 'ps-mule-header-string-charsets 'ignore)
  (setq ps-paper-type 'a4)
  (setq ps-font-size 9)
  (setq ps-printer-name nil)
  (setq ps-print-header nil)
  (setq ps-show-n-of-n t)
  (setq ps-line-number t)
  (setq ps-print-footer nil))


(leaf pdfout-from-emacs
  :init
  (defun pdfout-select ()
    "PDF out select menu."
    (interactive)
    (counsel-M-x "^my:pdfout "))
  (setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | ps2pdf - %s")
  (defun my:pdfout-buffer ()
    "PDF out from buffer."
    (interactive)
    (my:pdfout-region (point-min) (point-max)))
  (defun my:pdfout-region (begin end)
    "PDF out from BEGIN to END of region."
    (interactive "r")
    ;; (shell-command-on-region begin end my:pdfout-command-format)))
    (shell-command-on-region begin end (format my:pdfout-command-format
											   (concat (read-from-minibuffer "File name:") ".pdf")))))


(leaf user-functions-utils
  :init
  (defun filer-current-dir-open ()
    "Open filer in current dir."
    (interactive)
    (compile (concat "Thunar " default-directory)))
  (bind-key "<f3>" 'filer-current-dir-open)

  (defun term-current-dir-open ()
    "Open terminal application in current dir."
    (interactive)
    (let ((dir (directory-file-name default-directory)))
      (compile (concat "gnome-terminal --working-directory " dir))))
  (bind-key "<f4>" 'term-current-dir-open)

  (defun my:delete-file-if-no-contents ()
    "Automatic deletion for empty files (Valid in all modes)."
    (when (and (buffer-file-name (current-buffer))
			   (= (point-min) (point-max)))
      (delete-file
       (buffer-file-name (current-buffer)))))
  (if (not (memq 'my:delete-file-if-no-contents after-save-hook))
      (setq after-save-hook
			(cons 'my:delete-file-if-no-contents after-save-hook))))


(leaf user-browse-url
  :init
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

  (defun browse-keep ()
    "Open pocket with chrome."
    (interactive)
    (browse-url "https://keep.new/"))

  (defun browse-homepage ()
    "Open my homepage with crome."
    (interactive)
    (browse-url "https://gospel-haiku.com/"))

  (defun browse-gmail ()
    "Open gmail with chrome."
    (interactive)
    (browse-url "https://mail.google.com/mail/"))

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

;;; 09_utils.el ends here
