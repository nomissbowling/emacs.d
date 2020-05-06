;;; 07_ui.el --- 07_ui.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf doom-themes
  :ensure t
  :config
  (load-theme 'doom-dracula t))


(leaf doom-modeline
  :ensure t
  :hook (after-init-hook . doom-modeline-mode)
  :custom ((doom-modeline-buffer-file-name-style . 'truncate-with-project)
	   (doom-modeline-icon . t)
	   (doom-modeline-major-mode-icon . nil)
	   (doom-modeline-minor-modes . nil))
  :config
  (line-number-mode 0)
  (column-number-mode 0)
  :preface
  (leaf hide-mode-line
    :ensure t
    :hook ((neotree-mode imenu-list-minor-mode diff-mode ) . hide-mode-line-mode))
  (leaf nyan-mode
    :ensure t
    :hook (after-init-hook . nyan-mode)
    :custom
    (nyan-cat-face-number . 4)
    (nyan-animate-nyancat . t)))


;; Remove visual distractions and focus on writing
(leaf darkroom
  :el-get joaotavora/darkroom
  :bind (("<f12>" . my:darkroom-mode-in)
	 (:darkroom-mode-map
	  ("<f12>" . my:darkroom-mode-out )))
  :config
  (defun my:darkroom-mode-in ()
    "Darkroom mode in."
    (interactive)
    (display-line-numbers-mode 0)
    (flymake-mode 0)
    (darkroom-mode 1))

  (defun my:darkroom-mode-out ()
    "Darkroom mode out."
    (interactive)
    (darkroom-mode 0)
    (flymake-mode 1)
    (display-line-numbers-mode 1)))


(leaf all-the-icons
  :ensure t
  :custom (all-the-icons-scale-factor . 1.0))


(leaf all-the-icons-dired
  :ensure t
  :url "https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-dired.el"
  :hook (dired-mode-hook . all-the-icons-dired-mode)
  :custom
  ((delete-by-moving-to-trash . t)
   (dired-recursive-copies . :always)
   (dired-recursive-deletes . :always)
   ;; When dired opened in two windows, move or copy in the other dired
   (dired-dwim-target . t)
   ;; Recursively copy directory
   (dired-recursive-copies . :always))
  :config
  (advice-add #'all-the-icons-dired--display
	      :override #'my:all-the-icons-dired--display)
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
	    (forward-line 1)))))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 07_ui.el ends here
