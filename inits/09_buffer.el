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

(prog1 "Kill-buffer"
  (leaf bind-key
    :bind (("M-/" . kill-buffer)
	   ("C-M-/" . kill-other-buffer))
    :config
    (defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
      (message "Killed other buffers!"))))

;; Assign ibuffer to C-x C-b
(leaf ibuffer
  :bind (("C-x C-b" . ibuffer-other-window)
	 (:ibuffer-mode-map
	  ("C-x C-f" . counsel-find-file)))
  :config
  (when (display-graphic-p)
    ;; For alignment, the size of the name field should be the width of an icon
    (define-ibuffer-column icon (:name "  ")
      (let ((icon (if (and (buffer-file-name)
			   (all-the-icons-auto-mode-match?))
		      (all-the-icons-icon-for-file (file-name-nondirectory (buffer-file-name)) :v-adjust -0.05)
		    (all-the-icons-icon-for-mode major-mode :v-adjust -0.05))))
	(if (symbolp icon)
	    (setq icon (all-the-icons-faicon "file-o" :face 'all-the-icons-dsilver :height 0.8 :v-adjust 0.0))
	  icon)))
    (setq ibuffer-formats `((mark modified read-only , 'locked "";; (if emacs/>=26p 'locked "")
				  ;; Here you may adjust by replacing :right with :center or :left
				  ;; According to taste, if you want the icon further from the name
				  " " (icon 2 2 :left :elide)
				  ,(propertize " " 'display `(space :align-to 8))
				  (name 18 18 :left :elide)
				  " " (size 9 -1 :right)
				  " " (mode 16 16 :left :elide) " " filename-and-process)
			    (mark " " (name 16 -1) " " filename)))))

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
