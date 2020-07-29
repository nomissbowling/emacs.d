;;; 10_hydra-pinky.el --- 10_hydra-pinky.el
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf *hydra-pinky
  :config
  (bind-key "C-q" 'other-window-or-split)
  (bind-key "<henkan>" 'hydra-pinky/body)
  (key-chord-define-global "jk" 'hydra-pinky/body)
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


(leaf key-chord
  :el-get zk-phi/key-chord
  :config
  (key-chord-mode 1)
  (key-chord-define-global "df" 'counsel-descbinds)
  (key-chord-define-global "l;" 'init-loader-show-log))


(leaf sequential-command-config
  :hook (emacs-startup-hook . sequential-command-setup-keys)
  :config
  (bind-key "C-a" 'seq-home)
  (bind-key "C-e" 'seq-end)
  :init
  (leaf sequential-command
    :el-get HKey/sequential-command))


(leaf iflipb
  :ensure t
  :config
  (bind-key "M-]" 'iflipb-next-buffer)
  (bind-key "M-[" 'iflipb-previous-buffer)
  (setq iflipb-wrap-around t)
  (setq iflipb-ignore-buffers (list "^[*]" "^magit" "dir" ".org")))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-pinky.el ends here
