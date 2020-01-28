;;; 90_translate.el --- 90_translate.el
;;; Commentary:
;;; README is here : https://github.com/atykhonov/google-translate
;;; Code:
;; (setq debug-on-error t)

(use-package google-translate
  :bind ("C-t" . google-translate-auto)
  :config
  (defun google-translate-auto ()
    "Automatically recognize and translate Japanese and English."
    (interactive)
    (if (use-region-p)
	(let ((string (buffer-substring-no-properties (region-beginning) (region-end))))
	  (deactivate-mark)
	  (if (string-match (format "\\`[%s]+\\'" "[:ascii:]")
			    string)
	      (google-translate-translate
	       "en" "ja"
	       string)
	    (google-translate-translate
	     "ja" "en"
	     string)))
      (let ((string (read-string "Google Translate: ")))
	(if (string-match
	     (format "\\`[%s]+\\'" "[:ascii:]")
	     string)
	    (google-translate-translate
	     "en" "ja"
	     string)
	  (google-translate-translate
	   "ja" "en"
	   string))))))

;; Fix error of "Failed to search TKK"
(defun google-translate--get-b-d1 ()
  "TKK='427110.1469889687'."
  (list 427110 1469889687))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 90_translate.el ends here
