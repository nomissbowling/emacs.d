;;; 50_markdown.el --- 50_markdown.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf markdown-mode :ensure t
  :mode "\\.md\\'"
  :bind (("C-c '" . markdown-edit-code-block))
  :hydra
  (hydra-markdown
   (:color red :hint nil)
   "
    Markdown: _i_talic  消線:_x_  _f_ootnote  _t_able  t_o_c  _c_ode:_a_bort  _v_iew:_k_ill  md2_p_df  md2_d_ocx"
   ("i" markdown-insert-italic)
   ("x" markdown-insert-strike-through)
   ("t" markdown-insert-table)
   ("o" markdown-toc-generate-or-refresh-toc)
   ("f" markdown-insert-footnote)
   ("c" markdown-edit-code-block)
   ("a" edit-indirect-abort)
   ("v" livedown-preview)
   ("k" livedown-kill)
   ;; Pndoc
   ("p" md2pdf)
   ("d" md2docx)
   ("<muhenkan>" nil))
  :init
  (leaf markdown-toc :ensure t)
  (leaf edit-indirect :ensure t)
  (leaf poly-markdown :ensure t
    :mode ("\\.md" . poly-markdown-mode))
  (leaf livedown
    :el-get  shime/emacs-livedown
    :config
    (bind-key "C-c C-p" 'livedown-preview)
    (bind-key "C-c C-k" 'livedown-kill)
    (setq livedown-autostart nil)
    (setq livedown-open t)
    (setq livedown-port 1337)
    (setq livedown-browser nil)))


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
    (shell-command-to-string
     (concat "evince "
	     (file-name-sans-extension filename)
	     ".pdf"))))

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
    (shell-command-to-string
     (concat "xdg-open "
	     (file-name-sans-extension filename)
	     ".docx"))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 50_markdown.el ends here
