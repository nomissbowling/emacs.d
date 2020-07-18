;;; init.el --- init.el  -*- lexical-binding: t -*-
;; emacs-initial-setting

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  (defvar default-file-name-handler-alist file-name-handler-alist)
  (setq file-name-handler-alist nil)
  (setq gc-cons-threshold 100000000)
  (add-hook 'emacs-startup-hook
	    (lambda ()
	      "Restore defalut values after startup."
	      (setq file-name-handler-alist default-file-name-handler-alist)
	      (setq gc-cons-threshold 800000)))

  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
		       ("melpa" . "https://melpa.org/packages/")
		       ("gnu"   . "https://elpa.gnu.org/packages/")))


  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))


  (leaf leaf-keywords
    :ensure t
    :init
    (leaf bind-key :ensure t)
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    :config
    (leaf-keywords-init))

  (leaf init-loader :ensure t
    :init
    (setq load-prefer-newer t)
    (setq el-get-dir "~/.emacs.d/elisp")
    :config
    (custom-set-variables

     '(init-loader-show-log-after-init 'error-only))
    (init-loader-load "~/Dropbox/emacs.d/inits")
    (setq custom-file (locate-user-emacs-file "custom.el")))

  (leaf *user-emacs-init-time
    :hook (after-init-hook . my:emacs-init-time)
    :init
    (defun my:emacs-init-time ()
      "Emacs booting time in msec."
      (message "Emacs booting time: %.0f [msec] = `emacs-init-time'."
	       (* 1000
		  (float-time (time-subtract
			       after-init-time
			       before-init-time)))))

    (with-eval-after-load "time"
      (defun ad:emacs-init-time ()
	"Return a string giving the duration of the Emacs initialization."
	(interactive)
	(let ((str
	       (format "%.3f seconds"
		       (float-time
			(time-subtract after-init-time before-init-time)))))
	  (if (called-interactively-p 'interactive)
	      (message "%s" str)
	    str)))
      (advice-add 'emacs-init-time :override #'ad:emacs-init-time))))


(provide 'init)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; init.el ends here
