;;; 07_buffer.el --- buffer control tools  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf auto-save-buffers-enhanced
  :ensure t
  :config
  (setq auto-save-buffers-enhanced-quiet-save-p t)
  (setq auto-save-buffers-enhanced-exclude-regexps '("^/ssh:" "^/scp:" "/sudo:"))
  (auto-save-buffers-enhanced t))


(leaf persistent-scratch
  :ensure t
  :config
  (persistent-scratch-setup-default))


(leaf tempbuf
  :el-get (tempbuf
		   :url "http://www.emacswiki.org/emacs/download/tempbuf.el")
  :hook ((dired-mode-hook direx:direx-mode magit-mode compilation-mode)
		 . turn-on-tempbuf-mode)
  :config
  (setq tempbuf-kill-message nil))


(leaf iflipb
  :ensure t
  :config
  (bind-key "C-<right>" 'iflipb-next-buffer)
  (bind-key "C-<left>" 'iflipb-previous-buffer)
  :init
  (setq iflipb-wrap-around t
		iflipb-ignore-buffers (list "^[*]" "^magit" "emacs.d" "dir]$" "GH" ".org$")))


(leaf undohist
  :ensure t
  :hook (emacs-startup-hook . undohist-initialize)
  :config
  (setq undohist-directory "~/Dropbox/dotfiles/undohist"
		undohist-ignored-files '("/tmp/" "COMMIT_EDITMSG")))


(leaf undo-tree
  :ensure t
  :hook ((prog-mode-hook text-mode-hook) . undo-tree-mode)
  :config
  (bind-key* "C-_" 'undo-tree-undo)
  (bind-key* "C-\\" 'undo-tree-undo)
  (bind-key* "C-/" 'undo-tree-redo)
  (bind-key* "C-x u" 'undo-tree-visualize)
  :init
  (setq undo-tree-visualizer-timestamps t
		undo-tree-visualizer-diff t
		undo-tree-enable-undo-in-region nil
		undo-tree-auto-save-history nil
		undo-tree-history-directory-alist
		`(("." . ,(concat user-emacs-directory "undo-tree-hist/"))))

  ;; show visualizer diff display
  (defun undo-tree-visualizer-show-diff (&optional node)
  	(setq-local undo-tree-visualizer-diff t)
  	(let ((buff (with-current-buffer undo-tree-visualizer-parent-buffer
  				  (undo-tree-diff node)))
  		  (display-buffer-mark-dedicated 'soft)
  		  win)
  	  (setq win (split-window))
  	  (set-window-buffer win buff)
  	  (shrink-window-if-larger-than-buffer win)))

  ;; hide visualizer diff display
  (defun undo-tree-visualizer-hide-diff ()
    (setq-local undo-tree-visualizer-diff nil)
    (let ((win (get-buffer-window undo-tree-diff-buffer-name)))
      (when win (with-selected-window win (kill-buffer-and-window))))))


(leaf user-buffer-functions
  :config
  (bind-key [S-return] 'toggle-scratch)
  (bind-key "M-/" 'kill-buffer)
  :init
  (defun toggle-scratch ()
    "Toggle current buffer and *scratch* buffer."
    (interactive)
    (if (not (string= "*scratch*" (buffer-name)))
		(progn
		  (setq toggle-scratch-prev-buffer (buffer-name))
		  (switch-to-buffer "*scratch*"))
      (switch-to-buffer toggle-scratch-prev-buffer)))

  (defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
    (when (get-buffer "*tramp/scp xsrv*")
      (counsel-tramp-quit))
    (message "Killed Other Buffers!")))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 07_buffer.el ends here
