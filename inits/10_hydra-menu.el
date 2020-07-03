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
  ---^^^^^^^^^^^^^^^^^^^--------------------------------------------------------------------------------------------------------------
    _d_ropbox   _e_macs.d^^   _i_nits   _w_eb   GH:_h_   .emacs_;_^^^^   _b_rowse   _g_ithub   _r_estart   _m_arkdown   _u_ndotree   howm:_@_
    magit:_:_   _t_ramp:_q_   _p_inky   _f_tp   _a_g🐾   _y_as:_n_:_v_   _s_earch   make:_k_   _c_ompile   _o_pen-url   capture_,_   work:_._"
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
   ("s" counsel-web-suggest)
   ("m" hydra-markdown/body)
   (":" magit-status)
   (";" my:dot-emacs-dir)
   ("c" hydra-compile/body)
   ("b" hydra-browse/body)
   ("p" hydra-pinky/body)
   ("g" my:github-show)
   ("@" howm-list-all)
   ("," org-capture)
   ("k" my:make-k)
   ("u" undo-tree-visualize)
   ("." hydra-work/body)
   ("x" hydra-work/body)
   ("/" kill-other-buffers)
   ("\\" delete-other-windows)
   ("_" delete-other-windows)
   ("M-." nil)))


(leaf *hydra-work-menu
  :bind ("s-x" . hydra-work/body)
  :hydra
  (hydra-work
   (:hint nil :exit t)
   "
   📝 Work: _a_:合評  _d_:日記  _m_:毎日  _w_:毎週  _k_:兼題  _t_:定例  _g_:吟行  _o_:落穂  _n_:近詠  創作:_[_:_]_  _e_:Hugo  _j_unk  _b_ackup"
   ("a" my:apsh)
   ("A" my:apsh-new-post)
   ("e" easy-hugo)
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
   ("b" my:backup-all)
   ("B" my:backup-dir)
   ("j" open-junk-file)
   ("J" my:junk-file-dir)
   (":" view-mode)
   ("/" kill-other-buffers)
   ("_" delete-other-windows)
   ("." hydra-quick-menu/body)
   ("x" hydra-quick-menu/body)
   ("[" my:haiku-note)
   ("]" my:haiku-note-post)
   ("q" keyboard-quit)
   ("s-x" nil)))


(leaf *user-defined-function
  :config
  (defun ftp-client ()
    "Open Ftp application."
    (interactive)
    (when (getenv "WSLENV")
      (shell-command "/mnt/c/\"Program Files\"/\"FileZilla FTP Client\"/filezilla.exe"))
    (unless (getenv "WSENV")
      (shell-command "filezilla")))

  (defun select-espy-command ()
    "Narrow the only espy command in M-x."
    (interactive)
    (counsel-M-x "^espy"))

  (defun my:backup-all ()
    "Backup for melpa package."
    (interactive)
    (let* ((default-directory (expand-file-name "~/Dropbox/backup")))
      (shell-command "sh backup-all.sh"))
    (message "Finished buckuped!")))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-menu.el ends here
