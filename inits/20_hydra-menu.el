;;; 20_hydra-menu.el --- 20_hydra-menu.el
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
  ---^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-------------------------------------------------------------------------------------------------------------
    _d_ropbox^^   _e_macs.d^^   _i_nits   _w_eb   .emacs_;_^^^^   GH:_h_   _b_rowse   _g_ithub   _r_estart   _m_arkdown   _u_ndotree   howm_@_
    _t_ramp:_q_   git:_[_._]_   f_l_ych   _f_tp   _y_as:_n_:_v_   _a_g🐾   _s_earch   make:_k_   _c_ompile   _o_pen-url   capture_,_   view_:_"
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
   ("]" counsel-rg)
   ("r" restart-emacs)
   ("s" counsel-web-suggest)
   ("m" hydra-markdown/body)
   (":" my:view-mode)
   (";" my:dot-emacs-dir)
   ("c" hydra-compile/body)
   ("b" hydra-browse/body)
   ("2" my:pdfout-buffer)
   ("g" my:github-show)
   ("@" howm-list-all)
   ("," org-capture)
   ("k" my:make-k)
   ("l" counsel-flycheck)
   ("u" undo-tree-visualize)
   ("." hydra-work/body)
   ("x" hydra-work/body)
   ("p" hydra-pinky/body)
   ("/" kill-other-buffers)
   ("_" delete-other-windows)
   ("[" hydra-magit/body)
   ("]" magit-status)
   ("<muhenkan>" nil)
   ("M-." nil)))


(leaf *hydra-work-menu
  :bind ("s-x" . hydra-work/body)
  :hydra
  (hydra-work
   (:hint nil :exit t)
   "
  📝 Work Menu
  --------------^^^^^^^^^^^^^^^^^^^^^^^^^-------------------------------------------------------------------------------------
    Work: _a_:合評^^   _d_:日記   _m_:毎日   _w_:毎週   _k_:兼題   _t_:定例   _s_:吟行   _o_:落穂   _n_:近詠   創作:_[_:_]_
    Tool: _g_ist:_l_   _e_:Hugo   _j_unk🐾   _b_ackup   _p_asswd   ps_2_pdf   print_:_   _f_lickr   theme_;_   _i_ndex.md"
   ("a" my:apsh)
   ("A" my:apsh-new-post)
   ("e" easy-hugo)
   ("d" my:diary)
   ("D" my:diary-new-post)
   ("o" my:otibo)
   ("O" my:otibo-new-post)
   ("t" my:teirei)
   ("T" my:teirei-new-post)
   ("s" my:swan)
   ("S" my:swan-new-post)
   ("n" my:kinnei)
   ("N" my:kinnei-new-post)
   ("m" my:d_kukai)
   ("w" my:w_kukai)
   ("k" my:m_kukai)
   ("b" my:backup-all)
   ("B" my:backup-dir)
   ("g" gist-region-or-buffer)
   ("l" gist-list)
   ("r" counsel-rg)
   ("@" hydra-package/body)
   ("p" open-keepass)
   ("2" pdfout-select)
   (":" my:ps-print)
   (";" my:cycle-theme)
   ("/" kill-other-buffers)
   ("_" delete-other-windows)
   ("." hydra-quick-menu/body)
   ("x" hydra-quick-menu/body)
   ("[" my:haiku-note)
   ("]" my:haiku-note-post)
   ("j" open-junk-file)
   ("J" my:junk-file-dir)
   ("v" view-mode)
   ("i" my:inits-doc)
   ("f" (browse-url "https://www.flickr.com/photos/minorugh/"))
   ("<muhenkan>" nil)
   ("s-x" nil)))


(leaf *user-defined-function
  :config
  (defun my:view-mode ()
    "Narrow the only counsel-command in M-x."
    (interactive)
    (view-mode)
    (hydra-view-mode/body))

  (defun my:ps-print ()
    "Narrow the only counsel-command in M-x."
    (interactive)
    (counsel-M-x "^ps-print "))

  (defun ftp-client ()
    "Open Ftp application."
    (interactive)
    (when (getenv "WSLENV")
      (shell-command "/mnt/c/\"Program Files\"/\"FileZilla FTP Client\"/filezilla.exe"))
    (unless (getenv "WSENV")
      (shell-command "filezilla")))

  (defun open-keepass ()
    "Narrow the only espy command in M-x."
    (interactive)
    (compile "keepassxc"))

  (defun open-calculator ()
    "Narrow the only espy command in M-x."
    (interactive)
    (compile "gnome-calculator"))

  (defun my:backup-all ()
    "Backup for melpa package."
    (interactive)
    (let* ((default-directory (expand-file-name "~/Dropbox/backup")))
      (shell-command "sh backup-all.sh"))
    (message "Finished buckuped!")))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 20_hydra-menu.el ends here
