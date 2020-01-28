;;; 10_wsl.el --- 10_wsl.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs on WSL open links in Windows web browser
;; https://adam.kruszewski.name/2017/09/emacs-in-wsl-and-opening-links/
(when (getenv "WSLENV")
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
	(cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
	    browse-url-generic-args     cmd-args
	    browse-url-browser-function 'browse-url-generic
	    search-web-default-browser 'browse-url-generic
	    ))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dired-open with windows application
;; use wsl-utils:https://github.com/smzht/wsl-utils
(when (getenv "WSLENV")
  (use-package dired-open)
  (setq dired-open-extensions
	'(("html" . "wslstart")
	  ("htm" . "wslstart"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Font setting corresponding to Host
(when (getenv "WSLENV")
  (if (string-match "e590" (shell-command-to-string "uname -n"))
      (add-to-list 'default-frame-alist '(font . "Cica-17.5")))
  (if (string-match "x250" (shell-command-to-string "uname -n"))
      (add-to-list 'default-frame-alist '(font . "Cica-14.5"))))


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_wsl.el ends here
