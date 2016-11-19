(defun path-join (&rest path-seq)
  (concat (mapconcat 
	   'file-name-as-directory
	   (butlast path-seq) "")
	  (car (last path-seq))))
(setq EMACS.D-DIR (path-join "~" ".emacs.d"))
(org-babel-load-file (path-join EMACS.D-DIR "config.org"))
