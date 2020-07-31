;;; 10_view-mode.el --- 10_view-mode.el
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(leaf viewer :ensure t
  :config
  (when (require 'viewer nil t)
    (viewer-change-modeline-color-setup)
    (setq viewer-modeline-color-view "#852941")))


(bind-key "C-c v" 'view-mode)
(add-hook
 'view-mode-hook
 (lambda ()
   (define-key view-mode-map "i" 'View-exit)
   (define-key view-mode-map "," 'View-exit)
   (define-key view-mode-map "q" 'View-exit)
   (define-key view-mode-map "g" 'beginning-of-buffer)
   (define-key view-mode-map "G" 'end-of-buffer)
   (define-key view-mode-map "e" 'seq-end)
   (define-key view-mode-map "a" 'seq-home)
   (define-key view-mode-map "b" 'scroll-down-command)
   (define-key view-mode-map "D" 'my:view-kill-whole-line)
   (define-key view-mode-map "u" 'my:view-undo)
   (define-key view-mode-map "X" 'my:view-del-char)
   (define-key view-mode-map "w" 'my:view-forward-word+1)
   (define-key view-mode-map "W" 'backward-word)
   (define-key view-mode-map "l" 'goto-line)
   (define-key view-mode-map ";" 'recenter-top-bottom)
   (define-key view-mode-map "t" 'direx:jump-to-project-directory)
   (define-key view-mode-map "o" 'other-window-or-split)
   (define-key view-mode-map ">" 'text-scale-increase)
   (define-key view-mode-map "<" 'text-scale-decrease)
   (define-key view-mode-map "-" '(text-scale-set 0))
   (define-key view-mode-map "0" 'delete-window)
   (define-key view-mode-map "1" 'delete-other-windows)
   (define-key view-mode-map "d" 'vc-diff)
   (define-key view-mode-map "n" 'diff-hl-next-hunk)
   (define-key view-mode-map "p" 'diff-hl-previous-hunk)
   (define-key view-mode-map "s" 'swiper-or-region)
   (define-key view-mode-map ":" 'my:switch-buffer)
   (define-key view-mode-map "[" 'iflipb-previous-buffer)
   (define-key view-mode-map "]" 'iflipb-next-buffer)
   (define-key view-mode-map "." 'hydra-view-mode/body)))


;; Function to edit in view-mode
(defun my:view-forward-word+1 ()
  "Forward word+1 in view mode."
  (interactive)
  (forward-word)
  (forward-char))

(defun my:view-kill-whole-line ()
  "Kill whole line in view mode."
  (interactive)
  (view-mode 0)
  (kill-whole-line)
  (save-buffer)
  (view-mode 1)
  (message "kill-whole-line and save!"))

(defun my:view-del-char ()
  "Delete character in view mode."
  (interactive)
  (view-mode 0)
  (delete-char 1)
  (save-buffer)
  (view-mode 1)
  (message "delete-char"))

(defun my:switch-buffer ()
  "Hoge."
  (interactive)
  (counsel-switch-buffer)
  (view-mode 1))

(defun my:view-undo ()
  "Undo in view mode."
  (interactive)
  (view-mode 0)
  (undo)
  (save-buffer)
  (view-mode 1)
  (message "undo and save!"))


;; hydra-view-mode
(defhydra hydra-view-mode (:color red :hint nil)
  "
  🐳 page:_SPC_:_b_:_;_  goto:_a_:_e_._l_._w_  window:_o_:_0_:___  _d_iff:_n_:_p_  zoom:_<__-__>_  buffer:_[__:__]_  _s_wiper  view-exit:_,_"
  ;; Move page
  ("SPC" scroll-up-command)
  ("f" scroll-up-command)
  ("b" scroll-down-command)
  ("g" beginning-of-buffer)
  ("G" end-of-buffer)
  ;; Move line
  ("a" seq-home)
  ("e" seq-end)
  ;; ("w" my:view-forward-word+1)
  ;; ("W" backward-word)
  ("D" my:view-kill-whole-line)
  ("X" my:view-del-char)
  ("u" my:view-undo)
  ;; Misc
  ("i" View-exit :exit t)
  ("," View-exit :exit t)
  ("q" View-exit :exit t)
  ;; ("l" goto-line)
  (";" recenter-top-bottom)
  ;;window
  (">" text-scale-increase)
  ("<" text-scale-decrease)
  ("-" (text-scale-set 0))
  ("0" delete-window)
  ("_" delete-other-windows)
  ("d" vc-diff :exit t)
  ("n" diff-hl-next-hunk)
  ("p" diff-hl-previous-hunk)
  ("s" swiper-or-region)
  ;;buffer
  (":" my:switch-buffer)
  ("[" iflipb-previous-buffer)
  ("]" iflipb-next-buffer)
  ;; avy
  ("l" avy-goto-line)
  ("w" avy-goto-word-1)
  ;; Others
  ("o" other-window-or-split)
  ("t" direx:jump-to-project-directory)
  ("s" swiper-or-region)
  ("." nil :color blue))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_view-mode.el ends here
