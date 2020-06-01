;;; 80_wanderlust.el --- 80_wanderlust.el  -*- lexical-binding: t -*-

;; git porcelain inside emacs

;;; Code:
;; (setq debug-on-erro t)

(leaf wanderlust
  :ensure t
  :config
  ;; Wanderlust で　Gmail!!
  (setq ssl-certificate-verification-policy 1)
  (autoload 'wl "wl" "Wanderlust" t)
  (autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
  (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t))


;; Messageバッファでwin-switch-to-windowすると落ちる †
(defadvice win-switch-to-window
    (before win-switch-to-window-check-wl-mime-view ())
  (if (string-match "WL:Message"
                    (buffer-name (window-buffer)))
      (switch-to-buffer "*scratch*")))
(ad-activate-regexp
 "win-switch-to-window-check-wl-mime-view")

(defun wl-summary-overview-entity-compare-by-reply-number (a b)
  "Compare entity A and B by latest number of replies."
  (let ((fx #'(lambda (x)
                (setq x (elmo-message-entity-number x))
                (apply 'max x (wl-thread-entity-get-descendant
                               (wl-thread-get-entity x))))))
    (< (funcall fx a) (funcall fx b))))
(add-to-list 'wl-summary-sort-specs 'reply-number)

;; (setq elmo-imap4-use-modified-utf7 t) ; 日本語フォルダ対策

;; ;; (setq ssl-program-name "openssl")


;; ;; SMTP サーバの設定
;; (setq wl-smtp-connection-type 'starttls)
;; (setq wl-smtp-posting-port 587)
;; (setq wl-smtp-authenticate-type "plain")
;; (setq wl-smtp-posting-user "minorugh")
;; (setq wl-smtp-posting-server "smtp.gmail.com")
;; (setq wl-local-domain "gmail.com")

;; ;; デフォルトのフォルダ
;; (setq wl-default-folder "%inbox")
;; ;; 削除をGmail仕様に
;; ;; (setq wl-dispose-folder-alist
;; ;;       (cons '("^%inbox" . remove) wl-dispose-folder-alist))
;; ;; フォルダ名補完時に使用するデフォルトのスペック
;; (setq wl-default-spec "%")
;; (setq wl-draft-folder "%[Gmail]/Drafts") ; Gmail IMAPの仕様に合わせて
;; (setq wl-trash-folder "%[Gmail]/Trash")
;; ;; 画面を普通のメーラみたいな 3ペインに
;; 					;(setq wl-stay-folder-window t)
;; ;; 下書きディレクトリをローカルに設定する.
;; (setq wl-draft-folder "+Drafts")
;; (setq wl-folder-check-async t) ; 非同期でチェックするように
;; ;; 大きなメッセージを分割して送信しない(デフォルトはtで分割する)
;; ;; (setq mime-edit-split-message nil)
;; ;; 起動時からオフラインにする
;; ;; (setq wl-plugged nil)
;; ;; サマリモードで日時を英語表示
;; ;; (setq wl-summary-weekday-name-lang 'en)
;; ;; HTMLファイルは表示しない。
;; ;;(setq mime-setup-enable-inline-html nil)
;; ;; メールを書くときは見出し画面を残して、フル画面にする
;; (setq wl-draft-reply-buffer-style 'keep)
;; ;; 送信済みIMAPフォルダは送信と同時に既読にする
;; (setq wl-fcc-force-as-read t)
;; ;; 最初からスレッドを開いておかない
;; ;;(setq wl-thread-insert-opened nil)
;; ;; スレッドを分割するしきい値(デフォルト：30)
;; (setq wl-summary-max-thread-depth 30)
;; ;; 警告無しに開けるメールサイズの最大値(デフォルト：30K)
;; (setq elmo-message-fetch-threshold 500000)
;; ;; プリフェッチ時に確認を求めるメールサイズの最大値(デフォルト：30K)
;; (setq wl-prefetch-threshold 500000)

;; ;;;------------------------------------------
;; ;; (setq wl-dispose-folder-alist
;; ;;       (cons '("^%inbox" . remove) wl-dispose-folder-alist))

;; ;;;------------------------------------------
;; ;;; from,to のデコード指定。
;; (mime-set-field-decoder
;;  'From nil 'eword-decode-and-unfold-unstructured-field-body)
;; (mime-set-field-decoder
;;  'To nil 'eword-decode-and-unfold-unstructured-field-body)

;; ;;;------------------------------------------
;; ;; summary-mode ですべての header を一旦除去
;; ;; (setq mime-view-ignored-field-list '("^.*"))

;; ;; 表示するヘッダ。
;; ;; (setq wl-message-visible-field-list
;; ;;       (append mime-view-visible-field-list
;; ;; 	      '("^Subject:" "^From:" "^To:" "^Cc:"
;; ;; 		"^X-Mailer:" "^X-Newsreader:" "^User-Agent:"
;; ;; 		"^X-Face:" "^X-Mail-Count:" "^X-ML-COUNT:"
;; ;; 		)))

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 80_waderlust.el ends here
