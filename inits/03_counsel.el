;;; 03_counsel.el --- 03_counsel.el  -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf counsel
  :ensure t
  :bind (("C-s" . swiper-thing-at-point)
	 ("C-:" . counsel-switch-buffer)
	 ("C-x C-b" . counsel-switch-buffer)
	 ("C-x b" . counsel-switch-buffer)
	 ("M-x" . counsel-M-x)
	 ("M-y" . counsel-yank-pop)
	 ("s-z" . counsel-linux-app)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c k" . counsel-ag)
	 ("C-c f" . counsel-projectile-find-file)
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-c i" . counsel-imenu)
	 ("C-c t" . counsel-tramp)
	 ("C-c C-r" . counsel-recentf)
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
  (leaf amx
    :ensure t
    :init (setq amx-history-length 20))
  (leaf ivy-rich
    :ensure t
    :hook (ivy-mode-hook . ivy-rich-mode)))


(leaf *user-customize-function
  :init
  (defun my:ivy-migemo-re-builder (str)
    "Own function for my:ivy-migemo."
    (let* ((sep " \\|\\^\\|\\.\\|\\*")
	   (splitted (--map (s-join "" it)
			    (--partition-by (s-matches-p " \\|\\^\\|\\.\\|\\*" it)
					    (s-split "" str t)))))
      (s-join "" (--map (cond ((s-equals? it " ") ".*?")
			      ((s-matches? sep it) it)
			      (t (migemo-get-pattern it)))
			splitted))))
  (setq ivy-re-builders-alist '((t . ivy--regex-plus)
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

  ;; Search using the word at the cursor position
  (defun my:counsel-ag (f &optional initial-input initial-directory extra-ag-args ag-prompt caller)
    (apply f (or initial-input (ivy-thing-at-point))
	   (unless current-prefix-arg
	     (or initial-directory default-directory))
	   extra-ag-args ag-prompt caller))
  (advice-add 'counsel-ag :around #'my:counsel-ag)

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
