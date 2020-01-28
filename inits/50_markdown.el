;;; 50_markdown.el --- 50_markdown.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; markdown-mode

(setq markdown-fontify-code-blocks-natively t)
(add-hook 'markdown-mode-hook
          '(lambda () (outline-minor-mode t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hydra

(defhydra hydra-markdown (:color red :hint nil)
  "
 _i_talic  消線:_x_  _f_ootnote  _t_able  t_o_c  _l_ivedown:_k_ill  _p_df._d_ocx"
  ("i" markdown-insert-italic)
  ("x" markdown-insert-strike-through)
  ("t" markdown-insert-table)
  ("o" markdown-toc-generate-or-refresh-toc)
  ("f" markdown-insert-footnote)
  ("l" livedown-preview)
  ("k" livedown-kill)
  ;; Pndoc
  ("p" md2pdf)
  ("d" md2docx)
  ("C-;" nil))

;; Change markdown-modo key bind `markdown-shifttab' to `company-yasnippet'
(bind-key* "S-<tab>" 'company-yasnippet markdown-mode-map)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; md2pdf (Use wkhtmltopdf without latex)

(defun md2pdf ()
  "Generate pdf from currently open markdown."
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; md2docx

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
               ".docx")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; livedown: Realtime viewer
;; https://github.com/shime/livedown

(use-package livedown)
(custom-set-variables
 '(livedown-autostart nil) ; automatically open preview when opening markdown files
 '(livedown-open t)        ; automatically open the browser window
 '(livedown-port 1337)     ; port for livedown server
 '(livedown-browser nil))  ; browser to use

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 50_markdown.el ends here
