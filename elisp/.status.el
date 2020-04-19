((10sr/emacs-lisp/dired-list-all-mode status "required" recipe nil)
 (10sr/emacs-lisp/docs/elpa/dired-list-all-mode-20161115\.118\.el status "required" recipe nil)
 (darkroom status "installed" recipe
	   (:name darkroom :type github :pkgname "joaotavora/darkroom" :after nil))
 (el-get status "required")
 (emp/\.emacs\.d/tempbuf status "required" recipe nil)
 (evil/lib/undo-tree status "required" recipe nil)
 (key-chord status "installed" recipe
	    (:name key-chord :type github :pkgname "zk-phi/key-chord" :after nil))
 (key-chorde status "required" recipe nil)
 (kootenpv/emp/tempbuf status "required" recipe nil)
 (mozc-el-extensions status "installed" recipe
		     (:name mozc-el-extensions :type github :pkgname "iRi-E/mozc-el-extensions" :after nil))
 (mozc-posframe status "installed" recipe
		(:name mozc-posframe :type github :pkgname "derui/mozc-posframe" :after nil))
 (tempbuf status "required" recipe nil)
 (undo-tree status "installed" recipe
	    (:name undo-tree :type github :pkgname "tarsiiformes/undo-tree" :after nil)))
