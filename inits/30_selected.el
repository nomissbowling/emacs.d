;;; 30_selected.el --- 30_selected.el   -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf selected :ensure t
  :config
  (selected-global-mode)
  (with-eval-after-load 'selected
    (bind-key ";" 'comment-dwim selected-keymap)
    (bind-key "f" 'describe-function selected-keymap)
    (bind-key "v" 'describe-variable selected-keymap)
    (bind-key "c" 'clipboard-kill-ring-save selected-keymap)
    (bind-key "i" 'iedit-mode selected-keymap)
    (bind-key "d" 'my:koujien selected-keymap)
    (bind-key "e" 'my:eijiro selected-keymap)
    (bind-key "w" 'my:weblio selected-keymap)
    (bind-key "t" 'google-translate-auto selected-keymap)
    (bind-key "g" 'my:google selected-keymap)
    (bind-key "l" 'counsel-selected selected-keymap)
    (bind-key "q" 'selected-off selected-keymap))
  :init
  (leaf counsel-selected :el-get takaxp/counsel-selected))


(leaf  *control-mozc-when-region-seleceted
  :init
  (defun my-activate-selected ()
    (selected-global-mode 1)
    (selected--on)
    (remove-hook 'activate-mark-hook #'my-activate-selected))
  (add-hook 'activate-mark-hook #'my-activate-selected)

  (defun my:ime-on ()
    (interactive)
    (when (null current-input-method) (toggle-input-method)))
  (defun my:ime-off ()
    (interactive)
    (inactivate-input-method))

  (defvar my:ime-flag nil)
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
  (defun my:koujien (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://sakura-paris.org/dict/広辞苑/prefix/%s"
			(upcase (url-hexify-string str)))))
  ;; Weblio
  (defun my:weblio (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://www.weblio.jp/content/%s"
			(upcase (url-hexify-string str)))))
  ;; Eijiro
  (defun my:eijiro (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://eow.alc.co.jp/%s/UTF-8/"
			(upcase (url-hexify-string str)))))
  ;; Google
  (defun my:google (str)
    (interactive (list (my:get-region nil)))
    (browse-url (format "https://www.google.com/search?hl=ja&q=%s"
			(upcase (url-hexify-string str)))))
  ;; common function
  (defun my:get-region (r)
    "Get search word from region."
    (buffer-substring-no-properties (region-beginning) (region-end))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 30_selected.el ends here
