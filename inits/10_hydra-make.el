;;; 10_hydra-make.el --- 10_hydra-make.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf *hydra-compile
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
   ("q" my:make-quit)))

;; make functions corresponding to the makefile
(leaf *user-make-function
  :init
  (setq compilation-always-kill t)
  :config
  (defun my:make-k ()
    "Make command default."
    (interactive)
    (compile "make -k"))

  (defun my:make-upftp ()
    "Make command for upftp."
    (interactive)
    (compile "make up"))

  (defun my:make-move ()
    "Make command for move."
    (interactive)
    (compile "make mv"))

  (defun my:make-bklog ()
    "Make command for bklog."
    (interactive)
    (compile "make bk"))

  (defun my:make-git ()
    "Make command for git."
    (interactive)
    (compile "make git"))

  (defun my:make-clean ()
    "Make command for clean."
    (interactive)
    (compile "make clean"))

  (defun my:make-quit ()
    "Make command for clean."
    (interactive)
    (setq compile-command "make -k")
    (delete-other-windows)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-make.el ends here
