;;; 40_dired.el --- 40_dired.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf dired
  :hook
  (dired-mode-hook . dired-my-append-buffer-name-hint)
  :config
  (bind-key "j" 'dired-next-line dired-mode-map)
  (bind-key "k" 'dired-previous-line dired-mode-map)
  (bind-key "<left>" 'dired-up-alternate-directory dired-mode-map)
  (bind-key "<right>" 'dired-open-in-accordance-with-situation dired-mode-map)
  (bind-key "RET"'dired-open-in-accordance-with-situation dired-mode-map)
  (bind-key "SPC" 'my:dired-toggle-mark dired-mode-map)
  (bind-key "C-g" 'my:dired-unmark-all dired-mode-map)
  (bind-key "r" 'wdired-change-to-wdired-mode dired-mode-map)
  (bind-key "o" 'dired-open-file dired-mode-map)
  (bind-key "[" 'dired-hide-details-mode dired-mode-map)
  (bind-key "a" 'toggle-dired-listing-switches dired-mode-map)
  (bind-key "q" 'dired-dwim-quit-window dired-mode-map)
  (bind-key "t" 'counsel-tramp dired-mode-map)
  (bind-key "s" 'sudo-edit dired-mode-map)
  (bind-key "." 'magit-status dired-mode-map)
  ;; Use dired as 2-screen filer
  (setq dired-dwim-target t)
  ;; Always to perform the delete/copy of directories recursively
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq dired-listing-switches "-lgGhF")
  :init
  (leaf wdired :require t)
  (leaf dired-x :require t
    :config
    (setq dired-omit-mode t)
    (setq dired-omit-files "^\\desktop.ini"))
  ;; Show directory first
  (leaf ls-lisp :require t
    :config
    (setq ls-lisp-use-insert-directory-program nil ls-lisp-dirs-first t))
  (leaf sudo-edit :ensure t))


(leaf *user-dired-extention
  :init
  ;; Switching the display and non-display of hidden files
  (defun toggle-dired-listing-switches ()
    "Toggle `dired-mode' switch between with and without 'A' option to show or hide dot files."
    (interactive)
    (progn
      (if (string-match "[Aa]" dired-listing-switches)
	  (setq dired-listing-switches "-lgGhF")
	(setq dired-listing-switches "-lgGhFA"))
      (reload-current-dired-buffer)))

  (defun reload-current-dired-buffer ()
    "Reload current `dired-mode' buffer."
    (let* ((dir (dired-current-directory)))
      (progn (kill-buffer (current-buffer))
	     (dired dir))))

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

  ;; Quit-window according to screen division
  (defun dired-dwim-quit-window ()
    "`quit-window 'according to screen division."
    (interactive)
    (quit-window (not (delq (selected-window) (get-buffer-window-list)))))

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

  ;; https://www.emacswiki.org/emacs/OperatingOnFilesInDired
  (defun dired-open-file ()
    "In dired, open the file in associated application."
    (interactive)
    (let* ((file (dired-get-filename nil t)))
      (unless (getenv "WSLENV")
	(call-process "xdg-open" nil 0 nil file))
      ;; use wsl-utils:https://github.com/smzht/wsl-utils
      (when (getenv "WSLENV")
	(call-process "wslstart" nil 0 nil fn))))

  (defun my:dired-toggle-mark (arg)
    "Toggle the current next files."
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
    (call-interactively 'revert-buffer)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 40_dired.el ends here
