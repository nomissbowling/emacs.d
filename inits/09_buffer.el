;;; 09_buffer.el --- 09_buffer.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; auto-save-buffers-enhanced
(setq auto-save-buffers-enhanced-quiet-save-p t)
(auto-save-buffers-enhanced t)

;; Toggle current buffer and *scratch* buffer
(bind-key
 [S-return]
 (defun toggle-scratch()
   "Toggle current buffer and *scratch* buffer."
   (interactive)
   (if (not (string= "*scratch*" (buffer-name)))
       (progn
	 (setq toggle-scratch-prev-buffer (buffer-name))
	 (switch-to-buffer "*scratch*"))
     (switch-to-buffer toggle-scratch-prev-buffer))))

;; Set buffer that can not be killed.
(with-current-buffer "*scratch*"
  (emacs-lock-mode 'kill))
(with-current-buffer "*Messages*"
  (emacs-lock-mode 'kill))

;; automatically kill unnecessary buffers
(leaf tempbuf
  :hook
  (dired-mode-hook . turn-on-tempbuf-mode)
  (magit-mode-hook . turn-on-tempbuf-mode)
  (compilation-mode-hook . turn-on-tempbuf-mode)
  :config
  (setq tempbuf-kill-message nil))

(leaf iflipb
  :bind (("C-<right>" . iflipb-next-buffer)
	 ("C-<left>" . iflipb-previous-buffer))
  :config
  (setq iflipb-ignore-buffers (list "^[*]" "^magit" "dir"))
  (setq iflipb-wrap-around t))

(leaf *kill-buffer
  :config
  (bind-key "M-/" 'kill-buffer)
  (bind-key "C-M-/" 'kill-other-buffer)
  :preface
  (defun kill-other-buffers ()
    "Kill all other buffers."
    (interactive)
    (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
    (message "Killed other buffers!")))

;; undohist
(leaf undohist
  :hook
  (after-init-hook . undohist-initialize)
  :init
  (setq undohist-ignored-files '("/tmp" "COMMIT_EDITMSG")))

;; undo-tree
(leaf undo-tree
  :bind* (("C-_" . undo-tree-undo)
	  ("C-\\" . undo-tree-undo)
	  ("M-_" . undo-tree-redo)
	  ("M-\\" . undo-tree-redo)
	  ("C-x u" . undo-tree-visualize))
  :hook
  (prog-mode-hook . undo-tree-mode)
  (text-mode-hook . undo-tree-mode)
  :init
  (setq undo-tree-visualizer-timestamps t
	undo-tree-visualizer-diff t
	undo-tree-enable-undo-in-region nil
	undo-tree-auto-save-history nil
	undo-tree-history-directory-alist
	`(("." . ,(concat user-emacs-directory "undo-tree-hist/"))))
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

;; imenu
(leaf imenu-list
  :bind
  ("<f10>" . imenu-list-smart-toggle)
  :custom
  (imenu-list-focus-after-activation . t)
  (imenu-list-auto-resize . nil))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 09_buffer.el ends here
