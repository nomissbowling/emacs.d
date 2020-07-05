;;; 30_mozc.el --- 30_mozc.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf mozc
  :ensure t
  :bind* (("<hiragana-katakana>" . toggle-input-method)
	  ("<henkan>" . mozc-temp-convert))
  :config
  (setq default-input-method "japanese-mozc"
	mozc-helper-program-name "mozc_emacs_helper"
	mozc-leim-title "♡かな")
  (add-hook
   'mozc-mode-hook
   (lambda ()
     (define-key mozc-mode-map "?" '(lambda () (interactive) (mozc-insert-str "？")))
     (define-key mozc-mode-map "," '(lambda () (interactive) (mozc-insert-str "、")))
     (define-key mozc-mode-map "." '(lambda () (interactive) (mozc-insert-str "。")))))
  :preface
  (defadvice toggle-input-method (around toggle-input-method-around activate)
    "Input method function in key-chord.el not to be nil."
    (let ((input-method-function-save input-method-function))
      ad-do-it
      (setq input-method-function input-method-function-save)))
  (defun mozc-insert-str (str)
    "If punctuation marks, immediately confirm."
    (mozc-handle-event 'enter)
    (toggle-input-method)
    (insert str)
    (toggle-input-method))
  :init
  (leaf mozc-temp :ensure t)
  (leaf posframe :ensure t)
  (leaf mozc-cursor-color
    :el-get iRi-E/mozc-el-extensions
    :require t
    :config
    (setq mozc-cursor-color-alist
	  '((direct . "#BD93F9")
	    (read-only . "#84A0C6")
	    (hiragana . "#CC3333"))))
  (leaf mozc-cand-posframe
    :ensure t
    :require t
    :config
    (setq mozc-candidate-style 'posframe)))


(leaf *user-mozc-tool
  :bind ("<f8>" . my:mozc-word-regist)
  :init
  (bind-key
   "<f7>"
   (lambda ()
     (interactive)
     (counsel-M-x "my:mozc ")))
  :preface
  (defun my:mozc-config-dialog ()
    "Run the mozc-tool in the background."
    (interactive)
    (compile "/usr/lib/mozc/mozc_tool --mode=config_dialog"))

  (defun my:mozc-dictionary-tool ()
    "Run the mozc-tool in the background."
    (interactive)
    (compile "/usr/lib/mozc/mozc_tool --mode=dictionary_tool"))

  (defun my:mozc-word-regist ()
    "Run the mozc-tool in the background."
    (interactive)
    (compile "/usr/lib/mozc/mozc_tool --mode=word_register_dialog"))

  (defun my:mozc-hand-writing ()
    "Run the mozc-tool in the background."
    (interactive)
    (compile "/usr/lib/mozc/mozc_tool --mode=hand_writing")))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 30_mozc.el ends here
