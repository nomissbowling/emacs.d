;;; user-test.el -*- lexical-binding: t -*-

;; Hack emacs-init-time. (%.1f >> %.3f)
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
  (advice-add 'emacs-init-time :override #'ad:emacs-init-time))

;; Write a trial settings


(provide 'user-test)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; user-test.el ends here

