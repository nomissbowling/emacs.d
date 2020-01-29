;;; 90_translate.el --- 90_translate.el
;;; Commentary:
;;; README is here : https://github.com/atykhonov/google-translate
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fix error of "Failed to search TKK"
(defun google-translate--get-b-d1 ()
  "TKK='427110.1469889687'."
  (list 427110 1469889687))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Fix error of "args-out-of-range"
;; Replace function in google-translate-core.el

;; (defun google-translate-json-suggestion (json)
;;   "Retrieve from JSON (which returns by the
;; `google-translate-request' function) suggestion. This function
;; does matter when translating misspelled word. So instead of
;; translation it is possible to get suggestion."
;;   (let ((info (aref json 7)))
;;     (if (and info (> (length info) 0))
;;         (aref info 1)
;;       nil)))


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 90_translate.el ends here
