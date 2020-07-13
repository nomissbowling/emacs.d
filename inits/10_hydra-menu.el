;;; 10_hydra-menu.el --- 10_hydra-menu.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(eval-when-compile
  (leaf *hydra-quick-menu
    :bind ("M-." . hydra-quick-menu/body)
    :hydra
    (hydra-quick-menu
     (:hint nil :exit t)
     "
  🐳 Quick Menu
  ---^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-------------------------------------------------------------------------------------------------------------
    _d_ropbox^^   _e_macs.d   _i_nits   _w_eb   .emacs_;_^^^^   GH:_h_   _b_rowse   _g_ithub   _r_estart   _m_arkdown   _u_ndotree   howm:_@_
    _t_ramp:_q_   magit._:_   _l_inux   _f_tp   _y_as:_n_:_v_   _a_g🐾   _s_earch   make:_k_   _c_ompile   _o_pen-url   capture_,_   _p_asswd"
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
     (":" magit-status)
     (";" my:dot-emacs-dir)
     ("c" hydra-compile/body)
     ("b" hydra-browse/body)
     ("2" my:pdfout-buffer)
     ("p" open-keepass)
     ("g" my:github-show)
     ("@" howm-list-all)
     ("," org-capture)
     ("k" my:make-k)
     ("l" counsel-linux-app)
     ("u" undo-tree-visualize)
     ("." hydra-work/body)
     ("x" hydra-work/body)
     ("/" kill-other-buffers)
     ("\\" delete-other-windows)
     ("_" delete-other-windows)
     ("<muhenkan>" nil)
     ("M-." nil)))


  (leaf *hydra-work-menu
    :bind ("s-x" . hydra-work/body)
    :hydra
    (hydra-work
     (:hint nil :exit t)
     "
  📝 Work Menu
  --------------^^^^^^^^^^^^^^^^^^^^^^^--------------------------------------------------------------------------------------
    Work: _a_:合評^^   _d_:日記   _m_:毎日   _w_:毎週   _k_:兼題   _t_:定例   _s_:吟行   _o_:落穂   _n_:近詠   創作:_[_:_]_
    Tool: _g_ist:_l_   _e_:Hugo   _j_unk🐾   _b_ackup   el_p_a🐾   _r_g(mi)   ps_2_pdf   print_:_   _f_lickr   🐾"
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
     ("p" hydra-package/body)
     ("2" my:pdfout-buffer)
     (":" my:ps-print)
     ("/" kill-other-buffers)
     ("_" delete-other-windows)
     ("." hydra-quick-menu/body)
     ("x" hydra-quick-menu/body)
     ("[" my:haiku-note)
     ("]" my:haiku-note-post)
     ("j" open-junk-file)
     ("J" my:junk-file-dir)
     ("f" (browse-url "https://www.flickr.com/photos/minorugh/"))
     ("<muhenkan>" nil)
     ("s-x" nil)))


  (leaf *user-defined-function
    :config
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
      (message "Finished buckuped!"))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-menu.el ends here
