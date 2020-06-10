;;; 10_hydra-menu.el --- 10_hydra-menu.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf *hydra-quick-menu
  :bind ("M-." . hydra-quick-menu/body)
  :hydra
  (hydra-quick-menu
   (:hint nil :exit t)
   "
   🐳 Quick Menu
  ---^^^^^^^^^^^^^^^^^^^^^^^^^^^^^------------------------------------------------------------------------------------------------------------
   _d_ropbox   _e_macs.d^^   _i_nits   _w_eb   GH:_h_   .emacs_;_^^^^   _g_ithub   gist:_l_   _r_estart   _m_arkdown   _u_ndotree^^   howm_@_
   magit:_:_   _t_ramp:_q_   _p_inky   _f_tp   _b_ook   _y_as:_n_:_v_   _s_earch   make:_k_   _c_ompile   _o_pen-url   capture_,_^^   _a_g:🐾"
   ("1" my:pdfout-buffer)
   ("2" my:pdfout-region)
   ("a" counsel-ag)
   ("o" browse-url-at-point)
   ("f" ftp-client)
   ("t" counsel-tramp)
   ("q" my:tramp-quit)
   ("d" my:dropbox)
   ("i" my:inits-dir)
   ("e" my:emacs-dir)
   ("w" my:www-dir)
   ("h" my:gh-dir)
   ("y" ivy-yasnippet)
   ("n" yas/new-snippet)
   ("v" yas/visit-snippet-file)
   ("r" restart-emacs)
   ("z" eshell)
   ("s" hydra-search/body)
   ("m" hydra-markdown/body)
   (":" magit-status)
   (";" my:dot-emacs-dir)
   ("c" hydra-compile/body)
   ("B" hydra-browse/body)
   ("b" my:book-dir)
   ("g" my:github-show)
   ("@" howm-list-all)
   ("," org-capture)
   ("k" my:recompile)
   ("L" gist-region-or-buffer)
   ("l" gist-list)
   ("u" undo-tree-visualize)
   ("p" hydra-pinky/body)
   ("." hydra-work/body)
   ("/" kill-other-buffers)
   ("\\" delete-other-windows)
   ("_" delete-other-windows)
   ("M-." nil)))


(leaf *hydra-work-menu
  :bind ("M-," . hydra-work/body)
  :hydra
  (hydra-work
   (:hint nil :exit t)
   "
 📝 Work: _a_:合評  _d_:日記  _m_:毎日  _w_:毎週  _k_:兼題  _t_:定例  _g_:吟行  _o_:落穂  _n_:近詠  _s_:創作  _e_:Hugo  _b_ackup:di_r_"
   ("a" my:apsh)
   ("A" my:apsh-new-post)
   ("e" easy-hugo)
   ("b" my:backup-all)
   ("r" my:backup-dir)
   ("d" my:diary)
   ("D" my:diary-new-post)
   ("o" my:otibo)
   ("O" my:otibo-new-post)
   ("t" my:teirei)
   ("T" my:teirei-new-post)
   ("g" my:swan)
   ("G" my:swan-new-post)
   ("n" my:kinnei)
   ("N" my:kinnei-new-post)
   ("m" my:d_kukai)
   ("w" my:w_kukai)
   ("k" my:m_kukai)
   ("s" my:haiku-note)
   ("S" my:haiku-note-post)
   (":" view-mode)
   ("/" kill-other-buffers)
   ("_" delete-other-windows)
   ("." hydra-quick-menu/body)
   ("q" keyboard-quit)))


(leaf *user-defined-function
  :config
  (defun ftp-client ()
    "Open Ftp application."
    (interactive)
    (when (getenv "WSLENV")
      (shell-command "/mnt/c/\"Program Files\"/\"FileZilla FTP Client\"/filezilla.exe"))
    (unless (getenv "WSENV")
      (shell-command "filezilla")))

  (defun my:backup-all ()
    "Backup for melpa package."
    (interactive)
    (let* ((default-directory (expand-file-name "~/Dropbox/backup")))
      (shell-command "sh backup-all.sh"))
    (message "Finished buckuped!"))

  (defun my:haiku-note ()
    "Open haiku note file."
    (interactive)
    (find-file (format-time-string "~/Dropbox/howm/haiku/haikunote.%Y.md"))
    (goto-char (point-min)))

  (defun my:haiku-note-post ()
    "Insert template."
    (interactive)
    (find-file (format-time-string "~/Dropbox/howm/haiku/haikunote.%Y.md"))
    (goto-char (point-min))
    (forward-line 2)
    (insert
     (format-time-string "> %Y年%m月%d日 (%a)\n")
     (format-time-string "PLACE:\n\n"))
    (forward-line -2)
    (forward-char 6)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-menu.el ends here
