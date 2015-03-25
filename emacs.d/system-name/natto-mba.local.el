(load-file "~/dot/emacs.d/custom/full-setup.el")
(custom-set-variables
 '(org-file-apps (quote ((auto-mode . emacs)
                         ("\\.mm\\'" . default)
                         ("\\.x?html?\\'" . default)
                         ("\\.xoj\\'" . "xournal %s")
                         ("\\.pdf\\'" . "open -a Preview %s")))))

