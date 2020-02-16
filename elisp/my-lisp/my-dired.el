;;; my-dired.el --- Emacs Lisp
;;; Commentary:
;;; Code:

;; The diay of the week written in English
(setq system-time-locale "C")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; My dired

(defun my:dot-emacs-dir ()
  "Open dot-emacs dir."
  (interactive)
  (find-file "~/.emacs.d/"))
(defun my:dropbox ()
  "Open dropbox dir."
  (interactive)
  (find-file "~/Dropbox/"))
(defun my:documents ()
  "Open documents dir."
  (interactive)
  (find-file "~/Dropbox/Documents/"))
(defun my:www-dir ()
  "Open Web dir."
  (interactive)
  (find-file "~/Dropbox/web/"))
(defun my:emacs-dir ()
  "Open emacs.d dir."
  (interactive)
  (find-file "~/Dropbox/emacs.d/"))
(defun my:gh-dir ()
  "Open GH dir."
  (interactive)
  (find-file "~/Dropbox/GH/"))
(defun my:inits-dir ()
  "Open inits dir."
  (interactive)
  (find-file "~/Dropbox/emacs.d/inits/"))
(defun my:otibo ()
  "Open otibo dir."
  (interactive)
  (find-file "~/Dropbox/GH/otibo/tex/otibo.txt")
  (goto-char (point-min)))
(defun my:diary ()
  "Open diary dir."
  (interactive)
  (find-file "~/Dropbox/GH/dia/diary.txt")
  (goto-char (point-min)))
(defun my:d_kukai ()
  "Open dkukai minoru_seq file."
  (interactive)
  (find-file "~/Dropbox/GH/d_select/tex/minoru_sen.txt")
  (goto-char (point-min)))
(defun my:m_kukai ()
  "Open mkukai minoru_sen file."
  (interactive)
  (find-file "~/Dropbox/GH/m_select/tex/mkukai.txt")
  (goto-char (point-min)))
(defun my:swan ()
  "Open swan minoru_sen file."
  (interactive)
  (find-file "~/Dropbox/GH/swan/tex/swan.txt")
  (goto-char (point-min)))
(defun my:teirei ()
  "Open teirei minoru_sen file."
  (interactive)
  (find-file "~/Dropbox/GH/teirei/tex/teirei.txt")
  (goto-char (point-min)))
(defun my:kinnei ()
  "Open kinnei file."
  (interactive)
  (find-file "~/Dropbox/GH/kinnei/kinnei.txt")
  (goto-char (point-min)))
(defalias 'my:github-show 'browse-at-remote)

(provide 'my-dired)
;; Local Variables:
;; no-byte-compile: t
;; End:
;;; my-dired.el ends here
