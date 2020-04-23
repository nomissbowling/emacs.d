;;; 50_markdown.el --- 50_markdown.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf markdown-mode :ensure t
  :bind (:markdown-mode-map
	 ("S-<tab>" . company-yasnippet))
  :hook (markdown-mode-hook . auto-fill-mode)
  :mode ("\\.md$'" . gfm-mode)

  :init
  ;; toc generater
  (leaf markdown-toc :ensure t)
  ;; markdown preview
  (leaf livedown
    :url "https://github.com/shime/emacs-livedown"
    :el-get  shime/emacs-livedown
    :bind ((:markdown-mode-map
	    :package markdown-mode
	    ("C-c p" . livedown-preview)
	    ("C-c k" . livedown-kill)))
    :require t
    :custom ((livedown-autostart . nil)
	     (livedown-open . t)
	     (livedown-port . 1337)
	     (livedown-browser . nil)))

  :custom-face
  (markdown-header-delimiter-face . '((t (:foreground "mediumpurple"))))
  (markdown-header-face-1 . '((t (:foreground "violet" :weight bold :height 1.0))))
  (markdown-header-face-2 . '((t (:foreground "lightslateblue" :weight bold :height 1.0))))
  (markdown-header-face-3 . '((t (:foreground "mediumpurple1" :weight bold :height 1.0))))
  (markdown-link-face . '((t (:background "#0e1014" :foreground "#bd93f9"))))
  (markdown-list-face . '((t (:foreground "mediumpurple"))))
  (markdown-code-face . '((t (:background "#222" :inherit 'default))))
  (markdown-pre-face . '((t (:foreground "#bd98fe"))))

  :config
  :hydra
  (hydra-markdown
   (:color red :hint nil)
   "
 _i_talic  消線:_x_  _f_ootnote  _t_able  t_o_c  _v_iewer:_k_  md2_p_df  md2_d_ocx"
   ("i" markdown-insert-italic)
   ("x" markdown-insert-strike-through)
   ("t" markdown-insert-table)
   ("o" markdown-toc-generate-or-refresh-toc)
   ("f" markdown-insert-footnote)
   ("v" livedown-preview)
   ("k" livedown-kill)
   ;; Pndoc
   ("p" md2pdf)
   ("d" md2docx)
   ("q" nil)))


(leaf Pandoc
  :config
  (defun md2pdf ()
    "Generate pdf from currently open markdown. Use wkhtmltopdf without latex"
    (interactive)
    (let ((filename (buffer-file-name (current-buffer))))
      (shell-command-to-string
       (concat "pandoc "
	       filename
	       " -f markdown -t html5 -o "
	       (file-name-sans-extension filename)
	       ".pdf"))
      (when (eq system-type 'gnu/linux)   ;; for Debian
	(shell-command-to-string
	 (concat "evince "
		 (file-name-sans-extension filename)
		 ".pdf")))
      (when (eq system-type 'darwin)      ;; for macOS
	(shell-command-to-string
	 (concat "open -a preview.app "
		 (file-name-sans-extension filename)
		 ".pdf")))))

  (defun md2docx ()
    "Generate docx from currently open markdown."
    (interactive)
    (let ((filename (buffer-file-name (current-buffer))))
      (shell-command-to-string
       (concat "pandoc "
	       filename
	       " -t docx -o "
	       (file-name-sans-extension filename)
	       ;; ".docx -V mainfont=IPAPGothic -V fontsize=16pt --toc --highlight-style=zenburn"))
	       ".docx -V mainfont=IPAPGothic -V fontsize=16pt --highlight-style=zenburn"))
      (when (eq system-type 'gnu/linux)
	(shell-command-to-string
	 (concat "xdg-open "
		 (file-name-sans-extension filename)
		 ".docx")))
      (when (eq system-type 'darwin)
	(shell-command-to-string
	 (concat "open -a pages.app "
		 (file-name-sans-extension filename)
		 ".docx"))))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 50_markdown.el ends here
