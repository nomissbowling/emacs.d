;;; 02_git.el  --- 02_git.el   -*- lexical-binding: t -*-
;; git porcelain inside emacs

;;; Code:
;; (setq debug-on-erro t)

(leaf magit :ensure t
  :config
  (bind-key "C-x g" 'magit-status)
  (bind-key "M-g" 'hydra-magit/body)
  (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :hydra
  (hydra-magit
   (:color red :hint nil)
   "
 📦 Git: _s_tatus  _b_lame  _t_imemachine  _d_iff"
   ("s" magit-status :exit t)
   ("b" magit-blame :exit t)
   ("t" git-timemachine :exit t)
   ("d" vc-diff)
   ("<muhenkan>" nil))
  :init
  (leaf git-timemachine :ensure t)
  (leaf diff-hl :ensure t
    :config
    (global-diff-hl-mode)
    (diff-hl-margin-mode)
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 02_git.el ends here
