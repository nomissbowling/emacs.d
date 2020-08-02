;;; 03_company.el --- 03_company.el
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf company :ensure t
  :config
  (global-company-mode)
  (bind-key "C-<tab>" 'company-complete)
  (bind-key "<tab>" 'company-complete-common-or-cycle company-active-map)
  (bind-key "b" 'company-select-previous company-active-map)
  (bind-key "SPC" 'company-select-next company-active-map)
  (bind-key "C-d" 'company-show-doc-buffer company-active-map)
  (setq company-transformers '(company-sort-by-backend-importance))
  (setq company-minimum-prefix-length 3)
  (setq company-selection-wrap-around t)
  (setq completion-ignore-case t)
  (setq company-dabbrev-downcase nil)
  :init
  (leaf company-quickhelp :ensure t
    :config
    (company-quickhelp-mode)
    (setq company-quickhelp-color-foreground "#C7C9D1")
    (setq company-quickhelp-color-background "#393F60")
    (setq company-quickhelp-max-lines 5)))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 03_company.el ends here
