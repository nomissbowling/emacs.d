;;; 30_mozc.el --- 30_mozc.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf mozc
  :ensure t
  :commands toggle-input-method
  :bind (("C-c C-w" . mozc-word-regist)
	 ("C-c C-d" . mozc-config-dialog))
  :bind* ("<henkan>" . toggle-input-method)
  :init
  (setq default-input-method "japanese-mozc")
  (setq mozc-helper-program-name "mozc_emacs_helper")
  (custom-set-variables '(mozc-leim-title "かな "))

  :config
  (leaf mozc-cursor-color
    :url "https://github.com/iRi-E/mozc-el-extensions"
    :el-get iRi-E/mozc-el-extensions
    :require t
    :after mozc)

  (leaf mozc-posframe
    :url "https://github.com/derui/mozc-posframe"
    :el-get derui/mozc-posframe
    :config
    (mozc-posframe-register)
    (setq mozc-candidate-style 'posframe))

  (defun mozc-word-regist ()
    "Mozc word regist."
    (interactive)
    (shell-command-to-string
     "/usr/lib/mozc/mozc_tool --mode=word_register_dialog"))

  (defun mozc-config-dialog ()
    "Mozc config dialog."
    (interactive)
    (shell-command-to-string
     "/usr/lib/mozc/mozc_tool --mode=config_dialog"))

  (defadvice toggle-input-method (around toggle-input-method-around activate)
    "Input method function in key-chord.el not to be nil."
    (let ((input-method-function-save input-method-function))
      ad-do-it
      (setq input-method-function input-method-function-save)))

  ;; https://www2.ninjal.ac.jp/kubota/mozc.html
  (defun mozc-insert-str (str)
    "Set the argument `STR'."
    (mozc-handle-event 'enter)
    (toggle-input-method)
    (insert str)
    (toggle-input-method))
  (add-hook 'mozc-mode-hook
	    (lambda ()
	      (define-key mozc-mode-map "?" '(lambda () (interactive) (mozc-insert-str "？")))
	      (define-key mozc-mode-map "," '(lambda () (interactive) (mozc-insert-str "、")))
	      (define-key mozc-mode-map "." '(lambda () (interactive) (mozc-insert-str "。"))))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 30_mozc.el ends here
