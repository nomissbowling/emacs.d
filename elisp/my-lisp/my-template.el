;;; my-template.el --- Emacs Lisp
;;; Commentary:
;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Insert template for diary

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
  "Open swan file and insert template."
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
  (forward-char 18))

(provide 'my-template)

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; my-template.el ends here
