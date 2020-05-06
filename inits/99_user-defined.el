;;; 99_user-defined.el -*- lexical-binding: t -*-
;; user-defined functions that are outer package independent
;;; Code:
;; (setq debug-on-error t)

;; Functions to open any working directory
(leaf *user-open-dir-function
  :config
  (defun my:dot-emacs-dir ()
    "Open dot-emacs dir."
    (interactive)
    (find-file "~/.emacs.d/"))
  (defun my:dropbox ()
    "Open dropbox dir."
    (interactive)
    (find-file "~/Dropbox/"))
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
  (defun my:apsh ()
    "Open apsh file."
    (interactive)
    (find-file "~/Dropbox/GH/apsh/apsh.txt")
    (goto-char (point-min)))
  (defun my:open-junk-file-dir ()
    "Open dot-emacs dir."
    (interactive)
    (find-file "~/Dropbox/howm/junk/"))
  )


;; Functions to insert user-template
(leaf *user-template-function
  :config
  (defun my:diary-new-post ()
    "Open diary file and insert template."
    (interactive)
    (find-file (expand-file-name "diary.txt" "~/Dropbox/GH/dia/"))
    (goto-char 0)
    ;; Insert a new date if the date has changed
    (defvar string (buffer-substring-no-properties (point-at-bol) (point-at-eol)))
    (unless (string-match (format-time-string "%Y%m:") string)
      (forward-line -1)
      (insert (format-time-string "%Y%m:\n")))
    ;; Insert template
    (goto-char (point-min))
    (forward-line)
    (insert
     ";--------------------------------------------------------\n"
     (format-time-string "*[%Y%m%d]%Y年%m月%d日\n")
     ";--------------------------------------------------------\n"
     (format-time-string "-*[%Y%m%d%H%M%S]\n")
     "-(\n\n-)\n\n")
    (forward-line -5)
    (forward-char 18))

  ;; Insert template for minoru_sen
  (defun my:teirei-new-post ()
    "Open teirei file and insert template."
    (interactive)
    (find-file "~/Dropbox/GH/teirei/tex/teirei.txt")
    (my:minoru_sen))
  (defun my:swan-new-post ()
    "Open swan file and insert template."
    (interactive)
    (find-file "~/Dropbox/GH/swan/tex/swan.txt")
    (my:minoru_sen))
  (defun my:otibo-new-post ()
    "Open otibo file and insert template."
    (interactive)
    (find-file "~/Dropbox/GH/otibo/tex/otibo.txt")
    (goto-char 0)
    ;; Insert a new date if the date has changed
    (defvar string (buffer-substring-no-properties (point-at-bol) (point-at-eol)))
    (unless (string-match (format-time-string "%Y:") string)
      (forward-line -1)
      (insert (format-time-string "%Y:\n")))
    ;; Insert template
    (goto-char (point-min))
    (forward-line)
    (insert
     (format-time-string "%Y年%m月%d日（参加者 名）\n"))
    (forward-line -1)
    (forward-char 15))

  (defun my:minoru_sen ()
    "Insert template."
    (interactive)
    (goto-char (point-min))
    (insert
     (format-time-string "%Y%m:\n")
     (format-time-string "%Y年%m月%d日（参加者 名）\n"))
    (forward-line -1)
    (forward-char 15))


  ;; Insert template for 'kinnei'
  (defun my:kinnei-new-post ()
    "Open kinnei file and insert template."
    (interactive)
    (find-file "~/Dropbox/GH/kinnei/kinnei.txt")
    (goto-char 0)
    ;; Insert a new date if the date has changed
    (defvar string (buffer-substring-no-properties (point-at-bol) (point-at-eol)))
    (unless (string-match (format-time-string "%Y:") string)
      (forward-line -1)
      (insert (format-time-string "%Y:\n")))
    ;; Insert template
    (goto-char (point-min))
    (forward-line)
    (insert
     ";-------------------------------------------------------------------\n"
     (format-time-string "*[%Y%m%d]%Y年%m月%d日\n")
     ";-------------------------------------------------------------------\n"
     (format-time-string "-*[%Y%m%d%H%M%S]\n")
     "-(\n<div class=\"vertical\">\n"
     "<p style=\"letter-spacing:5px\">\n1\n</p>"
     "<p style=\"letter-spacing:5px\">\n2\n</p>"
     "<p style=\"letter-spacing:5px\">\n3\n</p>"
     "<p style=\"letter-spacing:5px\">\n4\n</p>"
     "<p style=\"letter-spacing:5px\">\n5\n</p>"
     "<p style=\"letter-spacing:5px\">\n6\n</p>"
     "<p style=\"letter-spacing:5px\">\n7\n</p>"
     "<p style=\"letter-spacing:5px\">\n8\n</p>"
     "<p style=\"letter-spacing:5px\">\n9\n</p>\n"
     "</div>\n--\n-((\n\n-))\n-)\n\n")
    (goto-char (point-min))
    (forward-line 4)
    (forward-char 18))


  ;; Insert template for ap.txt
  (defun my:ap-new-post ()
    "Open ap file and insert template."
    (interactive)
    (goto-char (point-min))
    (forward-line)
    (insert
     ";--------------------------------------------------------------------\n"
     (format-time-string "*\n")
     ";--------------------------------------------------------------------\n"
     (format-time-string "-*[%Y%m%d%H%M%S]小路紫峡\n")
     "-(\n<small>()</small><br>\n<-mi>\n-)\n=[\n= Feedback\n-[\n\n-]\n=]\n-elink\n")
    (forward-line -14)
    (forward-char 1))

  ;; Insert template for apsh.txt
  (defun my:apsh-new-post ()
    "Open apsh file and insert template."
    (interactive)
    (find-file (expand-file-name "apsh.txt" "~/Dropbox/GH/apsh/"))
    (goto-char 0)
    ;; Insert a new date if the date has changed
    (defvar string (buffer-substring-no-properties (point-at-bol) (point-at-eol)))
    (unless (string-match (format-time-string "%Y%m:") string)
      (forward-line -1)
      (insert (format-time-string "%Y%m:\n")))
    ;; Insert template
    (goto-char (point-min))
    (forward-line)
    (insert
     ";--------------------------------------------------------------------\n"
     (format-time-string "*[%Y%m%d]%m月%d日\n")
     ";--------------------------------------------------------------------\n"
     (format-time-string "-*[%Y%m%d%H%M%S]\n")
     "<small>\n()\n</small>\n-(\n=[\n= 合評\n-[\n- 投稿いただいた記事は編集してここに転記されます。\n-]\n=]\n-)\n-elink\n")
    (forward-line -13)
    (forward-char 18)))


(provide '99_user-defined)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 99_user-defined.el ends here
