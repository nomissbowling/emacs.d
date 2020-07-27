;;; 30_selected.el --- 30_selected.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf selected :ensure t
  :bind ("s-s" . hydra-search/body)
  :config
  (selected-global-mode)
  (with-eval-after-load 'selected
    (bind-key ";" 'comment-dwim selected-keymap)
    (bind-key "c" 'clipboard-kill-ring-save selected-keymap)
    (bind-key "." 'my:mozc-word-regist selected-keymap)
    (bind-key "a" 'my:amazon selected-keymap)
    (bind-key "y" 'my:yodobashi selected-keymap)
    (bind-key "e" 'my:eijiro selected-keymap)
    (bind-key "w" 'my:weblio selected-keymap)
    (bind-key "k" 'my:kobun selected-keymap)
    (bind-key "r" 'my:ruigo selected-keymap)
    (bind-key "p" 'my:postal selected-keymap)
    (bind-key "t" 'google-translate-auto selected-keymap)
    (bind-key "m" 'my:g-map selected-keymap)
    (bind-key "g" 'my:google selected-keymap)
    (bind-key "l" 'counsel-selected selected-keymap)
    (bind-key "q" 'selected-off selected-keymap))
  :init
  (leaf counsel-selected :el-get takaxp/counsel-selected)
  :hydra
  (hydra-search
   (:color red :hint nil)
   "
   🔍 : _e_ijiro  _w_eblio  _k_obun  _r_uigo  _p_ostal  _g_oogle  _a_mazon  _y_odobash."
   ("a" my:amazon)
   ("y" my:yodobashi)
   ("e" my:eijiro)
   ("w" my:weblio)
   ("k" my:kobun)
   ("r" my:ruigo)
   ("p" my:poastal)
   ("g" my:google)))


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
  ;; mark-hook
  (add-hook
   'activate-mark-hook
   #'(lambda ()
       (setq my:ime-flag current-input-method) (my:ime-off)))
  (add-hook
   'deactivate-mark-hook
   #'(lambda ()
       (unless (null my:ime-flag) (my:ime-on)))))


(leaf *user-functions-for-selected
  :init
  ;; Weblio
  (defun my:weblio (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://www.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))
  ;; Kobun
  (defun my:kobun (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://kobun.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))
  ;; Ruigo
  (defun my:ruigo (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://thesaurus.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))
  ;; Eijiro
  (defun my:eijiro (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://eow.alc.co.jp/%s/UTF-8/"
			(upcase (url-hexify-string str)))))
  ;; Postal code
  (defun my:postal (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://postcode.goo.ne.jp/search/q/%s"
			(upcase (url-hexify-string str)))))
  ;; Google
  (defun my:google (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://www.google.com/search?hl=ja&q=%s"
			(upcase (url-hexify-string str)))))
  ;; Google map
  (defun my:g-map (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://maps.google.co.jp/maps?hl=ja&q=%s"
			(upcase (url-hexify-string str)))))
  ;; Amazon
  (defun my:amazon (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://www.amazon.co.jp/gp/search?index=blended&field-keywords=%s"
			(upcase (url-hexify-string str)))))
  ;; Yodobashi
  (defun my:yodobashi (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://www.yodobashi.com/?word=%s"
			(upcase (url-hexify-string str)))))

  ;; Common function
  (defun my:get-region (arg)
    "Get that string from region."
    (buffer-substring-no-properties (region-beginning) (region-end)))

  )


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 30_selected.el ends here
