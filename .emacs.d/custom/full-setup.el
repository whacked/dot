(load-file "~/dot/.emacs.d/custom/package-management.el")
(load-file "~/dot/.emacs.d/custom/package-common.el")
(setq my-packages
      (append
       '(el-get package
         ;; ESS
         ess
         
         fic-mode ;; to highlight TODO FIXME BUG etc
         
         ;; htmlize ;; htmlize is needed for syntax highlighting in org-mode html output
         ;; iedit
         )
       (mapcar 'el-get-source-name el-get-sources)))


(load-file "~/dot/.emacs.d/custom/coding.el")
(load-file "~/dot/.emacs.d/custom/lispy-stuff.el")

(load-file "~/dot/.emacs.d/custom/usual-environment.el")
