;;; 02_git.el --- 02_git.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf magit
  :bind (("<f8>" . magit-status)
	 ("<f7>" . hydra-magit/body))
  :custom
  (magit-auto-revert-mode . nil)
  (magit-display-buffer-function . #'magit-display-buffer-fullframe-status-v1)
  :config
  (leaf git-timemachine
    :after magit)
  (defhydra hydra-magit (:color red :hint nil)
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
