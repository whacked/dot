;; package management
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ;; ("ELPA" . "http://tromey.com/elpa/") 
			 ("marmalade" . "http://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

;; https://github.com/dimitri/el-get#readme
(add-to-list 'load-path "~/dot/.emacs.d/el-get/el-get")
(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (end-of-buffer) (eval-print-last-sexp)))

;; for MELPA packages
;; ref http://stackoverflow.com/questions/23165158/how-do-i-install-melpa-packages-via-el-get
(require 'el-get-elpa)
;; then call el-get-elpa-build-local-recipes
(package-initialize)

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




;;;;(when
;;;;    (load
;;;;     (expand-file-name "~/dot/.emacs.d/elpa/package.el"))
;;;;  ;; Add the original Emacs Lisp Package Archive
;;;;  (add-to-list 'package-archives
;;;;               '("elpa" . "http://tromey.com/elpa/"))
;;;;  ;; Add the user-contributed repository
;;;;  (add-to-list 'package-archives
;;;;               '("marmalade" . "http://marmalade-repo.org/packages/"))
;;;;  (package-initialize))


