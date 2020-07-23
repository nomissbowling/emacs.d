;;; 02_counsel.el --- 02_counsel.el  -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
;; (setq debug-on-error t)

(defun swiper-migemo-or-region ()
  "If region is selected, `swiper' with the keyword selected in region.
If the region isn't selected, `swiper' with migemo."
  (interactive)
  (if (not (use-region-p))
      (swiper)
    (swiper-thing-at-point)))


(defun my:ivy-migemo-re-builder (str)
  "Own ivy-migemo-re-build for swiper argument is STR."
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
  "Transform CANDS into a string for minibuffer."
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
  (counsel-M-x "^counsel "))


(leaf counsel :ensure t
  :bind (("s-s" . swiper-thing-at-point)
	 ("C-s" . swiper-migemo-or-region)
	 ("C-:" . counsel-switch-buffer)
	 ("C-x C-b" . counsel-switch-buffer)
	 ("C-x b" . counsel-switch-buffer)
	 ("M-x" . counsel-M-x)
	 ("M-y" . counsel-yank-pop)
	 ("s-a" . counsel-linux-app)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c k" . counsel-ag)
	 ("C-c w" . counsel-rg)
	 ("C-c f" . counsel-projectile-find-file)
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-c i" . counsel-imenu)
	 ("C-c t" . counsel-tramp)
	 ("C-c C-r" . counsel-recentf)
	 ([remap dired] . counsel-dired)
	 ("<f6>" . select-counsel-command))
  :hook
  ((ivy-mode-hook . counsel-mode)
   (css-mode-hook . counsel-css-imenu-setup))
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t
	ivy-use-selectable-prompt t
	enable-recursive-minibuffers t
	xref-show-xrefs-function #'ivy-xref-show-xrefs
	counsel-yank-pop-separator
	"\n------------------------------------------------------------\n"
	ivy-format-functions-alist '((t . my:ivy-format-function-arrow)))
  :init
  (leaf amx :ensure t
    :init (setq amx-history-length 20))
  (leaf ivy-rich :ensure t
    :hook (ivy-mode-hook . ivy-rich-mode)))


(leaf counsel-tramp :ensure t
  :bind (("C-c t" . counsel-tramp)
	 ("C-c q" . my:tramp-quit))
  :config
  (setq tramp-default-method "scp"
	counsel-tramp-custom-connections
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


(leaf counsel-web :ensure t
  :bind ("M-s" . counsel-web-suggest)
  :config
  (setq counsel-web-search-action #'browse-url
	counsel-web-engine 'google))


(leaf counsel-css :ensure t
  :config
  (add-hook 'css-mode-hook #'counsel-css-imenu-setup))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 02_counsel.el ends here