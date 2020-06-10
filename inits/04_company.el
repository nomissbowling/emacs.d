;;; 04_company.el --- 04_company.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf company
  :ensure t
  :bind (("C-<tab>" . company-complete)
	 (:company-active-map
	  ("<tab>" . company-complete-common-or-cycle)
	  ("<backtab>" . company-select-previous)
	  ("b" . company-select-previous)
	  ("SPC" . company-select-next)
	  ("C-d" . company-show-doc-buffer)))
  :hook (after-init-hook . global-company-mode)
  :config
  (setq company-transformers '(company-sort-by-backend-importance)
	company-minimum-prefix-length 3
	company-selection-wrap-around t
	completion-ignore-case t
	company-dabbrev-downcase nil))


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 04_company.el ends here
