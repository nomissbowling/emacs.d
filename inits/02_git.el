;;; 02_git.el --- 02_git.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit
(autoload 'magit-status "magit" nil t)
(setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
(bind-key "C-x g" 'magit-status)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; diff-hl
(add-hook 'after-init-hook 'global-diff-hl-mode)
(add-hook 'after-init-hook 'diff-hl-margin-mode)
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hydra-magit
(defhydra hydra-magit (:color red :hint nil)
  "
 📦 Git: _s_tatus  _b_lame  _t_imemachine  hunk:_n_:_p_:_r_  _d_iff"
  ("s" magit-status :exit t)
  ("b" magit-blame :exit t)
  ("t" git-timemachine :exit t)
  ("n" diff-hl-next-hunk)
  ("p" diff-hl-previous-hunk)
  ("r" diff-hl-revert-hunk)
  ("d" vc-diff)
  ("<f3>" nil))

;; local Variables:
;; no-byte-compile: t
;; End:
;;; 02_git.el ends here
