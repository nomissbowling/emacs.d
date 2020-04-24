;;; 80_twitter.el --- 80_twitter.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;;(setq debug-on-error t)

(leaf twittering-mode
  :ensure t
  :commands twit
  :config
  (setq twittering-private-info-file
  	(expand-file-name "~/Dropbox/dotfiles/wsl/twittering-mode1.gpg"))

  ;; timeline to read on startup
  (setq twittering-initial-timeline-spec-string '(":direct_messages" ":mentions" ":home" "minoruGH"))
  (setq twittering-use-master-password t)
  (setq twittering-use-ssl t)
  (setq twittering-timer-interval 40)
  (setq twittering-convert-fix-size 48)
  (setq twittering-update-status-function 'twittering-update-status-from-pop-up-buffer)
  (setq twittering-icon-mode t)
  (setq twittering-number-of-tweets-on-retrieval 50)  ;; Tweet display count
  (setq twittering-scroll-mode nil)
  (setq twittering-pop-to-buffer-function 'pop-to-buffer)

  ;; Key bind
  (bind-key "p" 'twittering-update-status-interactive twittering-mode-map)
  (bind-key "F" 'twittering-favorite twittering-mode-map)
  (bind-key "r" 'twittering-enter twittering-mode-map)
  (bind-key "Q" 'twittering-organic-retweet twittering-mode-map)
  (bind-key "T" 'twittering-native-retweet twittering-mode-map)
  (bind-key "M" 'twittering-direct-message twittering-mode-map)
  (bind-key "." 'twittering-current-timeline twittering-mode-map) ;; Refresh
  (bind-key "<SPC>" 'twittering-kill-and-switch-to-next-timeline twittering-mode-map)
  (bind-key "b" 'twittering-kill-and-switch-to-previous-timeline twittering-mode-map)

  ;; RT format
  (setq twittering-retweet-format '(nil _ " %u QT @%s: %t"))

  ;; TL flows downward
  (setq twittering-reverse-mode t)

  ;; Display format
  (setq twittering-status-format "%i%FACE[twittering-mode-name-face]{%s(%S) %p }%FACE[twittering-mode-reply-face]{%r%R}\n%FACE[twittering-mode-text-face]{%t}\n%FACE[twittering-mode-hide-face]{%C{%m/%d %H:%M:%S}(%@)}%FACE[twittering-mode-hide-face]{  from %f%L}%FACE[twittering-mode-sepa-face]{\n\n----------------------------------------------------------\n}")

  ;; URL shortening service to j.mp
  (setq twittering-tinyurl-service 'j.mp)
  (setq twittering-bitly-login "minorugh")
  (setq twittering-bitly-api-key "R_f0b3887698d4d171004f55af6e6a199e")

  ;; look for name
  (defface twittering-mode-name-face
    '((t (:foreground "#81a2be"))) nil)
  ;; look for tweet characters
  (defface twittering-mode-text-face
    '((t (:foreground "#ffffff"))) nil)
  ;; look for date and time
  (defface twittering-mode-hide-face
    '((t (:foreground "#f0c674"))) nil)
  ;; look for in reply to
  (defface twittering-mode-reply-face
    '((t (:foreground "#b5bd68"))) nil)
  ;; look for break
  (defface twittering-mode-sepa-face
    '((t (:foreground "#969896"))) nil)

  (defadvice twittering-visit-timeline (before kill-buffer-before-visit-timeline activate)
    "Delete current TL buffer before opening new TL."
    (twittering-kill-buffer))

  (defun twittering-kill-and-switch-to-next-timeline ()
    "Open next TL of twittering-initial-timeline-spec-string."
    (interactive)
    (when (twittering-buffer-p)
      (let* ((buffer-list twittering-initial-timeline-spec-string)
	     (following-buffers (cdr (member (buffer-name (current-buffer)) buffer-list)))
	     (next (if following-buffers
		       (car following-buffers)
		     (car buffer-list))))
	(unless (eq (current-buffer) next)
	  (twittering-visit-timeline next)))))

  (defun twittering-kill-and-switch-to-previous-timeline ()
    "Open previous TL of twittering-initial-timeline-spec-string."
    (interactive)
    (when (twittering-buffer-p)
      (let* ((buffer-list (reverse twittering-initial-timeline-spec-string))
	     (preceding-buffers (cdr (member (buffer-name (current-buffer)) buffer-list)))
	     (previous (if preceding-buffers
			   (car preceding-buffers)
			 (car buffer-list))))
	(unless (eq (current-buffer) previous)
	  (twittering-visit-timeline previous)))))
  )

;; Local Variables:
;; byte-compile-warnings: (not free-vars callargs)
;; End:

;;; 80_twitter.el ends here
