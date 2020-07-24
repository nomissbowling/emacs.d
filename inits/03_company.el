;;; 03_company.el --- 03_company.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf company :ensure t
  :hook (emacs-startup-hook . global-company-mode)
  :config
  (bind-key "C-<tab>" 'company-complete)
  (define-key company-active-map "<tab>" 'company-complete-common-or-cycle)
  (define-key company-active-map "<backtab>" 'company-select-previous)
  (define-key company-active-map "b" 'company-select-previous)
  (define-key company-active-map "SPC" 'company-select-next)
  (define-key company-active-map "C-d" 'company-show-doc-buffer)
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
    (setq company-quickhelp-max-lines 5)
    (company-quickhelp-mode)))


;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 03_company.el ends here
