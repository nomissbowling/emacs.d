;;; 40_dired.el --- 40_dired.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf dired
  :bind (:dired-mode-map
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
	 ("a" . toggle-dired-listing-switches)
	 ("q" . dired-dwim-quit-window)
	 ("t" . counsel-tramp)
	 ("s" . sudo-edit)
	 ("." . magit-status))
  :hook
  (dired-mode-hook . dired-my-append-buffer-name-hint)
  :custom
  (dired-listing-switches . "-lgGhF"))

(leaf ls-lisp
  :require t
  :doc "Show directory first"
  :after dired
  :config
  (setq ls-lisp-use-insert-directory-program nil ls-lisp-dirs-first t))

(leaf dired-rsync
  :ensure t
  :doc "Allow rsync from dired buffers"
  :url "https://github.com/stsquad/dired-rsync"
  :bind (:dired-mode-map
	 ("C-c C-r" . dired-rsync)))

(leaf sudo-edit
  :ensure t
  :bind (("C-c s" . sudo-edit)))


(leaf *user-dired-function
  :config
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
    (call-interactively 'revert-buffer)))


(leaf direx
  :ensure t
  :doc "Yet another dired for tree display."
  :after popwin
  :bind (("<f11>" . direx:jump-to-project-directory)
	 (:direx:direx-mode-map
	  ("<f11>" . quit-window)))

  :config
  (setq direx:leaf-icon "  " direx:open-icon "📂" direx:closed-icon "📁")
  (push '(direx:direx-mode :position left :width 25 :dedicated t) popwin:special-display-config)

  ;; https://blog.shibayu36.org/entry/2013/02/12/191459
  (defun direx:jump-to-project-directory ()
    "If in project, launch direx-project otherwise start direx."
    (interactive)
    (let ((result (ignore-errors
		    (direx-project:jump-to-project-root-other-window)
		    t)))
      (unless result
	(direx:jump-to-directory-other-window)))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 40_dired.el ends here
