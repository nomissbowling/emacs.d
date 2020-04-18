;;; 10_hydra-pinky.el --- 10_hydra-pinky.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(key-chord-define-global
 "jk"
 (defhydra hydra-pinky (:color red :hint nil)
   "
 🐳 Pinky: _h_._l_._j_._k_._a_._e_._SPC_._b_._g_._G_._o_._w_._@_._s_._S_._/_._v_._f_._0_._1_._2_._3_._x_._<_._>_._:_"
   ("h" backward-char)
   ("j" next-line)
   ("k" previous-line)
   ("l" forward-char)
   ("<left>" backward-char)
   ("<down>" next-line)
   ("<up>" previous-line)
   ("<right>" forward-char)
   ("a" beginning-of-line)
   ("e" end-of-line)
   ("SPC" scroll-up-command)
   ("b" scroll-down-command)
   ("<next>" scroll-up-command)
   ("<prior>" scroll-down-command)
   ("g" beginning-of-buffer)
   ("G" end-of-buffer)
   ("o" other-window-or-split)
   ("w" avy-goto-word-1)
   ("@" recenter-top-bottom)
   ("s" swiper-isearch-region)
   ("S" window-swap-states)
   ("/" kill-buffer)
   ("v" vc-diff)
   ("f" counsel-find-file)
   ("0" delete-window)
   ("1" delete-other-windows)
   ("2" split-window-below)
   ("3" split-window-right)
   ("x" window-toggle-division)
   ("<" iflipb-next-buffer)
   (">" iflipb-previous-buffer)
   (":" counsel-switch-buffer)
   ("." view-mode)
   ("q" nil)))

(bind-key
 "C-q"
 (defun other-window-or-split ()
   "If there is one window, open split window.
If there are two or more windows, it will go to another window."
   (interactive)
   (when (one-window-p)
     (split-window-horizontally))
   (other-window 1)))
(defun window-toggle-division ()
  "Replace vertical <-> horizontal when divided into two."
  (interactive)
  (unless (= (count-windows 1) 2)
    (error "Not divided into two!"))
  (let ((before-height)
	(other-buf (window-buffer (next-window))))
    (setq before-height (window-height))
    (delete-other-windows)
    (if (= (window-height) before-height)
	(split-window-vertically)
      (split-window-horizontally))
    (other-window 1)
    (switch-to-buffer other-buf)
    (other-window -1)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_hydra-pinky.el ends here
