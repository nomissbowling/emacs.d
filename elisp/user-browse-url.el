;;; user-brouse-url.el -*- lexical-binding: t -*-
;; open user directory

;;; Code:
;; (setq debug-on-error t)

(defun browse-calendar ()
  "Open Google-calendar with chrome."
  (interactive)
  (browse-url "https://calendar.google.com/calendar/r"))

(defun browse-weather ()
  "Open tenki.jp with chrome."
  (interactive)
  (browse-url "https://tenki.jp/week/6/31/"))

(defun browse-google-news ()
  "Open Google-news with chrome."
  (interactive)
  (browse-url "https://news.google.com/topstories?hl=ja&gl=JP&ceid=JP:ja"))

(defun browse-pocket ()
  "Open pocket with chrome."
  (interactive)
  (browse-url "https://getpocket.com/a/queue/"))

(defun browse-keep ()
  "Open pocket with chrome."
  (interactive)
  (browse-url "https://keep.new/"))

(defun browse-homepage ()
  "Open my homepage."
  (interactive)
  (browse-url "https://gospel-haiku.com/update/"))

(defun browse-gmail ()
  "Open gmail with chrome."
  (interactive)
  (browse-url "https://mail.google.com/mail/"))

(defun browse-tweetdeck ()
  "Open tweetdeck with chrome."
  (interactive)
  (browse-url "https://tweetdeck.twitter.com/"))

(defun browse-slack ()
  "Open slack with chrome."
  (interactive)
  (browse-url "https://emacs-jp.slack.com/messages/C1B73BWPJ/"))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; user-browse-url.el ends here
