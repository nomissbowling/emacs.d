;;; 10_hydra-pinky.el --- 10_hydra-pinky.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf *hydra-pinky
  :bind (("C-q" . other-window-or-split)
	 ("<henkan>" . hydra-pinky/body))
  :chord ("jk" . hydra-pinky/body)
  :hydra
  (hydra-pinky
   (:color red :hint nil)
   "
   🐳 Pinky: _h_._l_._j_._k_._a_._e_._SPC_._b_._g_._G_._o_._@_  Zoom:_<__-__>_  Window:_0_._1_._2_._3_._x_._s_  Buffer:_[__:__/__]_  🐾 _f_ile _d_iff swiper_._"
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
   ("<end>" end-of-buffer)
   ("G" end-of-buffer)
   ("o" other-window-or-split)
   ("@" recenter-top-bottom)
   ("." swiper-migemo-or-region)
   ("s" window-swap-states)
   ("/" kill-buffer)
   ("d" vc-diff)
   ("f" counsel-find-file)
   ("0" delete-window)
   ("1" delete-other-windows)
   ("2" split-window-below)
   ("3" split-window-right)
   ("x" window-toggle-division)
   ("[" winner-redo)
   ("]" winner-undo)
   (">" text-scale-increase)
   ("<" text-scale-decrease)
   ("-" (text-scale-set 0))
   (":" counsel-switch-buffer)
   ("<henkan>" nil)
   ("<muhenkan>" nil)))

;; (bind-key
;;  "<f11>"
;;  (defhydra hydra-zoom
;;    (:color red :hint nil)
;;    "
;;  📦 Zoom: _g_:in   out:_l_   _r_eset"
;;    ("g" text-scale-increase)
;;    ("l" text-scale-decrease)
;;    ("r" (text-scale-set 0))))


(leaf *window-controle-function
  :config
  (defun other-window-or-split ()
    "If there is one window, open split window.
If there are two or more windows, it will go to another window."
    (interactive)
    (when (one-window-p)
      (split-window-horizontally))
    (other-window 1))

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
