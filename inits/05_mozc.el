;;; 05_mozc.el --- minor mode to input japanese with mozc  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf mozc
  :ensure t
  :config
  (unless (getenv "WSLENV")
	(bind-key* "<hiragana-katakana>" 'toggle-input-method))
  (when (getenv "WSLENV")
	(bind-key* "<henkan>" 'toggle-input-method))
  (setq default-input-method "japanese-mozc"
		mozc-helper-program-name "mozc_emacs_helper"
		mozc-leim-title "♡かな")

  ;; Confirmed immediately
  (define-key mozc-mode-map "," '(lambda () (interactive) (mozc-insert-str "、")))
  (define-key mozc-mode-map "." '(lambda () (interactive) (mozc-insert-str "。")))
  (define-key mozc-mode-map "?" '(lambda () (interactive) (mozc-insert-str "？")))
  (define-key mozc-mode-map "!" '(lambda () (interactive) (mozc-insert-str "！")))
  (defun mozc-insert-str (str)
	"If punctuation marks, immediately confirm."
	(mozc-handle-event 'enter)
	(toggle-input-method)
	(insert str)
	(toggle-input-method))

  ;; Key-chord measures
  (defadvice toggle-input-method (around toggle-input-method-around activate)
	"Input method function in key-chord.el not to be nil."
	(let ((input-method-function-save input-method-function))
	  ad-do-it
	  (setq input-method-function input-method-function-save)))

  :init
  (leaf mozc-cursor-color
	:el-get iRi-E/mozc-el-extensions
	:require t
	:config
	(setq mozc-cursor-color-alist
		  '((direct . "#BD93F9")
			(read-only . "#84A0C6")
			(hiragana . "#CC3333"))))

  (leaf mozc-cand-posframe :ensure t
	:require t
	:config
	(setq mozc-candidate-style 'posframe)))


(leaf mozc-tool-setting
  :config
  (bind-key "<f7>" 'select-mozc-tool)
  (bind-key "<f8>" 'my:mozc-word-regist)
  :init
  (defun select-mozc-tool ()
	"Select mozc tool command."
	(interactive)
	(counsel-M-x "my:mozc "))

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

;;; 05_mozc.el ends here
