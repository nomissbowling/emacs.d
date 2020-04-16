;;; 03_counsel.el --- 03_counsel.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(leaf counsel
  :bind (("C-s" . swiper-isearch-region)
	 ("C-r" . swiper-thing-at-point)
	 ("C-:" . counsel-switch-buffer)
	 ("C-x C-b" . counsel-switch-buffer)
	 ("C-x b" . counsel-switch-buffer)
	 ("M-x" . counsel-M-x)
	 ("M-y" . counsel-yank-pop)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c a" . counsel-ag)
	 ("C-c f" . counsel-projectile-find-file)
	 ("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep)
	 ("C-c i" . counsel-imenu)
	 ("C-c r" . counsel-recentf)
	 ("C-c t" . counsel-tramp)
	 ([remap dired] . counsel-dired)
	 ("<f6>" . my:find-counsel-command))
  :hook ((after-init-hook . ivy-mode)
	 (ivy-mode-hook . counsel-mode)
	 (css-mode-hook . counsel-css-imenu-setup))
  :custom ((ivy-use-virtual-buffers . t)
	   (ivy-use-selectable-prompt . t)
	   (enable-recursive-minibuffers . t)
	   (xref-show-xrefs-function . #'ivy-xref-show-xrefs)
	   (counsel-find-file-ignore-regexp . ,(regexp-opt '("destop.ini" ".dropox")))
	   (counsel-yank-pop-separator
	    . "\n------------------------------------------------------------\n")
	   (ivy-format-functions-alist . '((t . my:ivy-format-function-arrow)))
	   )
  :config
  (leaf ivy-rich
    :doc "More friendly display transformer for Ivy"
    :hook (ivy-mode-hook . ivy-rich-mode))
  :preface
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
  (defun my:find-counsel-command ()
    ;;  (bind-key "<f6>" (lambda ()
    (interactive)
    (counsel-M-x "^counsel "))
  (defun swiper-isearch-region ()
    "If region is selected, `swiper-isearch-thing-at-point'.
If the region isn't selected, `swiper-isearch'."
    (interactive)
    (if (not (use-region-p))
	(swiper-isearch)
      (swiper-isearch-thing-at-point))))

(leaf counsel-tramp
  :custom ((tramp-default-method . "ssh")
	   (counsel-tramp-custom-connections
	    . '(/scp:xsrv:/home/minorugh/gospel-haiku.com/)))
  :config
  (defun my:tramp-xsrv ()
    "Start tramp after closed all buffers."
    (interactive)
    (when (get-buffer "*tramp/scp xsrv*")
      (counsel-tramp-quit))
    (counsel-tramp))
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
