;;; 03_counsel.el --- 03_counsel.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf counsel
  :ensure t
  :bind (("C-s" . swiper-region-or-isearch)
	 ("C-:" . counsel-switch-buffer)
	 ("C-x C-b" . counsel-switch-buffer)
	 ("C-x b" . counsel-switch-buffer)
	 ("M-x" . counsel-M-x)
	 ("M-y" . counsel-yank-pop)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c k" . counsel-ag)
	 ("C-c f" . counsel-projectile-find-file)
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-c i" . counsel-imenu)
	 ("C-c t" . counsel-tramp)
	 ("C-c r" . counsel-recentf)
	 ([remap dired] . counsel-dired)
	 ("<f6>" . find-counsel-in-m-x))
  :hook
  ((after-init-hook . ivy-mode)
   (ivy-mode-hook . counsel-mode)
   (css-mode-hook . counsel-css-imenu-setup))
  :config
  (setq ivy-use-virtual-buffers t
	ivy-use-selectable-prompt t
	enable-recursive-minibuffers t
	xref-show-xrefs-function #'ivy-xref-show-xrefs
	counsel-yank-pop-separator
	"\n------------------------------------------------------------\n"
	ivy-format-functions-alist '((t . my:ivy-format-function-arrow)))
  :init
  (leaf ivy-xref :ensure t)
  (leaf smex
    :ensure t
    :config
    (setq smex-history-length 35
	  smex-completion-method 'ivy))
  (leaf ivy-rich
    :ensure t
    :hook (ivy-mode-hook . ivy-rich-mode)))


(leaf *user-customize-function
  :init
  (defun swiper-region-or-isearch (arg)
    "If put 'C-u', `isearch-forward'.
If pt 'C-u C-u', `swiper-isearch'.
Do not put anything, `swiper-thing-at-point'."
    (interactive "p")
    (case arg
      (4 (isearch-forward))
      (16 (swiper-isearch))
      (t (swiper-thing-at-point))))

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

  (defun find-counsel-in-m-x ()
    "Narrow the only counsel-command in M-x."
    (interactive)
    (counsel-M-x "^counsel ")))


(leaf counsel-tramp
  :ensure t
  :bind (("C-c t" . counsel-tramp)
	 ("C-c q" . my:tramp-quit))
  :config
  (setq tramp-default-method "ssh"
	counsel-tramp-custom-connections
	'(/scp:xsrv:/home/minorugh/gospel-haiku.com/public_html/))
  :preface
  (defun my:tramp-quit ()
    "Quit tramp, if tramp connencted."
    (interactive)
    (when (get-buffer "*tramp/scp xsrv*")
      (counsel-tramp-quit)
      (message "Now tramp-quit!"))))


;; Local Variables:
;; no-byte-compile: t
;; End:

;;; 03_counsel.el ends here
