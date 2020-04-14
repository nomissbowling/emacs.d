;;; 10_hydra-misc.el --- 10_hydra-misc.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;; Hydra Pinky
(key-chord-define-global
 "jk"
 (defhydra hydra-pinky (:color red :hint nil)
   "
 🐳 Pinky: _h_._l_._j_._k_._a_._e_._SPC_._b_._g_._G_._o_._w_._@_._s_._S_._/_._v_._f_._0_._1_._2_._3_._x_._<_._>_._:_"
   ("h" backward-char)
   ("j" next-line)
   ("k" previous-line)
   ("l" forward-char)
   ("<left>" backward-char)
   ("<down>" next-line)
   ("<up>" previous-line)
   ("<right>" forward-char)
   ("a" beginning-of-line)
   ("e" end-of-line)
   ("SPC" scroll-up-command)
   ("b" scroll-down-command)
   ("<next>" scroll-up-command)
   ("<prior>" scroll-down-command)
   ("g" beginning-of-buffer)
   ("G" end-of-buffer)
   ("o" other-window-or-split)
   ("w" avy-goto-word-1)
   ("@" recenter-top-bottom)
   ("s" swiper-isearch-region)
   ("S" window-swap-states)
   ("/" kill-buffer)
   ("v" vc-diff)
   ("f" counsel-find-file)
   ("0" delete-window)
   ("1" delete-other-windows)
   ("2" split-window-below)
   ("3" split-window-right)
   ("x" window-toggle-division)
   ("<" iflipb-next-buffer)
   (">" iflipb-previous-buffer)
   (":" counsel-switch-buffer)
   ("." view-mode)))

(bind-key
 "C-q"
 (defun other-window-or-split ()
   "If there is one window, open split window.
If there are two or more windows, it will go to another window."
   (interactive)
   (when (one-window-p)
     (split-window-horizontally))
   (other-window 1)))
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

;; Package-utils
(defhydra hydra-package (:color red :hint nil)
  "
 📦 Package: _i_nstall   _u_pgrade   _r_emove   _a_ll-update   _l_ist"
  ("i" package-install)
  ("u" package-utils-list-upgrades)
  ("r" package-utils-remove-by-name)
  ("a" package-utils-upgrade-all-and-restart)
  ("l" package-list-packages))

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

;; Dashoard-hydra
(defhydra dashboard-hydra (:hint nil :exit t)
  "
  💰 Shop^        ^💭 SNS^        ^🔃 Repos^       ^🏠 GH^        ^🙌 Favorite^    ^📝 Others^    ^💣 Github^^      Google
  ^^^^^^^^^^----------------------------------------------------------------------------------------------------------------
  _a_: Amazon      _t_: Twitter    _g_: github      _h_: HOME      _j_: Jorudan     _c_: Chrome    _1_: masasam     _5_: Keep
  _r_: Rakuten     _u_: Youtube    _0_: gist        _b_: Hatena    _n_: News        _p_: Pocket    _2_: abo-abo     _6_: Map
  _y_: Yodobashi   _f_: Flickr     _d_: Dropbox     _e_: Essay     _w_: Weather     _q_: Qiita     _3_: blue        _7_: Drive
  _k_: Kakaku      _l_: Tumblr     _x_: Xserver     _:_: Blog      _s_: SanyoBas    _,_: Slack     _4_: seagle      _8_: Photo"
  ("a" (browse-url "https://www.amazon.co.jp/"))
  ("r" (browse-url "https://www.rakuten.co.jp/"))
  ("y" (browse-url "https://www.yodobashi.com/"))
  ("k" (browse-url "http://kakaku.com/"))
  ("u" (browse-url "https://www.youtube.com/channel/UCnwoipb9aTyORVKHeTw159A/videos"))
  ("f" (browse-url "https://www.flickr.com/photos/minorugh/"))
  ("g" (browse-url "https://github.com/minorugh/emacs.d"))
  ("0" (browse-url "https://gist.github.com/minorugh"))
  ("1" (browse-url "https://github.com/masasam/dotfiles/tree/master/.emacs\.d"))
  ("2" (browse-url "https://github.com/abo-abo/hydra/wiki"))
  ("3" (browse-url "https://github.com/blue0513?tab=repositories"))
  ("4" (browse-url "https://github.com/seagle0128/.emacs\.d/tree/master/lisp"))
  ("5" (browse-url "https://keep.google.com/u/0/"))
  ("6" (browse-url "https://www.google.co.jp/maps"))
  ("7" (browse-url "https://drive.google.com/drive/u/0/my-drive"))
  (":" (browse-url "http://blog.wegh.net/"))
  ("e" (browse-url "http://essay.wegh.net/"))
  ("b" (browse-url "https://minoru.hatenablog.com/"))
  ("s" (browse-url "http://www.sanyo-bus.co.jp/pdf/20191028tarusan_schedule.pdf"))
  ("j" (browse-url "https://www.jorudan.co.jp/"))
  ("n" (browse-url "https://news.yahoo.co.jp/"))
  ("x" (browse-url "https://www.xserver.ne.jp/login_server.php"))
  ("d" (browse-url "https://www.dropbox.com/home"))
  ("q" (browse-url "https://qiita.com/tags/emacs"))
  ("8" (browse-url "https://photos.google.com/?pageId=none"))
  ("c" (browse-url "https://google.com"))
  ("l" (browse-url "https://minorugh.tumblr.com"))
  ("w" browse-weather)
  ("h" browse-homepage)
  ("p" browse-pocket)
  ("t" browse-tweetdeck)
  ("," browse-slack)
  ("." nil))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 10_hydra-misc.el ends here
