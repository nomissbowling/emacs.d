;;; 70_yatex.el --- 70_yatex.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  (leaf yatex :ensure t
    :mode ("\\.tex\\'" . yatex-mode)
    :config
    (setq tex-command "platex"
	  dviprint-command-format "dvpd.sh %s"
	  YaTeX-kanji-code nil
	  YaTeX-latex-message-code 'utf-8
	  YaTeX-default-pop-window-height 15)
    :init
    (add-hook
     'yatex-mode-hook
     '(lambda ()
	(leaf yatexprc
	  :bind (("M-c" . YaTeX-typeset-buffer)	;; Type set buffer
		 ("M-l" . YaTeX-lpr)))))))	;; Open pdf veiwer


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
