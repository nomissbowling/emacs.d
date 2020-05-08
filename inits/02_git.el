;;; 02_git.el --- 02_git.el  -*- lexical-binding: t -*-
;;; Commentary:

;; git porcelain inside Emacs.

;;; Code:
;; (setq debug-on-erro

(leaf magit
  :ensure t
  :bind (("C-x m" . hydra-magit/body)
	 ("C-x g" . magit-status))
  :custom
  (magit-display-buffer-function . #'magit-display-buffer-fullframe-status-v1)
  :init
  (leaf git-timemachine :ensure t)

  :hydra
  (hydra-magit
   (:color red :hint nil)
   "
 📦 Git: _s_tatus  _b_lame  _t_imemachine  _d_iff"
   ("s" magit-status :exit t)
   ("b" magit-blame :exit t)
   ("t" git-timemachine :exit t)
   ("d" vc-diff)))


;; local Variables:
;; no-byte-compile: t
;; End:

;;; 02_git.el ends here
