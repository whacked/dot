(setq el-get-sources
      '(

        ;; (:name clojure-mode
        ;;        :type git
        ;;        :url "https://github.com/technomancy/clojure-mode.git")
        (:name nrepl :type elpa)
        ;; (:name tex-math-preview :type elpa)
        (:name yasnippet
               :type git
               :url "https://github.com/capitaomorte/yasnippet.git"
               :features "yasnippet"
               :compile nil)
        (:name emacs-dirtree
               :type git
               :url "https://github.com/zkim/emacs-dirtree.git"
               :features "dirtree"
               :compile "dirtree.el")
        (:name popup-el
               :type git
               :url "https://github.com/auto-complete/popup-el.git"
               :features "popup")
        (:name multi-web-mode
               :type git
               :url "https://github.com/fgallina/multi-web-mode.git"
               :features "multi-web-mode"
               :compile nil)
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
                            (let ((f "~/dot/.emacs.d/el-get/auto-complete/auto-complete-config.elc"))
                              (if (file-exists-p f)
                                  (delete-file f)))
                            (require 'auto-complete-config)
                            (ac-config-default)
                            ))

        (:name request
               :type git
               :url "https://github.com/tkf/emacs-request"
               :features "request"
               :compile "request.el")
        (:name google-this
               :type git
               :url "https://github.com/Bruce-Connor/emacs-google-this"
               :features "google-this"
               :compile "google-this.el")
        ))
(setq my-packages
      (append
       '(el-get package
         ;; put el-get bundled packages here
         windata tree-mode ;; required for dirtree
         git-commit-mode
         magit color-theme color-theme-solarized
         transpose-frame
         
         elscreen
         ;; perspective
         frame-bufs
         )
       (mapcar 'el-get-source-name el-get-sources)))
