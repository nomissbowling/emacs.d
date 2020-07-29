;;; 50_view-mode.el --- 50_view-mode.el
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
   (define-key view-mode-map ":" 'View-exit)
   (define-key view-mode-map "g" 'beginning-of-buffer)
   (define-key view-mode-map "G" 'end-of-buffer)
   (define-key view-mode-map "e" 'seq-end)
   (define-key view-mode-map "a" 'seq-home)
   (define-key view-mode-map "c" 'avy-goto-char-2)
   (define-key view-mode-map "b" 'scroll-down-command)
   (define-key view-mode-map "D" 'my:view-kill-whole-line)
   ;; (define-key view-mode-map "u" 'my:view-undo)
   ;; (define-key view-mode-map "X" 'my:view-del-char)
   (define-key view-mode-map "w" 'my:view-forward-word+1)
   (define-key view-mode-map "W" 'backward-word)
   (define-key view-mode-map "s" 'swiper-or-region)
   (define-key view-mode-map "[" 'forward-list)
   (define-key view-mode-map "]" 'backward-list)
   (define-key view-mode-map "l" 'avy-goto-line)
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
   (define-key view-mode-map "S" 'counsel-switch-buffer)
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
(defun my:view-undo ()
  "Undo in view mode."
  (interactive)
  (view-mode 0)
  (undo)
  (save-buffer)
  (view-mode 1)
  (message "undo and save!"))


;; hydra-view-mode
(defhydra hydra-view-mode (:color pink :hint nil)
  "
 🐳 View-mode Function:
  _SPC_: next page       _a_: top of line       _<__-__>_: text-scale       _o_: other-window     _0_: delete-window
    _b_: prev page       _e_: end of line       _w_: forward word^^^^       _t_: direx:tree       _1_: del-other-windows
    _g_: page top        _l_: goto line         _W_: backward word^^^^      _:_: view exit        _d_: vc-diff
    _G_: page end        _n_: diff-next-hunk    _[_: forward pair^^^^       _v_: view mode        _s_: swiper
    _;_: recenter        _p_: diff-prev-hunk    _]_: backward pair^^^^      _._: close            _S_: switch-buffer"
  ;; Move page
  ("SPC" scroll-up-command)
  ("b" scroll-down-command)
  ("c" avy-goto-char-2)
  ("g" beginning-of-buffer)
  ("G" end-of-buffer)
  ;; Move line
  ("a" seq-home)
  ("e" seq-end)
  ("w" my:view-forward-word+1)
  ("W" backward-word)
  ;; ("D" my:view-kill-whole-line)
  ;; ("X" my:view-del-char)
  ;; ("u" my:view-undo)
  ;; Misc
  (":" View-exit :exit t)
  ("v" view-mode)
  ("[" forward-list)
  ("]" backward-list)
  ("l" avy-goto-line)
  (";" recenter-top-bottom)
  ;;window
  (">" text-scale-increase)
  ("<" text-scale-decrease)
  ("-" (text-scale-set 0))
  ("0" delete-window)
  ("1" delete-other-windows)
  ("d" vc-diff :exit t)
  ("n" diff-hl-next-hunk)
  ("p" diff-hl-previous-hunk)
  ("s" swiper-or-region)
  ("S" counsel-switch-buffer)
  ;; Others
  ("o" other-window-or-split :exit t)
  ("t" direx:jump-to-project-directory)
  ("s" swiper-or-region)
  ("." nil :color blue))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 50_view-mode.el ends here
