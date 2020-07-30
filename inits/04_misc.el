;;; 04_misc.el --- 04_misc.el
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf popwin :ensure t
  :config
  (popwin-mode))


(leaf expand-region :ensure t
  :bind ("C-@" . er/expand-region))
(with-eval-after-load "selected"
  (when (require 'expand-region nil t)
    (push 'er/mark-outside-pairs er/try-expand-list)
    (bind-key "SPC" 'er/expand-region selected-keymap)))


(leaf flycheck :ensure t
  :hook (emacs-startup-hook . flycheck-mode)
  :init
  (setq flycheck-global-modes
	'(not text-mode outline-mode fundamental-mode lisp-interaction-mode
	      org-mode diff-mode shell-mode eshell-mode term-mode vterm-mode))
  (leaf flycheck-title :ensure t
    :after flycheck
    :config
    (flycheck-title-mode)))


(leaf yasnippet :ensure t
  :commands yas-grobal-mode
  :config
  (yas-global-mode)
  (setq yas-snippet-dirs '("~/Dropbox/emacs.d/snippets")))
(leaf yasnippet-snippets :ensure t)
(leaf ivy-yasnippet :ensure t)


(leaf prescient :ensure t
  :config
  (prescient-persist-mode)
  :init
  (leaf company-prescient :ensure t
    :config
    (company-prescient-mode))
  (leaf ivy-prescient :ensure t
    :config
    (ivy-prescient-mode)))


(leaf quickrun :ensure t
  :bind ("<f5>" . quickrun))


(leaf which-key :ensure t
  :config
  (which-key-mode)
  (setq which-key-max-description-length 40)
  (setq which-key-use-C-h-commands t))


(leaf projectile :ensure t
  :config
  (projectile-mode)
  :init
  (leaf counsel-projectile :ensure t
    :config
    (counsel-projectile-mode)))


(leaf restart-emacs :ensure t
  :bind ("C-x C-c" . restart-emacs))

(leaf web-mode :ensure t
  :mode "\\.js\\'" "\\.html?\\'")

(leaf php-mode :ensure t
  :mode "\\.php\\'"  "\\.inc\\'" "\\.ctp\\'" "\\.lock\\'")

(leaf iedit :ensure t
  :bind ("C-;" . iedit-mode))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 04_misc.el ends here
