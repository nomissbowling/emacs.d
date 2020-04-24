;;; 10_hydra-misc.el --- 10_hydra-misc.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf package-utils
  :ensure t
  :chord ("p@" . hydra-package/body)
  :bind ("C-c p" . hydra-package/body)
  :hydra
  (hydra-package
   (:color red :hint nil)
   "
 📦 Package: _i_nstall   _u_pgrade   _r_emove   _a_ll-update   _l_ist"
   ("i" package-install)
   ("u" package-utils-list-upgrades)
   ("r" package-utils-remove-by-name)
   ("a" package-utils-upgrade-all-and-restart)
   ("l" package-list-packages)
   ("q" nil)))

(leaf gist
  :ensure t
  :bind (("C-c g" . gist-region-or-buffer)
	 ("C-c l" . gist-list)
	 (:tabulated-list-mode-map
	  ("." . hydra-gist-help/body)))
  :hydra
  (hydra-gist-help ()
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
		   ("." nil)))

(leaf *hydra-browse
  :hydra
  (hydra-browse
   (:hint nil :exit t)
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
   ("." nil)))


(leaf *browse-in-WSL
  :doc "Emacs in WSL and opening links"
  :url "https://adam.kruszewski.name/2017/09/emacs-in-wsl-and-opening-links/"
  :if (getenv "WSLENV")

  :config
  (let ((cmd-exe "/mnt/c/Windows/System32/cmd.exe")
	(cmd-args '("/c" "start")))
    (when (file-exists-p cmd-exe)
      (setq browse-url-generic-program  cmd-exe
	    browse-url-generic-args     cmd-args
	    browse-url-browser-function 'browse-url-generic
	    search-web-default-browser 'browse-url-generic))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 10_hydra-misc.el ends here
