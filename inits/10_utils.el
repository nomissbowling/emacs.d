;;; 10_utils.el --- 10_utils.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Emacs on WSL open links in Windows web browser
;; https://adam.kruszewski.name/2017/09/emacs-in-wsl-and-opening-links/
(when (getenv "WSLENV")
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
	(cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
	    browse-url-generic-args     cmd-args
	    browse-url-browser-function 'browse-url-generic
	    search-web-default-browser 'browse-url-generic))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Output PDF from text file
(setq my:pdfout-command-format "nkf -e | e2ps -a4 -p -nh | ps2pdf - %s")
(defun my:pdfout-region (begin end)
  "PDF out from BEGIN to END of region."
  (interactive "r")
  (shell-command-on-region begin end (format my:pdfout-command-format (concat (read-from-minibuffer "File name:") ".pdf"))))
(defun my:pdfout-buffer ()
  "PDF out from buffer."
  (interactive)
  (my:pdfout-region (point-min) (point-max)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Open application
(bind-key*
 "C-z"
 (defun term-current-dir-open ()
   "Open terminal application in current dir."
   (interactive)
   ;; Remove trailing '/' from 'default-derectory'
   (let ((dir (directory-file-name default-directory)))
     (shell-command (concat "gnome-terminal --working-directory " dir)))))

(bind-key
 [f3]
 (defun filer-current-dir-open ()
   "Open filer in current dir."
   (interactive)
   (shell-command (concat "xdg-open " default-directory))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Search Web
;; Tips from https://github.com/nomaddo/search-web.el
(use-package search-web
  :commands search-web-dwim
  :config
  (add-to-list 'search-web-engines '("weblio" "https://www.weblio.jp/content/%s" nil))
  (add-to-list 'search-web-engines '("kobun" "https://kobun.weblio.jp/content/%s" nil))
  (add-to-list 'search-web-engines '("ruigo" "https://thesaurus.weblio.jp/content/%s" nil))
  (add-to-list 'search-web-engines '("google maps" "http://maps.google.co.jp/maps?hl=ja&q=%s" nil))
  (add-to-list 'search-web-engines '("qitta" "https://qiita.com/search?q=%s" nil))
  (add-to-list 'search-web-engines '("post" "https://postcode.goo.ne.jp/search/q/%s/" nil))
  (add-to-list 'search-web-engines '("earth" "https://earth.google.com/web/search/%s/" nil))
  (add-to-list 'search-web-engines '("amazon jp" "http://www.amazon.co.jp/gp/search?index=blended&field-keywords=%s" nil))
  (add-to-list 'search-web-engines '("yodobashi" "https://www.yodobashi.com/?word=%s" nil))
  (add-to-list 'search-web-engines '("yahoo jp" "http://search.yahoo.co.jp/search?p=%s" nil))
  (add-to-list 'search-web-engines '("eijiro" "http://eow.alc.co.jp/%s/UTF-8/" nil)))

(bind-key
 "M-s"
 (defhydra hydra-search (:hint nil :exit t)
   "
 🔍  _a_mazon  _y_odobashi  _g_oogle  _e_ijiro  _m_aps  _q_itta  _w_eblio  g_o_o  _p_:〒  _k_:古語  _r_:類語"
   ("a" (search-web-dwim "amazon jp"))
   ("e" (search-web-dwim "eijiro"))
   ("g" (search-web-dwim "google"))
   ("o" (search-web-dwim "goo"))
   ("m" (search-web-dwim "google maps"))
   ("q" (search-web-dwim "qitta"))
   ("w" (search-web-dwim "weblio"))
   ("p" (search-web-dwim "post"))
   ("k" (search-web-dwim "kobun"))
   ("y" (search-web-dwim "yodobashi"))
   ("r" (search-web-dwim "ruigo"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Automatic deletion for empty files (Valid in all modes)
;; https://uwabami.github.io/cc-env/Emacs.html#org57f6557
(defun my:delete-file-if-no-contents ()
  "Automatic deletion for empty files."
  (when (and (buffer-file-name (current-buffer))
             (= (point-min) (point-max)))
    (delete-file
     (buffer-file-name (current-buffer)))))
(if (not (memq 'my:delete-file-if-no-contents after-save-hook))
    (setq after-save-hook
          (cons 'my:delete-file-if-no-contents after-save-hook)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; key-chord
(key-chord-mode 1)
(setq key-chord-two-keys-delay           0.15
      key-chord-safety-interval-backward 0.1
      key-chord-safety-interval-forward  0.25)
(key-chord-define-global "df" 'counsel-descbinds)
(key-chord-define-global "l;" 'init-loader-show-log)

;; don't hijack input method
(defadvice toggle-input-method (around toggle-input-method-around activate)
  "Input method function in key-chord.el not to be nil."
  (let ((input-method-function-save input-method-function))
    ad-do-it
    (setq input-method-function input-method-function-save)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_utils.el ends here
