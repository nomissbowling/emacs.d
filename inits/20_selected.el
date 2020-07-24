;;; 20_selected.el --- 20_selected.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf selected :ensure t
  :bind (:selected-keymap
	 (";" . comment-dwim)
	 ("c" . clipboard-kill-ring-save)
	 ("." . my:mozc-word-regist)
	 ("e" . my:eijiro)
	 ("w" . my:weblio)
	 ("k" . my:kobun)
	 ("r" . my:ruigo)
	 ("p" . my:postal)
	 ("t" . my:translate)
	 ("m" . my:g-map)
	 ("y" . my:yahoo)
	 ("g" . my:google)
	 ("l" . counsel-selected)
	 ("?" . hydra-selected/body)
	 ("q" . selected-off))
  :config
  (selected-global-mode)
  :init
  (leaf counsel-selected :el-get takaxp/counsel-selected)
  (defun my-activate-selected ()
    (selected-global-mode 1)
    (selected--on) ;; must call expclitly here
    (remove-hook 'activate-mark-hook #'my-activate-selected))
  (add-hook 'activate-mark-hook #'my-activate-selected)
  (defun my:translate ()
    "Automatically recognize and translate Japanese and English."
    (interactive)
    (google-translate-auto))
  :hydra
  (hydra-selected
   (:color red :hint nil)
   "
 🔍 _t_ranslate  _g_oogle  _e_ijiro  _w_eblio  _k_obun  _r_uigo  _l_ist  mozc:_._"
   ("t" my:translate)
   ("e" my:eijiro)
   ("w" my:weblio)
   ("k" my:kobun)
   ("r" my:ruigo)
   ("p" my:postal)
   ("m" my:g-map)
   ("y" my:yahoo)
   ("g" my:google)
   ("." my:mozc-word-regist)
   (";" comment-dwim)
   ("l" cunsel-selected)
   ("c" clipboard-kill-ring-save)))


(leaf *user-search-function
  :init
  ;; Weblio
  (defun my:weblio (str)
    "Search weblio."
    (interactive (list
		  (region-or-read-string "Weblio: ")))
    (browse-url (format "http://www.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))

  ;; Kobun
  (defun my:kobun (str)
    "Search weblio kobun."
    (interactive (list
		  (region-or-read-string "Weblio: ")))
    (browse-url (format "https://kobun.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))

  ;; Ruigo
  (defun my:ruigo (str)
    "Search weblio ruigo."
    (interactive (list
		  (region-or-read-string "Weblio: ")))
    (browse-url (format "https://thesaurus.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))

  ;; Eijiro
  (defun my:eijiro (str)
    "Search eijiro-web."
    (interactive (list
		  (region-or-read-string "Weblio: ")))
    (browse-url (format "http://eow.alc.co.jp/%s/UTF-8/"
			(upcase (url-hexify-string str)))))

  ;; Post number
  (defun my:postal (str)
    "Search postal code."
    (interactive (list
		  (region-or-read-string "Weblio: ")))
    (browse-url (format "https://postcode.goo.ne.jp/search/q/%s/"
			(upcase (url-hexify-string str)))))

  ;; Google
  (defun my:google (str)
    "Serach googe."
    (interactive (list
		  (region-or-read-string "Weblio: ")))
    (browse-url (format "http://www.google.com/search?hl=ja&q=%s/"
			(upcase (url-hexify-string str)))))

  ;; Google map
  (defun my:g-map (str)
    "Serach google-map."
    (interactive (list
		  (region-or-read-string "Weblio: ")))
    (browse-url (format "http://maps.google.co.jp/maps?hl=ja&q=%s/"
			(upcase (url-hexify-string str)))))

  ;; Yahoo
  (defun my:yahoo (str)
    "Search yahoo."
    (interactive (list
		  (region-or-read-string "Weblio: ")))
    (browse-url (format "http://search.yahoo.co.jp/search?p=%s/"
			(upcase (url-hexify-string str)))))

  (defun region-or-read-string (prompt &optional initial history default inherit)
    "If region is specified, get that string, otherwise call `read-string'."
    (if (not (region-active-p))
  	(read-string prompt initial history default inherit)
      (prog1
  	  (buffer-substring-no-properties (region-beginning) (region-end))
  	(deactivate-mark)
  	(message "")))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 20_selected.el ends here
