;;; 30_mozc.el --- 30_mozc.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf mozc
  :bind ("C-c C-d" . mozc-word-regist)
  :bind* ("<henkan>" . toggle-input-method)
  :init
  (setq default-input-method "japanese-mozc")
  (setq mozc-helper-program-name "mozc_emacs_helper")
  :config
  (custom-set-variables '(mozc-leim-title "かな "))
  (leaf mozc-cursor-color :require t
    :url "https://github.com/iRi-E/mozc-el-extensions"
    :after mozc)
  (leaf mozc-posframe :require t
    :url "https://github.com/derui/mozc-posframe"
    :after mozc
    :config
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
     "/usr/lib/mozc/mozc_tool --mode=config_dialog")))

(leaf cus-input-method
  :doc "do not hijack input-method."
  :config
  (defadvice toggle-input-method (around toggle-input-method-around activate)
    "Input method function in key-chord.el not to be nil."
    (let ((input-method-function-save input-method-function))
      ad-do-it
      (setq input-method-function input-method-function-save))))

(leaf cus-insert-str
  :doc "Set the character to be immediately determine."
  :url "https://www2.ninjal.ac.jp/kubota/mozc.html"
  :preface
  (defun mozc-insert-str (str)
    "Set the argument `STR'."
    (mozc-handle-event 'enter)
    (toggle-input-method)
    (insert str)
    (toggle-input-method))
  :config
  (add-hook 'mozc-mode-hook
  	    (lambda ()
  	      (define-key mozc-mode-map "?" '(lambda () (interactive) (mozc-insert-str "？")))
  	      (define-key mozc-mode-map "," '(lambda () (interactive) (mozc-insert-str "、")))
  	      (define-key mozc-mode-map "." '(lambda () (interactive) (mozc-insert-str "。"))))))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 30_mozc.el ends here
