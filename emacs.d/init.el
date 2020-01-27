;; package management
(setq package-archives '(("gnu"       . "http://elpa.gnu.org/packages/")
                         ("ELPA"      . "http://tromey.com/elpa/")
                         ("org"       . "http://orgmode.org/elpa/")
                         ("melpa"     . "https://melpa.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))
;; activate all the packages (in particular autoloads)
(package-initialize)

(defun path-join (&rest path-seq)
  (concat (mapconcat 
	   'file-name-as-directory
	   (butlast path-seq) "")
	  (car (last path-seq))))
(setq EMACS.D-DIR (path-join "~" ".emacs.d"))
(org-babel-load-file (path-join EMACS.D-DIR "config.org"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(muse-project-alist nil)
 '(package-selected-packages
   (quote
    (el-get zencoding-mode zenburn-theme yaml-mode win-switch use-package undo-tree unbound ujelly-theme try transpose-frame sr-speedbar solarized-theme skewer-mode sibilant-mode rspec-mode revive request rainbow-mode pyvenv python-mode project-explorer powerline ov org ob-ipython ob-go neotree navi-mode muse multi-web-mode monokai-theme matlab-mode material-theme markdown-mode magit lua-mode load-theme-buffer-local leuven-theme json-rpc json-mode inf-ruby inf-clojure hyperbole hy-mode htmlize helm-projectile helm-org-rifle haxe-mode haskell-mode graphviz-dot-mode gnuplot-mode git-timemachine fiplr find-file-in-project fic-mode expand-region eval-in-repl ess diff-hl deft cyberpunk-theme csv-mode color-theme-solarized color-theme-buffer-local clj-refactor auto-complete ample-theme alect-themes))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
