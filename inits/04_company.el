;;; 04_company.el --- 04_company.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; company
(use-package company
  :bind (([C-tab] . company-complete)
	 ([backtab] . company-yasnippet)
	 :map company-active-map
	 ("b" . company-select-previous)
	 ("SPC" . company-select-next)
	 ([backtab] . my-company-yasnippet))
  :hook (after-init . global-company-mode)
  :init
  (defun my-company-yasnippet ()
    (interactive)
    (company-abort)
    (call-interactively 'company-yasnippet))
  :config
  ;; company-box
  (setq company-box-icons-alist 'company-box-icons-all-the-icons)
  (setq company-box-doc-enable nil)
  (add-hook 'company-mode-hook 'company-box-mode))


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 04_company.el ends here
