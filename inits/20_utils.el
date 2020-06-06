;;; 20_utils.el --- 20_utils.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf migemo
  :ensure t
  :when (executable-find "cmigemo")
  :hook (after-init-hook . migemo-init)
  :config
  (setq migemo-command (executable-find "cmigemo")
	migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (autoload 'migemo-init "migemo" nil t))

(leaf imenu-list
  :ensure t
  :bind (("C-c i" . imenu-list-smart-toggle))
  :config
  (setq imenu-list-size 30
	imenu-list-position 'left
	imenu-list-focus-after-activation t)
  :init
  (leaf counsel-css
    :ensure
    :hook (css-mode-hook . #'counsel-css-imenu-setup)))

(leaf browse-at-remote
  :ensure t
  :config
  (defalias 'my:github-show 'browse-at-remote))

(leaf *user-utils-function
  :config
  (defun filer-current-dir-open ()
    "Open filer in current dir."
    (interactive)
    (shell-command (concat "xdg-open " default-directory)))
  (bind-key "<f3>" 'filer-current-dir-open)

  (defun term-current-dir-open ()
    "Open terminal application in current dir."
    (interactive)
    (let ((dir (directory-file-name default-directory)))
      (shell-command (concat "gnome-terminal --working-directory " dir))))
  (bind-key "<f4>" 'term-current-dir-open)

  (leaf calendar
    :bind (([f7] . calendar)
  	   (:calendar-mode-map
  	    ("h" . calendar-forward-week)
  	    ("l" . calendar-backward-week)
  	    ("j" . calendar-forward-day)
  	    ("k" . calendar-backward-day)
  	    ([f7] . calendar-exit)))
    :config
    (leaf japanese-holidays
      :ensure t
      :require t
      :after calendar
      :config
      (setq calendar-holidays
	    (append japanese-holidays holiday-local-holidays holiday-other-holidays))
      (setq calendar-mark-holidays-flag t)
      ;; display Saturday and Sunday as a holiday
      (setq japanese-holiday-weekend '(0 6)
	    japanese-holiday-weekend-marker
	    '(holiday nil nil nil nil nil japanese-holiday-saturday))
      (add-hook 'calendar-today-visible-hook 'japanese-holiday-mark-weekend)
      (add-hook 'calendar-today-invisible-hook 'japanese-holiday-mark-weekend)
      ;; mark the today
      (add-hook 'calendar-today-visible-hook 'calendar-mark-today)
      ;; view holiday in org-agenda
      (setq org-agenda-include-diary t)))

  ;; delete file if no contents
  (defun my:delete-file-if-no-contents ()
    (when (and (buffer-file-name (current-buffer))
	       (= (point-min) (point-max)))
      (delete-file
       (buffer-file-name (current-buffer)))))
  (if (not (memq 'my:delete-file-if-no-contents after-save-hook))
      (setq after-save-hook
	    (cons 'my:delete-file-if-no-contents after-save-hook)))

  ;; pdf out from emacs
  (setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | ps2pdf - %s")
  (defun my:pdfout-buffer ()
    "PDF out from buffer."
    (interactive)
    (my:pdfout-region (point-min) (point-max)))
  (defun my:pdfout-region (begin end)
    "PDF out from BEGIN to END of region."
    (interactive "r")
    (shell-command-on-region begin end (format my:pdfout-command-format
					       (concat (read-from-minibuffer "File name:") ".pdf")))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 20_utils.el ends here
