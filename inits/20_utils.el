;;; 20_utils.el --- 20_utils.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf migemo :ensure t
  :require t
  :when (executable-find "cmigemo")
  :config
  (setq migemo-options '("-q" "--emacs")
	migemo-command (executable-find "cmigemo")
	migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (migemo-init))


(leaf imenu-list :ensure t
  :bind (("<f2>" . imenu-list-smart-toggle))
  :config
  (setq imenu-list-size 30
	imenu-list-position 'left
	imenu-list-focus-after-activation t))


(leaf browse-at-remote :ensure t
  :config
  (defalias 'my:github-show 'browse-at-remote))


(leaf *user-utils-function
  :config
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
	    (cons 'my:delete-file-if-no-contents after-save-hook)))


  ;; pdf out from emacs
  (setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | ps2pdf - %s")
  ;; (setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | lpr")
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


;; ps-print-buffer
(leaf ps-print :ensure nil
  :config
  (setq ps-paper-type 'a4
	ps-font-size 9
	ps-printer-name nil
	ps-print-header nil
	ps-show-n-of-n t
	ps-line-number t
	ps-print-footer nil))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 20_utils.el ends here
