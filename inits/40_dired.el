;;; 40_dired.el --- 40_dired.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(with-eval-after-load 'dired
  (bind-keys :map dired-mode-map
	     ("j" . dired-next-line)
	     ("k" . dired-previous-line)
	     ("<left>" . dired-up-alternate-directory)
	     ("<right>" . dired-open-in-accordance-with-situation)
	     ("RET" . dired-open-in-accordance-with-situation)
	     ("e" . my:dired-ediff-files)
	     ("<SPC>" . my:dired-toggle-mark)
	     ("C-g" . my:dired-unmark-all)
	     ("r" . wdired-change-to-wdired-mode)
	     ("R" . dired-rsync)
	     ("o" . dired-open-file)
	     ("O" . dired-omit-mode)
	     ("[" . dired-hide-details-mode)
	     ("a" . dired-list-all-mode)
	     ("q" . dired-dwim-quit-window)
	     ("t" . counsel-tramp)
	     ("s" . sudo-edit)
	     ("." . magit-status)))

;; Show directory first
(leaf ls-lisp :require t
  :after dired
  :config
  (setq ls-lisp-use-insert-directory-program nil ls-lisp-dirs-first t))

;; Dired-x
(leaf dired-x
  :after dired
  :config
  (setq-default dired-omit-files-p t)
  (setq dired-omit-files "^desktop.ini\\|^\\.dropbox")
  ;; zip file can be expanded with Z key
  (eval-after-load "dired-aux"
    '(add-to-list 'dired-compress-file-suffixes
		  '("\\.zip\\'" ".zip" "unzip"))))

;; Add [Dir] to the directory buffer
(defun dired-my-append-buffer-name-hint ()
  "Append a auxiliary string to a name of dired buffer."
  (when (eq major-mode 'dired-mode)
    (let* ((dir (expand-file-name list-buffers-directory))
           ;; Add a drive letter for Windows
           (drive (if (and (eq 'system-type 'windows-nt)
                           (string-match "^\\([a-zA-Z]:\\)/" dir))
                      (match-string 1 dir) "")))
      (rename-buffer (concat (buffer-name) " [" drive "dir]") t))))
(add-hook 'dired-mode-hook 'dired-my-append-buffer-name-hint)

;; Toggle listing dot files in dired
;; https://github.com/10sr/emacs-lisp/blob/master/docs/elpa/dired-list-all-mode-20161115.118.el
(leaf dired-list-all-mode :require t
  :after dired
  :config
  (setq dired-listing-switches "-lhFG"))

;; Quit-window according to screen division
(defun dired-dwim-quit-window ()
  "`quit-window 'according to screen division."
  (interactive)
  (quit-window (not (delq (selected-window) (get-buffer-window-list)))))

;; File are opened in separate buffer, directories are opened in same buffer
;; http://nishikawasasaki.hatenablog.com/entry/20120222/1329932699
(defun dired-open-in-accordance-with-situation ()
  "Files are opened in separate buffers, directories are opened in the same buffer."
  (interactive)
  (let ((file (dired-get-filename)))
    (if (file-directory-p file)
        (dired-find-alternate-file)
      (dired-find-file))))

(defun dired-up-alternate-directory ()
  "Move to higher directory without make new buffer."
  (interactive)
  (let* ((dir (dired-current-directory))
	 (up (file-name-directory (directory-file-name dir))))
    (or (dired-goto-file (directory-file-name dir))
	;; Only try dired-goto-subdir if buffer has more than one dir.
	(and (cdr dired-subdir-alist)
	     (dired-goto-subdir up))
	(progn
	  (find-alternate-file up)
	  (dired-goto-file dir)))))

(defun dired-open-file ()
  "Open file in relation to the extension."
  (interactive)
  (let ((fn (dired-get-file-for-visit)))
    (unless (getenv "WSLENV")
      (call-process "xdg-open" nil 0 nil fn))
    ;; use wsl-utils:https://github.com/smzht/wsl-utils
    (when (getenv "WSLENV")
      (call-process "wslstart" nil 0 nil fn))))

(defun my:dired-toggle-mark (arg)
  "Toggle the current (or next ARG) files."
  (interactive "p")
  (let ((dired-marker-char
	 (if (save-excursion (beginning-of-line)
			     (looking-at " "))
	     dired-marker-char ?\040)))
    (dired-mark arg)))

(defun my:dired-unmark-all ()
  "Dired unmark all."
  (interactive)
  (call-interactively 'dired-unmark-all-marks)
  (call-interactively 'revert-buffer))

;; Allow rsync from dired buffers
(leaf dired-rsync
  :bind (:dired-mode-map
	 ("C-c C-r" . dired-rsync)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Shows icons
;; Tips from https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-dired.el
(leaf all-the-icons-dired
  :commands dired-mode
  :hook
  (dired-mode-hook . all-the-icons-dired-mode)
  :custom
  ;; Dired files deleted by trash and no ask recursive
  (delete-by-moving-to-trash . t)
  (dired-recursive-copies . 'always)
  (dired-recursive-deletes . 'always)
  ;; When dired opened in two windows, move or copy in the other dired
  (dired-dwim-target . t)
  ;; Recursively copy directory
  (dired-recursive-copies . 'always)
  :config
  (defun my:all-the-icons-dired--display ()
    "Display the icons of files without colors in a dired buffer."
    (when dired-subdir-alist
      (let ((inhibit-read-only t)
	    (remote-p (and (fboundp 'tramp-tramp-file-p)
			   (tramp-tramp-file-p default-directory))))
	(save-excursion
	  ;; TRICK: Use TAB to align icons
	  (setq-local tab-width 1)
	  (goto-char (point-min))
	  (while (not (eobp))
	    (when (dired-move-to-filename nil)
	      (insert " ")
	      (let ((file (dired-get-filename 'verbatim t)))
		(unless (member file '("." ".."))
		  (let ((filename (file-local-name (dired-get-filename nil t))))
		    (if (file-directory-p filename)
			(let ((icon (cond
				     (remote-p
				      (all-the-icons-octicon "file-directory"
							     :v-adjust all-the-icons-dired-v-adjust
							     :face 'all-the-icons-dired-dir-face))
				     ((file-symlink-p filename)
				      (all-the-icons-octicon "file-symlink-directory"
							     :v-adjust all-the-icons-dired-v-adjust
							     :face 'all-the-icons-dired-dir-face))
				     ((all-the-icons-dir-is-submodule filename)
				      (all-the-icons-octicon "file-submodule"
							     :v-adjust all-the-icons-dired-v-adjust
							     :face 'all-the-icons-dired-dir-face))
				     ((file-exists-p (format "%s/.git" filename))
				      (all-the-icons-octicon "repo"
							     :height 1.1
							     :v-adjust all-the-icons-dired-v-adjust
							     :face 'all-the-icons-dired-dir-face))
				     (t (let ((matcher (all-the-icons-match-to-alist
							file all-the-icons-dir-icon-alist)))
					  (apply (car matcher)
						 (list (cadr matcher)
						       :face 'all-the-icons-dired-dir-face
						       :v-adjust all-the-icons-dired-v-adjust)))))))
			  (insert icon))
		      (insert (all-the-icons-icon-for-file file :v-adjust all-the-icons-dired-v-adjust))))
		  (insert "\t"))))   ; Align and keep one space for refeshing after operations
	    (forward-line 1))))))
  (advice-add #'all-the-icons-dired--display :override #'my:all-the-icons-dired--display))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 40_dired.el ends here
