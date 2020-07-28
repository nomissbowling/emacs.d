;;; 70_yatex.el --- 70_yatex.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf yatex :ensure t
  :mode ("\\.tex\\'" . yatex-mode)
  :config
  (setq tex-command "platex")
  (setq dviprint-command-format "dvpd.sh %s")
  (setq YaTeX-kanji-code nil)
  (setq YaTeX-latex-message-code 'utf-8)
  (setq YaTeX-default-pop-window-height 15)
  :init
  (add-hook
   'yatex-mode-hook
   (lambda()
     (when (require 'yatexprc nil t)
       (bind-key "M-c" 'YaTeX-typeset-buffer)	;; Type set
       (bind-key "M-l" 'YaTeX-lpr)))))		;; Open PDF file


;; Dviprint-command-format
;; -----------------------------------------------------------------------
;; dvpd.sh for Linux
;; Create dvpd.sh and execute 'chmod +x', and place it in `/usr/local/bin'
;;
;; for Linux
;; | #!/bin/bash
;; | name=$1
;; | dvipdfmx $1 && evince ${name%.*}.pdf
;; |# Delete unnecessary files
;; |rm *.au* *.dv* *.lo*
;;
;; for WSL
;; | #!/bin/bash
;; | name=$1
;; | dvipdfmx $1 && wslstart ${name%.*}.pdf
;; |# Delete unnecessary files
;; |rm *.au* *.dv* *.lo*
;;
;; ------------------------------------------------------------------------


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 70_yatex.el ends here
