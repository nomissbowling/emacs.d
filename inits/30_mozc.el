;;; 30_mozc.el --- 30_mozc.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mozc-mode
(use-package mozc
  :init
  (setq default-input-method "japanese-mozc")
  (setq mozc-helper-program-name "mozc_emacs_helper")
  :config
  (custom-set-variables '(mozc-leim-title "かな "))
  (bind-key* "<henkan>" 'toggle-input-method))

;; https://github.com/iRi-E/mozc-el-extensions
(use-package mozc-cursor-color)

;; https://github.com/derui/mozc-posframe
(use-package mozc-posframe
  :after mozc
  :custom
  (mozc-candidate-style 'posframe))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mozc-tool
(bind-key
 "C-c C-d"
 (defun mozc-word-regist ()
   "Mozc word regist."
   (interactive)
   (shell-command-to-string
    "/usr/lib/mozc/mozc_tool --mode=word_register_dialog")))

(defun mozc-config-dialog ()
  "Mozc config dialog."
  (interactive)
  (shell-command-to-string
   "/usr/lib/mozc/mozc_tool --mode=config_dialog"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Set the character to be immediately determine
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
	    (define-key mozc-mode-map "." '(lambda () (interactive) (mozc-insert-str "。")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; don't hijack input method
(defadvice toggle-input-method (around toggle-input-method-around activate)
  "Input method function in key-chord.el not to be nil."
  (let ((input-method-function-save input-method-function))
    ad-do-it
    (setq input-method-function input-method-function-save)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 30_mozc.el ends here
