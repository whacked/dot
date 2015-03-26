(setq el-get-sources
      '(
        ;; (:name tex-math-preview :type elpa)
        ;; (:name emacs-dirtree
        ;;        :type git
        ;;        :url "https://github.com/zkim/emacs-dirtree.git"
        ;;        :features "dirtree"
        ;;        :compile "dirtree.el")
        (:name popup-el
               :type git
               :url "https://github.com/auto-complete/popup-el.git"
               :features "popup")
        ;; (:name multi-web-mode
        ;;        :type git
        ;;        :url "https://github.com/fgallina/multi-web-mode.git"
        ;;        :features "multi-web-mode"
        ;;        :compile nil)
        
        ;; https://bitbucket.org/tavisrudd/emacs.d/src/b00b30c330b2/dss-init-el-get.el
        (:name auto-complete
               :website "http://cx4a.org/software/auto-complete/"
               :description "The most intelligent auto-completion extension."
               :type git
               :url "http://github.com/auto-complete/auto-complete.git"
               :load-path "."
               :post-init (progn
                            (require 'auto-complete)
                            (add-to-list 'ac-dictionary-directories (expand-file-name "dict" pdir))
                            ;; the elc is buggy for some reason
                            (let ((f "~/dot/emacs.d/el-get/auto-complete/auto-complete-config.elc"))
                              (if (file-exists-p f)
                                  (delete-file f)))
                            (require 'auto-complete-config)
                            (ac-config-default)
                            ))
        ;; (:name impatient-mode
        ;;        :type git
        ;;        :url "https://github.com/netguy204/imp.el"
        ;;        :features "impatient-mode")

        ;; (:name git-playback
        ;;        :type git
        ;;        :url "https://github.com/jianli/git-playback"
        ;;        :features "git-playback")
        ))

(setq my-packages
      (append
       '(el-get
         s
         yasnippet
         dash

         ;; popup-el
         multi-web-mode
         
         neotree
         projectile
         project-explorer
         
         ;; windata tree-mode ;; required for dirtree
         ;; htmlize ;; htmlize is needed for syntax highlighting in org-mode html output

         multiple-cursors
         
         ;; perspective
         ;; elscreen

         request
         ;; google-this

         helm
         ;; auctex ;; locale problem causing build to fail

         ;; need MELPA working!
         simple-httpd

         pyvenv
         ;; iedit

         ;; frame-bufs

         transpose-frame

         magit
         color-theme color-theme-solarized

         skewer-mode ;; js live repl https://github.com/skeeto/skewer-mode
         git-timemachine

         navi-mode

         minimap
         powerline

         outorg outshine navi-mode
         )
       (mapcar 'el-get-source-name el-get-sources)))
