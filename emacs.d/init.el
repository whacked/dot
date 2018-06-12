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
