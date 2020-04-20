;;; 50_markdown.el --- 50_markdown.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf markdown-mode
  :ensure t
  :bind (:markdown-mode-map
	 ("S-<tab>" . company-yasnippet))
  :hook (markdown-mode-hook . auto-fill-mode)
  :mode ("\\.md$'" . gfm-mode)

  :custom ((markdown-enable-wiki-links . t)
	   (markdown-italic-underscore . t)
	   (markdown-asymmetric-header . t)
	   (markdown-make-gfm-checkboxes-buttons . t)
	   (markdown-gfm-uppercase-checkbox . t)
	   (markdown-fontify-code-blocks-natively . t)
	   (markdown-enable-math . t)
	   (markdown-content-type . "application/xhtml+xml")
	   (markdown-css-paths . '("https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
				   "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css"))
	   (markdown-xhtml-header-content . "
<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
<style>
body {
  box-sizing: border-box;
  max-width: 740px;
  width: 100%;
  margin: 40px auto;
  padding: 0 10px;
}
</style>
<script src='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js'></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  document.body.classList.add('markdown-body');
  document.querySelectorAll('pre[lang] > code').forEach((code) => {
    code.classList.add(code.parentElement.lang);
    hljs.highlightBlock(code);
  });
});
</script>
"))

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
  (leaf livedown
    :doc "Markdown Preview"
    :url "https://github.com/shime/emacs-livedown"
    :el-get  shime/emacs-livedown
    :bind ((:markdown-mode-map
	    :package markdown-mode
	    ("C-c l p" . livedown-preview)
	    ("C-c l k" . livedown-kill)))
    :require t
    :custom ((livedown-autostart . nil)
	     (livedown-open . t)
	     (livedown-port . 1337)
	     (livedown-browser . nil)))

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

(leaf *md2pdf
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


;; localstackと9000がぶつかるので変えた
;; (setq markdown-preview-http-port 19000)
;; (setq markdown-command "runpandoc")
;; (setq markdown-use-pandoc-style-yaml-metadata t)

;; ;; ショッキングピンクとか使ってて見た目がやばいので変える
;; (setq markdown-preview-stylesheets nil)


;; ;; markdown-preview like github
(setq markdown-command "pandoc"
      markdown-command-needs-filename t
      markdown-content-type "application/xhtml+xml"
      markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
			   "http://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css")
      markdown-xhtml-header-content "
<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
<style>
body {
  box-sizing: border-box;
  max-width: 740px;
  width: 100%;
  margin: 40px auto;
  padding: 0 10px;
}
</style>
<script src='http://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js'></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  document.body.classList.add('markdown-body');
  document.querySelectorAll('pre[lang] > code').forEach((code) => {
    code.classList.add(code.parentElement.lang);
    hljs.highlightBlock(code);
  });
});
</script>
")


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 50_markdown.el ends here
