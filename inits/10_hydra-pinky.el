;;; 10_hydra-pinky.el --- 10_hydra-pinky.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  (add-hook
   'emacs-startup-hook
   (lambda ()
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


     (leaf key-chord
       :el-get zk-phi/key-chord
       :config
       (key-chord-mode 1)
       :chord (("df" . counsel-descbinds)
	       ("l;" . init-loader-show-log)))


     (leaf sequential-command-config
       :hook (after-init-hook . sequential-command-setup-keys)
       :bind (("C-a" . seq-home)
	      ("C-e" . seq-end))
       :init
       (leaf sequential-command :ensure t))


     (leaf iflipb
       :ensure t
       :bind(("M-]" . iflipb-next-buffer)
	     ("M-[" . iflipb-previous-buffer))
       :config
       (setq iflipb-wrap-around t)
       (setq iflipb-ignore-buffers (list "^[*]" "^magit" "dir" ".org")))


     (leaf *hydra-pinky
       :bind (("C-q" . other-window-or-split)
	      ("<henkan>" . hydra-pinky/body))
       :chord ("jk" . hydra-pinky/body)
       :hydra
       (hydra-pinky
	(:color red :hint nil)
	"
   🐳 Pinky: _h_._l_._j_._k_._a_._e_._SPC_._b_._o_._@_._0_._1_._2_._3_._x_._S_  diff:_n_._p_._v_  zoom:_<__-__>_  buffer:_[__:__/__]_  _f_ile  _s_wiper"
	("h" backward-char)
	("l" next-line)
	("j" previous-line)
	("k" forward-char)
	("<right>" forward-char)
	("<left>" backward-char)
	("<down>" next-line)
	("<up>" previous-line)
	("a" seq-home)
	("e" seq-end)
	("SPC" scroll-up-command)
	("b" scroll-down-command)
	("<next>" scroll-up-command)
	("<prior>" scroll-down-command)
	("<C-up>" backward-paragraph)
	("<C-down>" forward-paragraph)
	("<C-right>" right-word)
	("<C-left>" left-word)
	("n" diff-hl-next-hunk)
	("p" diff-hl-previous-hunk)
	("o" other-window-or-split)
	("@" recenter-top-bottom)
	("s" swiper-migemo-or-region)
	("S" window-swap-states)
	("w" clipboard-kill-ring-save)
	("/" kill-buffer)
	("v" vc-diff)
	("f" counsel-projectile-find-file)
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
	("<muhenkan>" nil)))

     )))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-pinky.el ends here
