;;; 70_yatex.el --- 70_yatex.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf yatex
  :mode ("\\.tex\\'" . yatex-mode)
  :config
  (setq tex-command "platex"
	dviprint-command-format "dvpd.sh %s"
	YaTeX-kanji-code nil
	YaTeX-latex-message-code 'utf-8
	Section-name "documentclass"
	makeindex-command "mendex"
	YaTeX-use-AMS-LaTeX t
	YaTeX-use-LaTeX2e t
	YaTeX-use-font-lock t
	YaTeX-default-pop-window-height 20)
  (add-hook 'yatex-mode-hook
  	    (lambda()
  	      (leaf yatexprc
  		:bind (("M-c" . YaTeX-typeset-buffer)	;; Type set
  		       ("M-l" . YaTeX-lpr))))))		;; Open pdf

(leaf *dviprint-command-format
  ;; -----------------------------------------------------------------------
  ;; dvpd.sh for Linux
  ;; Create dvpd.sh and execute 'chmod +x', and place it in `/usr/local/bin'
  ;; | #!/bin/bash
  ;; | name=$1
  ;; | dvipdfmx $1 && evince ${name%.*}.pdf

  ;; dvpd.sh for WSL
  ;; Create dvpd.sh and execute 'chmod +x', and place it in `/usr/local/bin'
  ;; | #!/bin/bash
  ;; | name=$1
  ;; | dvipdfmx $1 && wslstart ${name%.*}.pdf
  ;; ------------------------------------------------------------------------
  )

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 70_yatex.el ends here
