;;; 20_selected.el --- 20_selected.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  (leaf selected :ensure t
    :bind ("s-s" . hydra-selected/body)
    :hook (emacs-startup-hook . selected-global-mode)
    :config
    (with-eval-after-load 'selected
      (bind-key ";" 'comment-dwim selected-keymap)
      (bind-key "c" 'clipboard-kill-ring-save selected-keymap)
      (bind-key "." 'my:mozc-word-regist selected-keymap)
      (bind-key "e" 'my:eijiro selected-keymap)
      (bind-key "w" 'my:weblio selected-keymap)
      (bind-key "k" 'my:kobun selected-keymap)
      (bind-key "r" 'my:ruigo selected-keymap)
      (bind-key "p" 'my:postal selected-keymap)
      (bind-key "t" 'my:translate selected-keymap)
      (bind-key "m" 'my:g-map selected-keymap)
      (bind-key "g" 'my:google selected-keymap)
      (bind-key "l" 'counsel-selected selected-keymap)
      (bind-key "h" 'hydra-selected/body selected-keymap)
      (bind-key "q" 'selected-off selected-keymap))
    :init
    (leaf counsel-selected :el-get takaxp/counsel-selected)
    (defun my:translate ()
      "Traslate user-function for selected."
      (interactive)
      (google-translate-auto))
    :hydra
    (hydra-selected
     (:color red :hint nil)
     "
 🔍 _t_ranslate  _e_ijiro  _w_eblio  _k_obun  _r_uigo  _g_oogle  _l_ist"
     ("t" my:translate)
     ("e" my:eijiro)
     ("w" my:weblio)
     ("k" my:kobun)
     ("r" my:ruigo)
     ("g" my:google)
     ("l" cunsel-selected))))


(leaf  *control-mozc-when-region-seleceted
  :init
  (defun my-activate-selected ()
    (selected-global-mode 1)
    (selected--on) ;; must call expclitly here
    (remove-hook 'activate-mark-hook #'my-activate-selected))
  (add-hook 'activate-mark-hook #'my-activate-selected)
  (defun my:ime-on ()
    (interactive)
    (when (null current-input-method) (toggle-input-method)))
  (defun my:ime-off ()
    (interactive)
    (inactivate-input-method))
  ;; activate-mark-hook
  (add-hook
   'activate-mark-hook
   #'(lambda ()
       (setq my:ime-flag current-input-method) (my:ime-off)))
  (add-hook
   'deactivate-mark-hook
   #'(lambda ()
       (unless (null my:ime-flag) (my:ime-on)))))


(leaf *user-word-search-functions
  :init
  ;; Weblio
  (defun my:weblio (str)
    (interactive (list (region-or-read-string nil)))
    (browse-url (format "http://www.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))
  ;; Kobun
  (defun my:kobun (str)
    (interactive (list (region-or-read-string nil)))
    (browse-url (format "https://kobun.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))
  ;; Ruigo
  (defun my:ruigo (str)
    (interactive (list (region-or-read-string nil)))
    (browse-url (format "https://thesaurus.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))
  ;; Eijiro
  (defun my:eijiro (str)
    (interactive (list (region-or-read-string nil)))
    (browse-url (format "http://eow.alc.co.jp/%s/UTF-8/"
			(upcase (url-hexify-string str)))))
  ;; Postal code
  (defun my:postal (str)
    (interactive (list (region-or-read-string nil)))
    (browse-url (format "https://postcode.goo.ne.jp/search/q/%s"
			(upcase (url-hexify-string str)))))
  ;; Google
  (defun my:google (str)
    (interactive (list (region-or-read-string nil)))
    (browse-url (format "http://www.google.com/search?hl=ja&q=%s"
			(upcase (url-hexify-string str)))))
  ;; Google map
  (defun my:g-map (str)
    (interactive (list (region-or-read-string nil)))
    (browse-url (format "http://maps.google.co.jp/maps?hl=ja&q=%s"
			(upcase (url-hexify-string str)))))

  (defun region-or-read-string (prompt &optional initial history default inherit)
    "If region is specified, get that string, otherwise call `read-string'."
    (if (not (region-active-p))
	(read-string prompt initial history default inherit)
      (prog1
	  (buffer-substring-no-properties (region-beginning) (region-end))
	(deactivate-mark)
	(message ""))))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 20_selected.el ends here
