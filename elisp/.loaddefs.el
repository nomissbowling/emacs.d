;;; .loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "darkroom/darkroom" "darkroom/darkroom.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from darkroom/darkroom.el

(autoload 'darkroom-mode "darkroom/darkroom" "\
Remove visual distractions and focus on writing. When this
mode is active, everything but the buffer's text is elided from
view. The buffer margins are set so that text is centered on
screen. Text size is increased (display engine allowing) by
`darkroom-text-scale-increase'.

\(fn &optional ARG)" t nil)

(autoload 'darkroom-tentative-mode "darkroom/darkroom" "\
Enters `darkroom-mode' when all other windows are deleted.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "darkroom/darkroom" '("darkroom-")))

;;;***

;;;### (autoloads nil "key-chord/key-chord" "key-chord/key-chord.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from key-chord/key-chord.el

(autoload 'key-chord-mode "key-chord/key-chord" "\
Toggle key chord mode.
With positive ARG enable the mode. With zero or negative arg disable the mode.
A key chord is two keys that are pressed simultaneously, or one key quickly
pressed twice.

See functions `key-chord-define-global', `key-chord-define-local', and
`key-chord-define' and variables `key-chord-two-keys-delay' and
`key-chord-one-key-delay'.

\(fn ARG)" t nil)

(autoload 'key-chord-define-global "key-chord/key-chord" "\
Define a key-chord of the two keys in KEYS starting a COMMAND.

KEYS can be a string or a vector of two elements. Currently only elements
that corresponds to ascii codes in the range 32 to 126 can be used.

COMMAND can be an interactive function, a string, or nil.
If COMMAND is nil, the key-chord is removed.

Note that KEYS defined locally in the current buffer will have precedence.

\(fn KEYS COMMAND)" t nil)

(autoload 'key-chord-define-local "key-chord/key-chord" "\
Locally define a key-chord of the two keys in KEYS starting a COMMAND.

KEYS can be a string or a vector of two elements. Currently only elements
that corresponds to ascii codes in the range 32 to 126 can be used.

COMMAND can be an interactive function, a string, or nil.
If COMMAND is nil, the key-chord is removed.

The binding goes in the current buffer's local map,
which in most cases is shared with all other buffers in the same major mode.

\(fn KEYS COMMAND)" t nil)

(autoload 'key-chord-define "key-chord/key-chord" "\
Define in KEYMAP, a key-chord of the two keys in KEYS starting a COMMAND.

KEYS can be a string or a vector of two elements. Currently only elements
that corresponds to ascii codes in the range 32 to 126 can be used.

COMMAND can be an interactive function, a string, or nil.
If COMMAND is nil, the key-chord is removed.

\(fn KEYMAP KEYS COMMAND)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "key-chord/key-chord" '("key-chord-")))

;;;***

;;;### (autoloads nil "mozc-el-extensions/mozc-cursor-color" "mozc-el-extensions/mozc-cursor-color.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from mozc-el-extensions/mozc-cursor-color.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mozc-el-extensions/mozc-cursor-color" '("mozc-cur")))

;;;***

;;;### (autoloads nil "mozc-el-extensions/mozc-isearch" "mozc-el-extensions/mozc-isearch.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from mozc-el-extensions/mozc-isearch.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mozc-el-extensions/mozc-isearch" '("mozc-")))

;;;***

;;;### (autoloads nil "mozc-el-extensions/mozc-mode-line-indicator"
;;;;;;  "mozc-el-extensions/mozc-mode-line-indicator.el" (0 0 0 0))
;;; Generated autoloads from mozc-el-extensions/mozc-mode-line-indicator.el

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mozc-el-extensions/mozc-mode-line-indicator" '("mozc-")))

;;;***

;;;### (autoloads nil "mozc-posframe/mozc-posframe" "mozc-posframe/mozc-posframe.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from mozc-posframe/mozc-posframe.el

(autoload 'mozc-cand-posframe-draw "mozc-posframe/mozc-posframe" "\


\(fn CANDIDATES)" nil nil)

(autoload 'mozc-cand-posframe-update "mozc-posframe/mozc-posframe" "\


\(fn CANDIDATES)" nil nil)

(autoload 'mozc-cand-posframe-clear "mozc-posframe/mozc-posframe" "\


\(fn)" nil nil)

(autoload 'mozc-cand-posframe-clean-up "mozc-posframe/mozc-posframe" "\


\(fn)" nil nil)

(autoload 'mozc-posframe-register "mozc-posframe/mozc-posframe" "\
Register mozc-posframe to mozc candidate dispatch table

\(fn)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "mozc-posframe/mozc-posframe" '("mozc-")))

;;;***

;;;### (autoloads nil "undo-tree/undo-tree" "undo-tree/undo-tree.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from undo-tree/undo-tree.el

(autoload 'undo-tree-mode "undo-tree/undo-tree" "\
Toggle undo-tree mode.
With no argument, this command toggles the mode.
A positive prefix argument turns the mode on.
A negative prefix argument turns it off.

Undo-tree-mode replaces Emacs' standard undo feature with a more
powerful yet easier to use version, that treats the undo history
as what it is: a tree.

The following keys are available in `undo-tree-mode':

  \\{undo-tree-map}

Within the undo-tree visualizer, the following keys are available:

  \\{undo-tree-visualizer-mode-map}

\(fn &optional ARG)" t nil)

(defvar global-undo-tree-mode nil "\
Non-nil if Global Undo-Tree mode is enabled.
See the `global-undo-tree-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-undo-tree-mode'.")

(custom-autoload 'global-undo-tree-mode "undo-tree/undo-tree" nil)

(autoload 'global-undo-tree-mode "undo-tree/undo-tree" "\
Toggle Undo-Tree mode in all buffers.
With prefix ARG, enable Global Undo-Tree mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Undo-Tree mode is enabled in all buffers where
`turn-on-undo-tree-mode' would do it.
See `undo-tree-mode' for more information on Undo-Tree mode.

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "undo-tree/undo-tree" '("undo-" "turn-on-undo-tree-mode" "*undo-tree-id-counter*" "buffer-undo-tree")))

;;;***

;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here
