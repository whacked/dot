;; package management
(setq package-archives '(("ELPA" . "http://tromey.com/elpa/") 
			 ("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")))
;; https://github.com/dimitri/el-get#readme
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (end-of-buffer) (eval-print-last-sexp)))

;; local sources
;; example:
;; (setq el-get-sources
;;       '((:name magit :after (lambda () (global-set-key (kbd "C-x C-z") 'magit-status)))
;;         (:name asciidoc :type elpa :after (lambda () (autoload 'doc-mode "doc-mode" nil t) (add-to-list 'auto-mode-alist '("\\.adoc$" . doc-mode)) (add-hook 'doc-mode-hook '(lambda () (turn-on-auto-fill) (require 'asciidoc)))))
;;         (:name lisppaste :type elpa)
;;         (:name emacs-goodies-el :type apt-get)))
;; (setq my-packages
;;       (append '(cssh el-get switch-window vkill google-maps nxhtml xcscope yasnippet)
;; 	      (mapcar 'el-get-source-name el-get-sources)))
(setq el-get-sources
      '((:name clojure-mode
	       :type git
	       :url "https://github.com/technomancy/clojure-mode.git") 
        (:name tex-math-preview :type elpa)
        (:name yasnippet
               :type git
               :url "https://github.com/capitaomorte/yasnippet.git"
               :features "yasnippet"
               :compile nil)
        (:name emacs-dirtree
               :type git
               :url "https://github.com/zkim/emacs-dirtree.git"
               :features "dirtree"
               :compile t)
        (:name popup-el
               :type git
               :url "https://github.com/m2ym/popup-el.git"
               :features "popup"
               :compile nil)
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
               :url "http://github.com/m2ym/auto-complete.git"
               :load-path "."
               :post-init (lambda ()
                            (require 'auto-complete)
                            (add-to-list 'ac-dictionary-directories (expand-file-name "dict" pdir))
                            ;; the elc is buggy for some reason
                            (let ((f "~/.emacs.d/el-get/auto-complete/auto-complete-config.elc"))
                              (if (file-exists-p f)
                                  (delete-file f)))
                            (require 'auto-complete-config)
                            (ac-config-default)
                            ))
        ))


