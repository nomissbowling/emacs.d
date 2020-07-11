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
   🐳 Pinky: _h_._l_._j_._k_._a_._e_._SPC_._b_._g_._G_._o_._@_  zoom:_<__-__>_  window:_0_._1_._2_._3_._x_._S_  buffer:_[__:__/__]_  🐾 _f_ile _d_iff _s_wiper"
   ("h" backward-char)
   ("j" next-line)
   ("k" previous-line)
   ("l" forward-char)
   ("<left>" backward-char)
   ("<down>" next-line)
   ("<up>" previous-line)
   ("<right>" forward-char)
   ("a" seq-home)
   ("e" seq-end)
   ("SPC" scroll-up-command)
   ("b" scroll-down-command)
   ("<next>" scroll-up-command)
   ("<prior>" scroll-down-command)
   ("g" beginning-of-buffer)
   ("<end>" end-of-buffer)
   ("G" end-of-buffer)
   ("o" other-window-or-split)
   ("@" recenter-top-bottom)
   ("s" swiper-migemo-or-region)
   ("S" window-swap-states)
   ("w" clipboard-kill-ring-save)
   ("/" kill-buffer)
   ("d" vc-diff)
   ("f" counsel-find-file)
   ("0" delete-window)
   ("1" delete-other-windows)
   ("2" split-window-below)
   ("3" split-window-right)
   ("x" window-toggle-division)
   ("[" iflipb-previous-buffer)
   ("]" iflipb-next-buffer)
   (">" text-scale-increase)
   ("<" text-scale-decrease)
   ("-" (text-scale-set 0))
   (":" counsel-switch-buffer)
   ("<henkan>" nil)
   ("<muhenkan>" nil))

  :init
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
      (other-window -1))))


(leaf sequential-command-config
  :hook (after-init-hook . sequential-command-setup-keys)
  :bind (("C-a" . seq-home)
	 ("C-e" . seq-end))
  :init
  (leaf sequential-command :ensure t))

(leaf iflipb
  :ensure t
  :config
  (setq iflipb-wrap-around t
	iflipb-ignore-buffers (list "^[*]" "^magit" "dir")))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-pinky.el ends here
