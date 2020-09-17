;;; 02_counsel.el --- 02_counsel.el   -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(leaf counsel
  :ensure t
  :hook
  (ivy-mode-hook . counsel-mode)
  (css-mode-hook . counsel-css-imenu-setup)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-use-selectable-prompt t)
  (setq enable-recursive-minibuffers t)
  (bind-key "C-s" 'swiper-or-region)
  (bind-key "C-:" 'counsel-switch-buffer)
  (bind-key "C-x C-f" 'counsel-find-file)
  (bind-key "C-x C-r" 'counsel-recentf)
  (bind-key [remap dired] 'counsel-dired)
  (bind-key "<f6>" 'select-counsel-command)
  (define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
  (setq counsel-yank-pop-separator
	"\n------------------------------------------------------------\n")
  (setq ivy-format-functions-alist '((t . my:ivy-format-function-arrow)))
  :init
  (leaf ivy-xref :ensure t
    :init (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))
  (leaf amx :ensure t
    :init (setq amx-history-length 20))
  (leaf ivy-rich :ensure t
    :hook (ivy-mode-hook . ivy-rich-mode))
  (leaf avy :ensure t
    :bind ("C-r" . avy-goto-word-1)))


(leaf *user-function-for-counsel
  :init
  (defun swiper-or-region ()
    "If region is selected, `swiper' with the keyword selected in region.
If the region isn't selected, `swiper' with migemo."
    (interactive)
    (if (not (use-region-p))
	(swiper)
      (swiper-thing-at-point)))

  (defun my:ivy-migemo-re-builder (str)
    "Own ivy-migemo-re-build for swiper."
    (let* ((sep " \\|\\^\\|\\.\\|\\*")
	   (splitted (--map (s-join "" it)
			    (--partition-by (s-matches-p " \\|\\^\\|\\.\\|\\*" it)
					    (s-split "" str t)))))
      (s-join "" (--map (cond ((s-equals? it " ") ".*?")
			      ((s-matches? sep it) it)
			      (t (migemo-get-pattern it)))
			splitted))))

  (setq ivy-re-builders-alist '((t . ivy--regex-plus)
				(counsel-web . my:ivy-migemo-re-builder)
				(counsel-rg . my:ivy-migemo-re-builder)
				(swiper . my:ivy-migemo-re-builder)))

  (defun my:ivy-format-function-arrow (cands)
    "Transform into a string for minibuffer."
    (ivy--format-function-generic
     (lambda (str)
       (concat (if (display-graphic-p)
		   (all-the-icons-octicon "chevron-right" :height 0.8 :v-adjust -0.05)
		 ">")
	       (propertize " " 'display `(space :align-to 2))
	       (ivy--add-face str 'ivy-current-match)))
     (lambda (str)
       (concat (propertize " " 'display `(space :align-to 2)) str))
     cands
     "\n"))

  (defun select-counsel-command ()
    "Narrow the only counsel-command in `M-x'."
    (interactive)
    (counsel-M-x "^counsel ")))


(leaf counsel-web :ensure t
  :config
  (setq counsel-web-search-action #'browse-url)
  (setq counsel-web-engine 'google))


(leaf counsel-tramp
  :ensure t
  :config
  (bind-key "C-c t" 'counsel-tramp)
  (bind-key "C-c q" 'my:tramp-quit)
  (setq tramp-default-method "scp")
  (setq counsel-tramp-custom-connections
	'(/scp:xsrv:/home/minorugh/gospel-haiku.com/public_html/))
  (add-hook 'counsel-tramp-pre-command-hook
	    '(lambda () (projectile-mode 0)))
  (add-hook 'counsel-tramp-quit-hook
	    '(lambda () (projectile-mode 1)))
  :preface
  (defun my:tramp-quit ()
    "Quit tramp, if tramp connencted."
    (interactive)
    (when (get-buffer "*tramp/scp xsrv*")
      (tramp-cleanup-all-connections)
      (counsel-tramp-quit)
      (message "Tramp Quit!"))))


(leaf counsel-css :ensure t
  :config
  (add-hook 'css-mode-hook #'counsel-css-imenu-setup))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 02_counsel.el ends here
