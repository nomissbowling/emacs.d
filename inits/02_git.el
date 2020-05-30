;;; 02_git.el --- 02_git.el  -*- lexical-binding: t -*-

;; git porcelain inside emacs

;;; Code:
;; (setq debug-on-erro t)

(leaf magit
  :ensure t
  :bind (("C-x g" . magit-status)
	 ("C-x m" . hydra-magit/body))
  :config
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
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

(leaf diff-hl
  :ensure t
  :hook ((after-init-hook . global-diff-hl-mode)
	 (magit-post-refresh-hook . diff-hl-magit-post-refresh))
  :config (diff-hl-margin-mode))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 02_git.el ends here
