;;; 10_hydra-menu.el --- 10_hydra-menu.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf *hydra-quick-menu
  :bind (("M-." . hydra-quick-menu/body))
  :hydra
  (hydra-quick-menu
   (:hint nil :exit t)
   "
   🐳 Quick Menu
  ---^^^^^^^^^^^^^^^^^^^---------------------------------------------------------------------------------------------------------------------------------
   _d_ropbox   _e_macs.d^^   _i_nits   _w_eb   GH:_h_   .emacs_;_^^^^   _b_rowse   _G_ist:_l_   _r_estart   _m_arkdown   _u_ndotree^^   pdf:_1_;_2_   howm_@_
   magit:_:_   _t_ramp:_q_   _p_inky   _f_tp   _j_unk   _y_as:_n_:_v_   _g_ithub   make:_k_^^   _c_ompile   _o_pen-url   capture_,_^^   _s_cratch^^   _a_g:🐾   work:_._"
   ("1" my:pdfout-buffer)
   ("2" my:pdfout-region)
   ("a" counsel-ag)
   ("p" hydra-package/body)
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
   ("." hydra-work/body)
   ("s" toggle-scratch)
   ("m" hydra-markdown/body)
   ("M" hydra-magit/body)
   (":" magit-status)
   (";" my:dot-emacs-dir)
   ("c" hydra-compile/body)
   ("b" hydra-browse/body)
   ("g" my:github-show)
   ("j" open-junk-file)
   ("J" my:open-junk-file-dir)
   ("@" howm-list-all)
   ("," org-capture)
   ("k" my:recompile)
   ("G" gist-region-or-buffer)
   ("l" gist-list)
   ("u" undo-tree-visualize)
   ("p" hydra-pinky/body)
   ("P" hydra-package/body)
   ("<right>" hydra-work/body)
   ("/" kill-other-buffers)
   ("\\" delete-other-windows)
   ("_" delete-other-windows)
   ("M-." nil)))


(leaf *hydra-work-menu
  :chord ((".." . hydra-work/body))
  :hydra
  (hydra-work
   (:hint nil :exit t)
   "
 📝 Work: _a_:合評  _d_:日記  _m_:毎日  _w_:WEB  _t_:定例  _s_:吟行  _o_:落穂  _k_:近詠  _n_:創作  _e_:Hugo  bk:mel_p_a:el_g_et  quick-menu:_<left>_"
   ("a" my:apsh)
   ("A" my:apsh-new-post)
   ("e" easy-hugo)
   ("p" backup-melpa)
   ("g" backup-elget)
   ("d" my:diary)
   ("D" my:diary-new-post)
   ("o" my:otibo)
   ("O" my:otibo-new-post)
   ("t" my:teirei)
   ("T" my:teirei-new-post)
   ("s" my:swan)
   ("S" my:swan-new-post)
   ("k" my:kinnei)
   ("K" my:kinnei-new-post)
   ("m" my:d_kukai)
   ("w" my:m_kukai)
   ("n" my:haiku-note)
   ("N" my:haiku-note-post)
   (":" view-mode)
   ("/" kill-other-buffers)
   ("_" delete-other-windows)
   ("<left>" hydra-quick-menu/body)
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

  (defun backup-melpa ()
    "Backup for melpa package."
    (interactive)
    (let* ((default-directory (expand-file-name "~/Dropbox/backup")))
      (shell-command "sh backup-melpa.sh"))
    (message "Finished melpa buckuped!")))

(defun backup-elget ()
  "Backup for melpa package."
  (interactive)
  (let* ((default-directory (expand-file-name "~/Dropbox/backup")))
    (shell-command "sh backup-elget.sh"))
  (message "Finished el-get buckuped!"))

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
  (forward-char 6))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-menu.el ends here
