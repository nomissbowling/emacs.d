;;; 04_company.el --- 04_company.el  -*- lexical-binding: t; -*-
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
  :custom ((company-minimum-prefix-length . 2)
	   (company-selection-wrap-around . t)
	   (company-tooltip-maximum-width . 50))
  :config
  (add-to-list 'company-backends 'company-restclient))


(leaf company-quickhelp
  :ensure t
  :after company
  :hook (after-init-hook . comoany-quickhelp-mode)
  :custom ((company-quickhelp-color-foreground . "white")
	   (company-quickhelp-color-background . "dark slate gray")
	   (company-quickhelp-max-lines . 5)))


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 04_company.el ends here
