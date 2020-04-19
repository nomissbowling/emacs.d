;;; 04_company.el --- 04_company.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf company
  :ensure t
  :bind (([C-tab] . company-complete)
	 ([backtab] . company-yasnippet)
	 (:company-active-map
	  ("b" . company-select-previous)
	  ("SPC" . company-select-next)
	  ([backtab] . my:company-yasnippet)))
  :hook (after-init-hook . global-company-mode)
  :config
  (defun my:company-yasnippet ()
    (interactive)
    (company-abort)
    (call-interactively 'company-yasnippet)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 04_company.el ends here
