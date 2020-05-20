;;; 04_company.el --- 04_company.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf company
  :ensure t
  :bind (("C-<tab>" . company-complete)
	 (:company-mode-map
	  ("<backtab>" . company-yasnippet))
	 (:company-active-map
	  ("<tab>" . company-complete-common-or-cycle)
	  ("<backtab>" . company-yasnippet)
	  ("b" . company-select-previous)
	  ("SPC" . company-select-next)
	  ("C-d" . company-show-doc-buffer)))
  :hook (after-init-hook . global-company-mode)
  :custom ((company-minimum-prefix-length . 2)
	   (company-selection-wrap-around . t)
	   (company-tooltip-maximum-width . 50)))


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 04_company.el ends here
