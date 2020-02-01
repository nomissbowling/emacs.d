;;; 01_dashboard.el --- 01_dashboard.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package dashboard
  :bind (([f10] . open-dashboard)
	 :map dashboard-mode-map
	 ("c" . browse-calendar)
	 ("w" . browse-weather)
	 ("m" . browse-gmail)
	 ("t" . browse-tweetdeck)
	 ("s" . browse-slack)
	 ("h" . browse-homepage)
	 ("p" . browse-pocket)
	 ("." . dashboard-hydra/body)
	 ([f10] . quit-dashboard))
  :init (dashboard-setup-startup-hook)
  :config
  (setq dashboard-banner-logo-title
	(concat "GNU Emacs " emacs-version " kernel "
		(car (split-string (shell-command-to-string "uname -r")))  " Debian "
		(car (split-string (shell-command-to-string "cat /etc/debian_version"))) " 86_64 GNU/Linux")))

;; Set the banner
(setq dashboard-startup-banner "~/Dropbox/emacs.d/emacs.png")

;; Use icons
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)

;; Set the footer
(setq dashboard-footer "Always be joyful. Never stop praying. Be thankful in all circumstances!")
(setq dashboard-footer-icon
      (all-the-icons-octicon "dashboard" :height 1.1 :v-adjust -0.05 :face 'font-lock-keyword-face))
;; (setq dashboard-page-separator "\n\f\f\n")
(setq dashboard-items '((recents  . 9)))

;; Insert custom item
(defun dashboard-insert-custom (list-size)
  "Insert custom and set LIST-SIZE."
  (interactive)
  (insert (if (display-graphic-p)
	      (all-the-icons-faicon "google" :height 1.2 :v-adjust -0.05 :face 'error) " "))
  (insert "   Calendar: (c)    Weather: (w)    Mail: (m)    Twitter: (t)    Pocket: (p)    Slack: (s)    GH: (h)" ))
(add-to-list 'dashboard-item-generators  '(custom . dashboard-insert-custom))
(add-to-list 'dashboard-items '(custom) t)

(defun open-dashboard ()
  "Open the *dashboard* buffer and jump to the first widget."
  (interactive)
  (delete-other-windows)
  (setq default-directory "~/")
  ;; Refresh dashboard buffer
  (if (get-buffer dashboard-buffer-name)
      (kill-buffer dashboard-buffer-name))
  (dashboard-insert-startupify-lists)
  (switch-to-buffer dashboard-buffer-name)
  ;; Jump to the first section
  (goto-char (point-min))
  (dashboard-goto-recent-files))

(defvar dashboard-recover-layout-p nil
  "Wether recovers the layout.")

(defun quit-dashboard ()
  "Quit dashboard window."
  (interactive)
  (quit-window t)
  (when (and dashboard-recover-layout-p
	     (bound-and-true-p winner-mode))
    (winner-undo)
    (setq dashboard-recover-layout-p nil)))

(defun dashboard-goto-recent-files ()
  "Go to recent files."
  (interactive)
  (funcall (local-key-binding "r")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; browse-url
(defun browse-calendar ()
  "Open keep with chrome."
  (interactive)
  (browse-url "https://calendar.google.com/calendar/r"))
(defun browse-weather  ()
  "Open tenki with chrome."
  (interactive)
  (browse-url "https://tenki.jp/week/6/31/"))
(defun browse-pocket ()
  "Open pocket with chrome."
  (interactive)
  (browse-url "https://getpocket.com/a/queue/"))
(defun browse-homepage ()
  "Open my homepage."
  (interactive)
  (browse-url "https://gospel-haiku.com/"))
(defun browse-gmail ()
  "Open gmail with chrome."
  (interactive)
  (browse-url "https://mail.google.com/mail/u/0/?tab=rm#inbox"))
(defun browse-tweetdeck ()
  "Open tweetdeck with chrome."
  (interactive)
  (browse-url "https://tweetdeck.twitter.com/"))
(defun browse-slack ()
  "Open slack with chrome."
  (interactive)
  (browse-url "https://emacs-jp.slack.com/messages/C1B73BWPJ/"))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 01_dashboard.el ends here
