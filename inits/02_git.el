;;; 02_git.el --- 02_git.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; magit
(autoload 'magit-status "magit" nil t)
(setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
(bind-key "C-x g" 'magit-status)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hydra-magit
(defhydra hydra-magit (:color red :hint nil)
  "
 📦 Git: _s_tatus  _b_lame  _t_imemachine  _d_iff"
  ("s" magit-status :exit t)
  ("b" magit-blame :exit t)
  ("t" git-timemachine :exit t)
  ("d" vc-diff))

;; local Variables:
;; no-byte-compile: t
;; End:
;;; 02_git.el ends here
