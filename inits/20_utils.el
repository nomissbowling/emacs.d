;;; 20_utils.el --- 20_utils.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf migemo
  :when (executable-find "cmigemo")
  :hook (after-init-hook . migemo-init)
  :config
  (setq migemo-command (executable-find "cmigemo"))
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict"))

(leaf *e2ps			;
  :url "https://yohgami.hateblo.jp/entry/20130402/1364895193"
  :config
  (setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | ps2pdf - %s")
  :preface
  (defun my:pdfout-buffer ()
    "PDF out from buffer."
    (interactive)
    (my:pdfout-region (point-min) (point-max)))
  (defun my:pdfout-region (begin end)
    "PDF out from BEGIN to END of region."
    (interactive "r")
    (shell-command-on-region begin end (format my:pdfout-command-format
					       (concat (read-from-minibuffer "File name:") ".pdf")))))

(leaf *open-application
  :bind (("<f3>" . filer-current-dir-open)
	 ("<f4>" . term-current-dir-open))
  :preface
  (defun filer-current-dir-open ()
    "Open filer in current dir."
    (interactive)
    (shell-command (concat "xdg-open " default-directory)))
  (defun term-current-dir-open ()
    "Open terminal application in current dir."
    (interactive)
    (let ((dir (directory-file-name default-directory)))
      (shell-command (concat "gnome-terminal --working-directory " dir)))))

(leaf *delete-file-if-no-contents
  :url "https://uwabami.github.io/cc-env/Emacs.html#org57f6557"
  :preface
  (defun my:delete-file-if-no-contents ()
    (when (and (buffer-file-name (current-buffer))
	       (= (point-min) (point-max)))
      (delete-file
       (buffer-file-name (current-buffer)))))
  :config
  (if (not (memq 'my:delete-file-if-no-contents after-save-hook))
      (setq after-save-hook
            (cons 'my:delete-file-if-no-contents after-save-hook))))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 20_utils.el ends here
