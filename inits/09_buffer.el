;;; 09_buffer.el --- 09_buffer.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(add-hook
 'after-init-hook
 (lambda ()
   ;; automatically save buffers in a decent way
   (leaf auto-save-buffers-enhanced :ensure t
     :config
     (setq auto-save-buffers-enhanced-quiet-save-p t)
     ;; auto save *scratch* to ~/.emacs.d/scratch
     (setq auto-save-buffers-enhanced-save-scratch-buffer-to-file-p t
	   auto-save-buffers-enhanced-file-related-with-scratch-buffer
	   (locate-user-emacs-file "scratch"))
     ;; Exclusion of the auto-save-buffers
     (setq auto-save-buffers-enhanced-exclude-regexps '("^/ssh:" "^/scp:" "/sudo:"))
     (auto-save-buffers-enhanced t))


   ;; automatically deleted in the background buffers
   (leaf tempbuf
     :el-get emacswiki:tempbuf
     :require t
     :hook ((dired-mode-hook . turn-on-tempbuf-mode)
	    (magit-mode-hook . turn-on-tempbuf-mode)
	    (compilation-mode-hook . turn-on-tempbuf-mode))
     :config
     (setq tempbuf-kill-message nil))


   ;; Persistent undo history for GNU Emacs
   (leaf undohist :ensure t
     :require t
     :config
     (setq undohist-directory "~/Dropbox/dotfiles/undohist"
	   undohist-ignored-files '("/tmp/" "COMMIT_EDITMSG"))
     (undohist-initialize))


   ;; Treat undo history as a tree
   (leaf undo-tree :ensure t
     :bind* (("C-_" . undo-tree-undo)
	     ("C-\\" . undo-tree-undo)
	     ("C-/" . undo-tree-redo)
	     ("C-x u" . undo-tree-visualize))
     :hook ((prog-mode-hook . undo-tree-mode)
	    (text-mode-hook . undo-tree-mode))
     :custom
     ((undo-tree-visualizer-timestamps . t)
      (undo-tree-visualizer-diff . t)
      (undo-tree-enable-undo-in-region . nil)
      (undo-tree-auto-save-history . nil)
      (undo-tree-history-directory-alist
       . `(("." . ,(concat user-emacs-directory "undo-tree-hist/")))))
     :config
     ;; FIXME: `undo-tree-visualizer-diff' is a local variable in *undo-tree* buffer.
     (defun undo-tree-visualizer-show-diff (&optional node)
       ;; show visualizer diff display
       (setq-local undo-tree-visualizer-diff t)
       (let ((buff (with-current-buffer undo-tree-visualizer-parent-buffer
		     (undo-tree-diff node)))
	     (display-buffer-mark-dedicated 'soft)
	     win)
	 (setq win (split-window))
	 (set-window-buffer win buff)
	 (shrink-window-if-larger-than-buffer win)))

     (defun undo-tree-visualizer-hide-diff ()
       ;; hide visualizer diff display
       (setq-local undo-tree-visualizer-diff nil)
       (let ((win (get-buffer-window undo-tree-diff-buffer-name)))
	 (when win (with-selected-window win (kill-buffer-and-window))))))


   (leaf *user-buffer-functions
     :bind (([S-return] . toggle-scratch)
	    ("M-/" . kill-buffer))
     :init
     (defun toggle-scratch ()
       "Toggle current buffer and *scratch* buffer."
       (interactive)
       (if (not (string= "*scratch*" (buffer-name)))
	   (progn
	     (setq toggle-scratch-prev-buffer (buffer-name))
	     (switch-to-buffer "*scratch*"))
	 (switch-to-buffer toggle-scratch-prev-buffer)))

     ;; kill-oter-buffers
     (defun kill-other-buffers ()
       "Kill all other buffers."
       (interactive)
       (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
       (when (get-buffer "*tramp/scp xsrv*")
	 (counsel-tramp-quit))
       (message "Killed Other Buffers!")))

   ))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 09_buffer.el ends here
