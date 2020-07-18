;;; 40_direx.el --- 40_direx.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(add-hook
 'emacs-startup-hook
 (lambda ()
   ;; https://blog.shibayu36.org/entry/2013/02/12/191459
   (defun direx:jump-to-project-directory ()
     "If in project, launch direx-project otherwise start direx."
     (interactive)
     (let ((result (ignore-errors
		     (direx-project:jump-to-project-root-other-window)
		     t)))
       (unless result
	 (direx:jump-to-directory-other-window))))


   (defun direx:open-file ()
     "In direx, open the file in associated application."
     (interactive)
     (let* ((item (direx:item-at-point!))
	    (file (direx:item-tree item))
	    (file-full-name (direx:file-full-name file)))
       (unless (getenv "WSLENV")
	 (call-process "xdg-open" nil 0 nil file-full-name))
       ;; use wsl-utils:https://github.com/smzht/wsl-utils
       (when (getenv "WSLENV")
	 (call-process "wslstart" nil 0 nil file-full-name))))


   (leaf direx :ensure t
     :after popwin
     :bind (("<f10>" . direx:jump-to-project-directory)
	    ("C-x C-j" . direx:jump-to-project-directory)
	    (:direx:direx-mode-map
	     ("o" . direx:open-file)
	     ("SPC" . direx:find-item-other-window)
	     ("<f10>" . quit-window)))
     :config
     (setq direx:leaf-icon "  " direx:open-icon "📂" direx:closed-icon "📁")
     (push '(direx:direx-mode :position left :width 25 :dedicated t) popwin:special-display-config))

   ))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 40_direx.el ends here
