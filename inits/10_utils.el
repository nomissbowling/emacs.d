;;; 10_utils.el --- 10_utils.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; Emacs on WSL open links in Windows web browser
;; https://adam.kruszewski.name/2017/09/emacs-in-wsl-and-opening-links/
(when (getenv "WSLENV")
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
	(cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
	    browse-url-generic-args     cmd-args
	    browse-url-browser-function 'browse-url-generic
	    search-web-default-browser 'browse-url-generic))))

;; Output PDF from text file
(setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | ps2pdf - %s")
(defun my:pdfout-region (begin end)
  "PDF out from BEGIN to END of region."
  (interactive "r")
  (shell-command-on-region begin end (format my:pdfout-command-format
					     (concat (read-from-minibuffer "File name:") ".pdf"))))
(defun my:pdfout-buffer ()
  "PDF out from buffer."
  (interactive)
  (my:pdfout-region (point-min) (point-max)))

;; Open application
(bind-key*
 [f4]
 (defun term-current-dir-open ()
   "Open terminal application in current dir."
   (interactive)
   (let ((dir (directory-file-name default-directory)))
     (shell-command (concat "gnome-terminal --working-directory " dir)))))
(bind-key
 [f3]
 (defun filer-current-dir-open ()
   "Open filer in current dir."
   (interactive)
   (shell-command (concat "xdg-open " default-directory))))

;; Automatic deletion for empty files (Valid in all modes)
;; https://uwabami.github.io/cc-env/Emacs.html#org57f6557
(defun my:delete-file-if-no-contents ()
  "Automatic deletion for empty files."
  (when (and (buffer-file-name (current-buffer))
             (= (point-min) (point-max)))
    (delete-file
     (buffer-file-name (current-buffer)))))
(if (not (memq 'my:delete-file-if-no-contents after-save-hook))
    (setq after-save-hook
          (cons 'my:delete-file-if-no-contents after-save-hook)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_utils.el ends here
