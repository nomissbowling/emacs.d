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
  ---^^^^^^^^^^^^^^^^^^^^^^^-----------------------------------------------------------------------------------------------------------
   _d_ropbox   _e_macs   _i_nits   _w_eb   GH:_h_   .emacs_;_^^^^   _l_aunch   pinky_:_   _r_estart   _m_arkdown   _u_ndotree^^   _p_ackage
   magit:_._   👀:_a_g   esh:_z_   _f_tp   e_2_ps   _y_as:_n_:_v_   _g_ithub   make:_k_   _c_ompile   _o_pen-url   howm:_,_:_@_   _t_ramp:_q_"
   ("2" my:pdfout-buffer)
   ("a" counsel-ag)
   ("p" hydra-package/body)
   ("o" browse-url-at-point)
   ("s" toggle-scratch)
   ("." magit-status)
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
   (":" hydra-pinky/body)
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
 📝  _d_:日記  _m_:毎日  _w_:WEB  _t_:定例  _s_:吟行  _o_:落穂  _k_:近詠  _n_:創作  _e_:Hugo  _g_ist:_l_  bkup:mel_p_a"
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
   ("p" backup-melpa)
   ("/" kill-other-buffers)
   ("_" delete-other-windows)
   ("." hydra-quick-menu/body)
   ("l" gist-list)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Pinky
(defhydra hydra-pinky (:color red :hint nil)
  "
 :_0_._1_._2_._3_._5_._o_._S_._x_._d_ :_j_._k_._h_._l_._c_._a_._e_._b_._SPC_._m_._w_._s_  :_+_._-_._r_  :_n_._p_._t_  :SB_:_  :_q_uit"
  ;; window
  ("0" delete-window)
  ("1" delete-other-windows)
  ("2" split-window-below)
  ("3" split-window-right)
  ("5" make-frame-command)
  ("o" other-window-or-split)
  ("S" window-swap-states)
  ("x" window-toggle-division)
  ("d" delete-frame)
  ;; page
  ("a" seq-home)
  ("e" seq-end)
  ("j" next-line)
  ("k" previous-line)
  ("l" forward-char)
  ("h" backward-char)
  ("c" recenter-top-bottom)
  ("<down>" next-line)
  ("<up>" previous-line)
  ("<right>" forward-char)
  ("<left>" backward-char)
  ("<C-up>" backward-paragraph)
  ("<C-down>" forward-paragraph)
  ("<C-left>" left-word)
  ("<C-right>" right-word)
  ("b" scroll-down-command)
  ("SPC" scroll-up-command)
  ("m" set-mark-command)
  ("w" avy-goto-word-1)
  ("s" swiper-isearch-region)
  ;; zoom
  ("+" text-scale-increase)
  ("-" text-scale-decrease)
  ("r" (text-scale-set 0))
  ;; git
  ("n" diff-hl-next-hunk)
  ("p" diff-hl-previous-hunk)
  ("t" git-timemachine)
  ;; other
  (":" counsel-switch-buffer)
  ;; ("<" iflipb-previous-buffer)
  ;; (">" iflipb-next-buffer)
  ;; quit
  ("q" nil))
(key-chord-define-global "::" 'hydra-pinky/body)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sequential-command
(use-package sequential-command-config
  :commands sequential-command-setup-keys
  :hook (after-init . sequential-command-setup-keys))

;; other-window-or-split
(bind-key
 "C-q"
 (defun other-window-or-split ()
   "If there is one window, open split window.
If there are two or more windows, it will go to another window."
   (interactive)
   (when (one-window-p)
     (split-window-horizontally))
   (other-window 1)))

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
