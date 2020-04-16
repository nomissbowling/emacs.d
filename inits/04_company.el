;;; 04_company.el --- 04_company.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf company
  :bind (([C-tab] . company-complete)
	 ([backtab] . company-yasnippet)
	 (:company-active-map
	  ("b" . company-select-previous)
	  ("SPC" . company-select-next)
	  ([backtab] . my:company-yasnippet)))
  :hook
  (after-init-hook . global-company-mode)
  :preface
  (defun my:company-yasnippet ()
    (interactive)
    (company-abort)
    (call-interactively 'company-yasnippet)))

(leaf company-box
  :after (company all-the-icons)
  :custom
  (company-box-icons-alist . company-box-icons-all-the-icons)
  (company-box-doc-enable . nil)
  :config
  (company-box-mode))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 04_company.el ends here
