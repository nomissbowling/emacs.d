;;; 03_counsel.el --- 03_counsel.el
;;; Commentary:
;;; Code:
;; (setq debug-on-error t)

(add-hook 'after-init-hook 'ivy-mode)
(add-hook 'ivy-mode-hook 'counsel-mode)
(setq ivy-use-virtual-buffers t)
(setq ivy-use-selectable-prompt t)
(setq enable-recursive-minibuffers t)
(setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
(setq counsel-find-file-ignore-regexp (regexp-opt '(".DS_Store" ".dropox")))
(setq counsel-yank-pop-separator
      "\n------------------------------------------------------------\n")
(bind-keys ("C-:" . counsel-switch-buffer)
	   ("C-s" . swiper-or-isearch-forward)
	   ("M-s" . swiper-isearch-thing-at-point)
	   ("M-x" . counsel-M-x)
	   ("C-c a" . counsel-ag)
	   ("C-c f" . counsel-projectile-find-file)
	   ("C-c g" . counsel-git)
	   ("C-c j" . counsel-git-grep)
	   ("C-c i" . counsel-imenu)
	   ("C-c r" . counsel-recentf)
	   ("C-c t" . counsel-tramp)
	   ("C-x m" . counsel-mark-ring)
	   ([remap dired] . counsel-dired))
(bind-key [f6] (lambda ()
		 (interactive)
		 (counsel-M-x "^counsel ")))

(defun swiper-or-isearch-forward (use)
  "If add `C-u' USE the iserach-forward."
  (interactive "P")
  (let (current-prefix-arg)
    (call-interactively (if use 'isearch-forward 'swiper))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; counsel-css to activate imenu integration to "C-r"

(add-hook 'css-mode-hook 'counsel-css-imenu-setup)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; counsel-tramp

(setq tramp-default-method "ssh")
(setq counsel-tramp-custom-connections '(/scp:xsrv:/home/minorugh/gospel-haiku.com/))

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
    (message "Now tramp-quit!")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Quick launch apps

(bind-key "s-a" #'counsel-linux-app)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ivy-format-function-arrow

(when (eq system-type 'gnu/linux)
(defun my-ivy-format-function-arrow (cands)
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
(setq ivy-format-functions-alist '((t . my-ivy-format-function-arrow))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; More friendly display transformer for Ivy

(when (eq system-type 'gnu/linux)
  (use-package ivy-rich
    :hook (ivy-mode . ivy-rich-mode)
    :preface
    (defun ivy-rich-bookmark-name (candidate)
      (car (assoc candidate bookmark-alist)))

    (defun ivy-rich-buffer-icon (candidate)
      "Display buffer icons in `ivy-rich'."
      (when (display-graphic-p)
	(let* ((buffer (get-buffer candidate))
	       (buffer-file-name (buffer-file-name buffer))
	       (major-mode (buffer-local-value 'major-mode buffer))
	       (icon (if (and buffer-file-name
			      (all-the-icons-match-to-alist buffer-file-name
							    all-the-icons-icon-alist))
			 (all-the-icons-icon-for-file (file-name-nondirectory buffer-file-name)
						      :height 0.9 :v-adjust -0.05)
		       (all-the-icons-icon-for-mode major-mode :height 0.9 :v-adjust -0.05))))
	  (if (symbolp icon)
	      (setq icon (all-the-icons-faicon "file-o" :face 'all-the-icons-dsilver :height 0.9 :v-adjust -0.05))
	    icon))))

    (defun ivy-rich-file-icon (candidate)
      "Display file icons in `ivy-rich'."
      (when (display-graphic-p)
	(let* ((path (concat ivy--directory candidate))
	       (file (file-name-nondirectory path))
	       (icon (cond ((file-directory-p path)
			    (cond
			     ((and (fboundp 'tramp-tramp-file-p)
				   (tramp-tramp-file-p default-directory))
			      (all-the-icons-octicon "file-directory" :height 0.93 :v-adjust 0.01))
			     ((file-symlink-p path)
			      (all-the-icons-octicon "file-symlink-directory" :height 0.93 :v-adjust 0.01))
			     ((all-the-icons-dir-is-submodule path)
			      (all-the-icons-octicon "file-submodule" :height 0.93 :v-adjust 0.01))
			     ((file-exists-p (format "%s/.git" path))
			      (all-the-icons-octicon "repo" :height 1.0 :v-adjust -0.01))
			     (t (let ((matcher (all-the-icons-match-to-alist candidate all-the-icons-dir-icon-alist)))
				  (apply (car matcher) (list (cadr matcher) :height 0.93 :v-adjust 0.01))))))
			   ((string-match "^/.*:$" path)
			    (all-the-icons-material "settings_remote" :height 0.9 :v-adjust -0.2))
			   ((not (string-empty-p file))
			    (all-the-icons-icon-for-file file :height 0.9 :v-adjust -0.05)))))
	  (if (symbolp icon)
	      (setq icon (all-the-icons-faicon "file-o" :face 'all-the-icons-dsilver :height 0.9 :v-adjust -0.05))
	    icon))))
    :init
    ;; For better performance
    (setq ivy-rich-parse-remote-buffer nil)
    (setq ivy-rich-display-transformers-list
	  '(counsel-switch-buffer
	    (:columns
	     ((ivy-rich-buffer-icon)
	      (ivy-rich-candidate (:width 30))
	      (ivy-rich-switch-buffer-size (:width 7))
	      (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
	      (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
	      (ivy-rich-switch-buffer-project (:width 15 :face success))
	      (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
	     :predicate
	     (lambda (cand) (get-buffer cand)))
	    counsel-M-x
	    (:columns
	     ((counsel-M-x-transformer (:width 40))
	      (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
	    counsel-describe-function
	    (:columns
	     ((counsel-describe-function-transformer (:width 45))
	      (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
	    counsel-describe-variable
	    (:columns
	     ((counsel-describe-variable-transformer (:width 45))
	      (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face))))
	    counsel-find-file
	    (:columns
	     ((ivy-rich-file-icon)
	      (ivy-read-file-transformer)))
	    counsel-file-jump
	    (:columns
	     ((ivy-rich-file-icon)
	      (ivy-rich-candidate)))
	    counsel-dired
	    (:columns
	     ((ivy-rich-file-icon)
	      (ivy-read-file-transformer)))
	    counsel-dired-jump
	    (:columns
	     ((ivy-rich-file-icon)
	      (ivy-rich-candidate)))
	    counsel-git
	    (:columns
	     ((ivy-rich-file-icon)
	      (ivy-rich-candidate)))
	    counsel-projectile-switch-project
	    (:columns
	     ((ivy-rich-file-icon)
	      (ivy-rich-candidate))
	     :delimiter "\t")
	    counsel-projectile-find-file
	    (:columns
	     ((ivy-rich-file-icon)
	      (counsel-projectile-find-file-transformer))
	     :delimiter "\t")
	    counsel-recentf
	    (:columns
	     ((ivy-rich-file-icon)
	      (ivy-rich-candidate (:width 0.8))
	      (ivy-rich-file-last-modified-time (:face font-lock-comment-face))))
	    ))))

;; Local Variables:
;; no-byte-compile: t
;; End:
;;; 03_counsel.el ends here
