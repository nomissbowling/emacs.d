;;; 10_compile-command.el --- compile-command.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(bind-key
 [f2]
 (defhydra hydra-compile (:color red :hint nil)
   "
 🗿 Compile: make:_k_  _a_ll  _u_pftp  _m_ove  _b_klog  _g_it  _c_lean  _e_rror 🐾 "
   ("k" my:make-k)
   ("a" my:make-all)
   ("u" my:make-upftp)
   ("m" my:make-move)
   ("g" my:make-git)
   ("b" my:make-bklog)
   ("c" my:make-clean)
   ("e" next-error)))

;; Auto scroll with compilation
(setq compilation-scroll-output t)

;; Make Commands
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

(defun my:make-all ()
  "Make command for all."
  (interactive)
  (setq compile-command "make -k && make up")
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
  (setq compile-command "make -k"))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_compile-command.el ends here
