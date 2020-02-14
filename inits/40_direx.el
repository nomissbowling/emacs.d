;;; 40_direx.el --- 40_direx.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Use direx.el
(use-package direx
  :config
  (setq direx:leaf-icon "  " direx:open-icon "📂" direx:closed-icon "📁")
  (push '(direx:direx-mode :position left :width 30 :dedicated t) popwin:special-display-config))

;; Use direx-project.el
;; https://blog.shibayu36.org/entry/2013/02/12/191459
(bind-key
 [f11]
 (defun direx:jump-to-project-directory ()
   "If in project, launch direx-project otherwise start direx."
   (interactive)
   (let ((result (ignore-errors
		   (direx-project:jump-to-project-root-other-window)
		   t)))
     (unless result
       (direx:jump-to-directory-other-window)))))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 40_direx.el ends here
