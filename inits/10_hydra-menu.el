;;; 10_hydra-menu.el --- 10_hydra-menu.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; Hydra Quick menu
(bind-key
 "M-."
 (defhydra hydra-quick-menu (:hint nil :exit t)
   "
   🐳 Quick Menu
  ---^^^^^^^^^^^^^^^^^^^^-------------------------------------------------------------------------------------------------------------------------
   _d_ropbox^^   _e_macs   _i_nits^^   _w_eb   GH:_h_^^   .emacs_;_^^^^   _b_rowse   pinky_:_   _r_estart   _m_arkdown   _u_ndotree^^   _p_ackage   isearch:_[_:_]_
   magit:_s_   _a_g:🐾   _G_ist_l_   _f_tp   p_1_:_2_   _y_as:_n_:_v_   _g_ithub   make:_k_   _c_ompile   _o_pen-url   howm:_,_:_@_   _t_ramp:_q_   day-works:_._"
   ("1" my:pdfout-buffer)
   ("2" my:pdfout-region)
   ("a" counsel-ag)
   ("p" hydra-package/body)
   ("o" browse-url-at-point)
   ("f" ftp-client)
   ("t" my:tramp-xsrv)
   ("q" my:tramp-quit)
   ("d" my:dropbox)
   ("D" my:documents)
   ("i" my:inits-dir)
   ("e" my:emacs-dir)
   ("w" my:www-dir)
   ("h" my:gh-dir)
   ("y" ivy-yasnippet)
   ("n" yas/new-snippet)
   ("v" yas/visit-snippet-file)
   ("r" restart-emacs)
   ("z" eshell)
   ("]" isearch-forward)
   ("[" isearch-backward)
   ("s" magit-status)
   ("m" hydra-markdown/body)
   (":" hydra-pinky/body)
   (";" my:dot-emacs-dir)
   ("c" hydra-make/body)
   ("b" dashboard-hydra/body)
   ("g" my:github-show)
   ("j" open-junk-file)
   ("J" my:open-junk-file-dir)
   ("@" howm-list-all)
   ("," hydra-howm/body)
   ("k" my:recompile)
   ("G" gist-region-or-buffer)
   ("l" gist-list)
   ("u" undo-tree-visualize)
   ("." hydra-work/body)
   ("/" kill-other-buffers)
   ("\\" delete-other-windows)
   ("_" delete-other-windows)
   ("M-." nil)))

;; Hydra Work
(bind-key
 "<hiragana-katakana>"
 (defhydra hydra-work (:hint nil :exit t)
   "
 📝 Work: _a_:合評  _d_:日記  _m_:毎日  _w_:WEB  _t_:定例  _s_:吟行  _o_:落穂  _k_:近詠  _n_:創作  _e_:Hugo  _b_ackup-melpa  quick-menu:_._"
   ("a" my:apsh)
   ("A" my:apsh-new-post)
   ("e" easy-hugo)
   ("b" backup-melpa)
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
   ("." hydra-quick-menu/body)
   ("q" keyboard-quit)))

(prog1 "My function"
  (defun ftp-client ()
    "Open Ftp application."
    (interactive)
    (when (getenv "WSLENV")
      (shell-command "/mnt/c/\"Program Files\"/\"FileZilla FTP Client\"/filezilla.exe"))
    (when (getenv "")
      (shell-command "filezilla")))
  (defun backup-melpa ()
    "Backup for melpa package."
    (interactive)
    (let* ((default-directory (expand-file-name "~/Dropbox/backup")))
      (shell-command "sh melpabackup.sh"))
    (message "Finished melpa buckup!")))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_hydra-menu.el ends here

