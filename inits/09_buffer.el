;;; 09_buffer.el --- 09_buffer.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf auto-save-buffers-enhanced
  :ensure t
  :custom (auto-save-buffers-enhanced-quiet-save-p . t)
  :config (auto-save-buffers-enhanced t))

(leaf tempbuf
  :require t
  :el-get emacswiki:tempbuf
  :doc "automatically kill unnecessary buffers"
  :hook ((dired-mode-hook . turn-on-tempbuf-mode)
	 (magit-mode-hook . turn-on-tempbuf-mode)
	 (compilation-mode-hook . turn-on-tempbuf-mode))
  :custom (tempbuf-kill-message . nil))

(leaf iflipb
  :ensure t
  :bind (("C-<right>" . iflipb-next-buffer)
	 ("C-<left>" . iflipb-previous-buffer))
  :custom (iflipb-wrap-around . t)
  :config (setq iflipb-ignore-buffers (list "^[*]" "^magit" "dir")))

(leaf undohist
  :ensure t
  :hook (after-init-hook . undohist-initialize)
  :custom (undohist-ignored-files . '("/tmp" "COMMIT_EDITMSG")))

(leaf undo-tree
  :el-get tarsiiformes/undo-tree
  :bind* (("C-_" . undo-tree-undo)
	  ("C-\\" . undo-tree-undo)
	  ("M-_" . undo-tree-redo)
	  ("M-\\" . undo-tree-redo)
	  ("C-x u" . undo-tree-visualize))
  :hook ((prog-mode-hook . undo-tree-mode)
	 (text-mode-hook . undo-tree-mode))
  :custom ((undo-tree-visualizer-timestamps . t)
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


(leaf kill-buffer
  :bind (("M-/" . kill-buffer)
	 ("C-M-/" . kill-other-buffer))
  :config
  (defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
    (message "Killed other buffers!")))


(leaf my:toggle-scratch
  :doc "Toggle current buffer and scratch-buffer."
  :bind ([S-return] . toggle-scratch)
  :init
  (defun toggle-scratch()
    "Toggle current buffer and *scratch* buffer."
    (interactive)
    (if (not (string= "*scratch*" (buffer-name)))
	(progn
	  (setq toggle-scratch-prev-buffer (buffer-name))
	  (switch-to-buffer "*scratch*"))
      (switch-to-buffer toggle-scratch-prev-buffer))))



;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 09_buffer.el ends here
