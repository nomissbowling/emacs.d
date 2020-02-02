;;; 10_hydra.el --- 10_hydra.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Quick menu
(bind-key
 "M-."
 (defhydra hydra-quick-menu (:hint nil :exit t)
   "
   🐳 Quick Menu
  ---^^^^^^^^^^^^^^^^^^^^-------------------------------------------------------------------------------------------------------------------------
   _d_ropbox^^   _e_macs   _i_nits   _w_eb   GH:_h_^^   .emacs_;_^^^^   _l_aunch   _s_wiper   _r_estart   _m_arkdown   _u_ndotree^^   _p_ackage   _b_ackup-melpa
   magit_:__._   _a_g:🐾   esh:_z_   _f_tp   p_1_:_2_   _y_as:_n_:_v_   _g_ithub   make:_k_   _c_ompile   _o_pen-url   howm:_,_:_@_   _t_ramp:_q_   work:_<right>_"
   ("1" my:pdfout-buffer)
   ("2" my:pdfout-region)
   ("a" counsel-ag)
   ("b" backup-melpa)
   ("p" hydra-package/body)
   ("o" browse-url-at-point)
   ("f" ftp-client)
   ("t" my:tramp-xsrv)
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
   ("s" swiper-thing-at-point)
   (":" hydra-magit/body)
   ("." magit-status)
   ("m" hydra-markdown/body)
   (";" my:dot-emacs-dir)
   ("c" hydra-compile/body)
   ("l" dashboard-hydra/body)
   ("g" my:github-show)
   ("j" open-junk-file)
   ("J" my:open-junk-file-dir)
   ("@" howm-list-all)
   ("," hydra-howm/body)
   ("k" my:recompile)
   ("u" undo-tree-visualize)
   ("<right>" hydra-work/body)
   ("/" kill-other-buffers)
   ("\\" delete-other-windows)
   ("_" delete-other-windows)
   ("M-." nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; My work
(bind-key
 "M-:"
 (defhydra hydra-work (:hint nil :exit t)
   "
 📝  _d_:日記  _m_:毎日  _w_:WEB  _t_:定例  _s_:吟行  _o_:落穂  _k_:近詠  _n_:創作  _e_:Hugo  _g_ist:_._  _<left>_:back"
   ("e" easy-hugo)
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
   ("<right>" dashboard-hydra/body)
   ("." gist-list)
   ("g" gist-region-or-buffer)
   ("q" keyboard-quit)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package-utils
(defhydra hydra-package (:color red :hint nil)
  "
 📦 Package: _i_nstall   _u_pgrade   _r_emove   _a_ll-update   _l_ist"
  ("i" package-install)
  ("u" package-utils-list-upgrades)
  ("r" package-utils-remove-by-name)
  ("a" package-utils-upgrade-all-and-restart)
  ("l" package-list-packages))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Gist help
(bind-key "." 'hydra-gist-help/body tabulated-list-mode-map)
(defhydra hydra-gist-help ()
  "
  🎲 Function for gist
     M-x gist-list: Lists your gists in a new buffer
     M-x gist-region-or-buffer: Post either the current region or buffer
    -----------------------------
  🎲 In gist-list buffer
     RET:fetch  e:edit-description  g:list-reload  b:browse current  y:print current url
     +:add file to current  -:remove file from current  k:delete current
    -----------------------------
  🎲 In fetch file buffer
     C-x C-s : save a new version of the gist
     C-x C-w : rename some file
    -----------------------------
  🎲 In dired buffer
     @ : make a gist out of marked files"
  ("." nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; my:functions
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
  (message "Finished melpa buckup!"))

;; other-window-or-split
(bind-key
 "C-q"
 (defun other-window-or-split ()
   "If there is one window, open split window.
If there are two or more windows, it will go to another window."
   (interactive)
   (when (one-window-p)
     (split-window-horizontally))
   (other-window 1)
   (hydra-pinky/body)))

(key-chord-define-global
 "jk"
 (defhydra hydra-pinky (:color red :hint nil)
   "
 🐳: _h_._l_._j_._k_._a_._e_._f_._b_._g_._G_._o_._w_._@_._s_._S_._/_._0_._1_._2_._3_._x_._<_._>_._:_"
   ("h" backward-char)
   ("j" next-line)
   ("k" previous-line)
   ("l" forward-char)
   ("a" beginning-of-line)
   ("e" end-of-line)
   ("f" scroll-up-command)
   ("<SPC>" scroll-up-command)
   ("b" scroll-down-command)
   ("g" beginning-of-buffer)
   ("G" end-of-buffer)
   ("o" other-window-or-split)
   ("w" avy-goto-word-1)
   ("@" recenter-top-bottom)
   ("s" swiper-isearch-region)
   ("S" window-swap-states)
   ("/" kill-buffer)
   ("0" delete-window)
   ("1" delete-other-windows)
   ("2" split-window-below)
   ("3" split-window-right)
   ("x" window-toggle-division)
   ("<" iflipb-next-buffer)
   (">" iflipb-previous-buffer)
   (":" counsel-switch-buffer)))

;; window-toggle-division
(defun window-toggle-division ()
  "Replace vertical <-> horizontal when divided into two."
  (interactive)
  (unless (= (count-windows 1) 2)
    (error "Not divided into two!"))
  (let ((before-height)
        (other-buf (window-buffer (next-window))))
    (setq before-height (window-height))
    (delete-other-windows)
    (if (= (window-height) before-height)
        (split-window-vertically)
      (split-window-horizontally))
    (other-window 1)
    (switch-to-buffer other-buf)
    (other-window -1)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_hydra.el ends here
