;;; 10_hydra-make.el --- 10_hydra-make.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf *select-compile
  :hydra
  (hydra-compile
   (:color red :hint nil)
   "
 🗿 Compile: make:_k_  _u_pftp  _m_ove  _b_klog  _g_it  _c_lean  _e_rror 🐾 "
   ("k" my:make-k)
   ("u" my:make-upftp)
   ("m" my:make-move)
   ("b" my:make-bklog)
   ("g" my:make-git)
   ("c" my:make-clean)
   ("e" next-error)
   ("<f2>" nil)
   ("q" nil)))

(leaf *make-commands
  :config
  (defun my:make-k ()
    "Make command default."
    (interactive)
    (setq compile-command "make -k")
    (my:recompile))
  (defun my:make-upftp ()
    "Make command for upftp."
    (interactive)
    (setq compile-command "make up")
    (my:recompile))
  (defun my:make-move ()
    "Make command for move."
    (interactive)
    (setq compile-command "make mv")
    (my:recompile))
  (defun my:make-bklog ()
    "Make command for bklog."
    (interactive)
    (setq compile-command "make bk")
    (my:recompile))
  (defun my:make-git ()
    "Make command for git."
    (interactive)
    (setq compile-command "make git")
    (my:recompile))
  (defun my:make-clean ()
    "Make command for clean."
    (interactive)
    (setq compile-command "make clean")
    (my:recompile))
  (defun my:recompile ()
    "Restore compile command after recompile."
    (interactive)
    (recompile)
    (setq compile-command "make -k")))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-make.el ends here
