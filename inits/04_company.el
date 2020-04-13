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
  :init
  (defun my:company-yasnippet ()
    (interactive)
    (company-abort)
    (call-interactively 'company-yasnippet))
  :config
  (leaf company-box
    :hook
    (add-hook 'company-mode-hook 'company-box-mode)
    :config
    (setq company-box-icons-alist 'company-box-icons-all-the-icons)
    (setq company-box-doc-enable nil)))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 04_company.el ends here
