;;; 20_utils.el --- 20_utils.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf migemo
  :ensure t
  :when (executable-find "cmigemo")
  :hook (after-init-hook . migemo-init)
  :custom ((migemo-command . "cmigemo")
	   (migemo-dictionary . "/usr/share/cmigemo/utf-8/migemo-dict")))


(leaf imenu-list
  :ensure t
  :bind (("<f10>" . imenu-list-smart-toggle))
  :custom ((imenu-list-size . 30)
	   (imenu-list-position . 'left))
  :config
  (leaf counsel-css
    :ensure
    :hook (css-mode-hook . #'counsel-css-imenu-setup)))


(leaf browse-at-remote
  :ensure t
  :config
  (defalias 'my:github-show 'browse-at-remote))


(leaf *user-utils-function
  :config
  ;; current dir open of linux-filer
  (bind-key "<f3>" 'filer-current-dir-open)
  (defun filer-current-dir-open ()
    "Open filer in current dir."
    (interactive)
    (shell-command (concat "xdg-open " default-directory)))

  ;; current dir open of linux terminal
  (bind-key "<f4>" 'term-current-dir-open)
  (defun term-current-dir-open ()
    "Open terminal application in current dir."
    (interactive)
    (let ((dir (directory-file-name default-directory)))
      (shell-command (concat "gnome-terminal --working-directory " dir))))

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
