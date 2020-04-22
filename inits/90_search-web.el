;;; 90_search-web.el --- 90_search-web.el  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf search-web
  :ensure t
  :url "https://github.com/tomoya/search-web.el"
  :bind ("M-s" . hydra-search/body)
  :commands search-web-dwim

  :config
  (add-to-list 'search-web-engines '("weblio" "https://www.weblio.jp/content/%s" nil))
  (add-to-list 'search-web-engines '("kobun" "https://kobun.weblio.jp/content/%s" nil))
  (add-to-list 'search-web-engines '("ruigo" "https://thesaurus.weblio.jp/content/%s" nil))
  (add-to-list 'search-web-engines '("google maps" "http://maps.google.co.jp/maps?hl=ja&q=%s" nil))
  (add-to-list 'search-web-engines '("qitta" "https://qiita.com/search?q=%s" nil))
  (add-to-list 'search-web-engines '("post" "https://postcode.goo.ne.jp/search/q/%s/" nil))
  (add-to-list 'search-web-engines '("earth" "https://earth.google.com/web/search/%s/" nil))
  (add-to-list 'search-web-engines '("amazon jp" "http://www.amazon.co.jp/gp/search?index=blended&field-keywords=%s" nil))
  (add-to-list 'search-web-engines '("yodobashi" "https://www.yodobashi.com/?word=%s" nil))
  (add-to-list 'search-web-engines '("yahoo jp" "http://search.yahoo.co.jp/search?p=%s" nil))
  (add-to-list 'search-web-engines '("eijiro" "http://eow.alc.co.jp/%s/UTF-8/" nil))  ;; hydra

  :hydra
  (hydra-search
   (:hint nil :exit t)
   "
 🔍  _a_mazon  _y_odobashi  _g_oogle  _e_ijiro  _m_aps  _q_itta  _w_eblio  g_o_o  _p_:〒  _k_:古語  _r_:類語"
   ("a" (search-web-dwim "amazon jp"))
   ("e" (search-web-dwim "eijiro"))
   ("g" (search-web-dwim "google"))
   ("o" (search-web-dwim "goo"))
   ("m" (search-web-dwim "google maps"))
   ("q" (search-web-dwim "qitta"))
   ("w" (search-web-dwim "weblio"))
   ("p" (search-web-dwim "post"))
   ("k" (search-web-dwim "kobun"))
   ("y" (search-web-dwim "yodobashi"))
   ("r" (search-web-dwim "ruigo"))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 90_search-web.el ends here
