;;; init.el --- My init.el  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita
;; Author: Naoya Yamashita <conao3@gmail.com>
;; Modified: Minoru Yamada <minorughgmail.com>

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; My init.el.

;;; Code:

;; Custom start
(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)
(set-frame-parameter nil 'fullscreen 'maximized)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq gc-cons-threshold (* 128 1024 1024))

;; this enables this running method
;; emacs -q -l ~/.debug.emacs.d/{{pkg}}/init.el
(eval-and-compile
  (when (or load-file-name byte-compile-current-file)
    (setq user-emacs-directory
          (expand-file-name
           (file-name-directory (or load-file-name byte-compile-current-file))))))

(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  (leaf leaf-keywords
    :ensure t
    ;; Load newer whichever el or elc
    :custom (load-prefer-newer . t)
    :init
    ;; optional packages
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf bind-key :ensure t)
    (leaf init-loader :ensure t)
    :config
    (setq el-get-dir "~/Dropbox/emacs.d/elisp")
    (add-to-list 'load-path "~/Dropbox/emacs.d/elisp")
    (leaf-keywords-init)))

;; Init-loader
(custom-set-variables
 '(init-loader-show-log-after-init 'error-only))
(init-loader-load "~/Dropbox/emacs.d/inits")
(setq custom-file (locate-user-emacs-file "custom.el"))

(provide 'init)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; init.el ends here
