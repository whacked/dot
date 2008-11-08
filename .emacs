(setq inhibit-splash-screen t)

;(setq load-path (cons "~/.emacs.d" load-path))
(add-to-list 'load-path "~/.emacs.d")


; Ruby and RoR configuration
;(setq load-path (cons "/ruby/src/ruby-1.8.6-p111/misc" load-path))
;(setq load-path (cons "~/.emacs.d/emacs-rails" load-path))
;(require 'rails)

(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))


(setq transient-mark-mode t)


(set-default-coding-systems 'undecided-unix)

(require 'yasnippet-bundle)
(yas/initialize)

(load-file "~/.emacs.d/tabbar.el")
(load-file "~/.emacs.d/findr.el")
(load-file "~/.emacs.d/linum.el")
(load-file "~/.emacs.d/actionscript.el")
(global-linum-mode 1)

(column-number-mode 1)
(line-number-mode 1)
(show-paren-mode 1)

(setq-default truncate-lines t)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(desktop-save-mode 1)

(tool-bar-mode 0)
(menu-bar-mode 0)

(global-hl-line-mode 1)
(set-face-background 'hl-line "#EFC")

(load-file "~/.emacs.d/php-mode.el")


(defun insert-timestamp ()
  "Insert date at current cursor position in current active buffer"
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))




; Syntax highlighting
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(cperl-array-face ((t (:foreground "orangered" :bold t))))
 '(cperl-hash-face ((t (:foreground "Red" :bold t))))
 '(cperl-nonoverridable-face ((t (:foreground "orange" :bold t))))
 '(custom-button-face ((t (:bold t :foreground "#3fdfcf"))) t)
 '(custom-group-tag-face ((t (:underline t :foreground "blue"))) t)
 '(custom-saved-face ((t (:underline t :foreground "orange"))) t)
 '(custom-state-face ((t (:foreground "green3"))) t)
 '(custom-variable-button-face ((t (:bold t :underline t :foreground "pink"))) t)
 '(dired-face-permissions ((t (:foreground "green"))))
 '(font-latex-bold-face ((((class color) (background light)) (:bold t))))
 '(font-latex-italic-face ((((class color) (background light)) (:italic t))))
 '(font-latex-math-face ((((class color) (background light)) (:foreground "green3"))))
 '(font-latex-sedate-face ((((class color) (background light)) (:foreground "gold"))))
 '(font-lock-comment-face ((t (:foreground "pink2"))))
 '(font-lock-doc-string-face ((t (:foreground "Wheat3"))))
 '(font-lock-function-name-face ((t (:foreground "blue" :bold t))))
 '(font-lock-keyword-face ((t (:foreground "purple"))))
 '(font-lock-preprocessor-face ((t (:foreground "red" :bold t))))
 '(font-lock-reference-face ((t (:foreground "orangered"))))
 '(font-lock-string-face ((t (:foreground "dark grey"))))
 '(font-lock-type-face ((t (:foreground "#886fff" :bold t))))
 '(font-lock-variable-name-face ((t (:foreground "chocolate" :bold t))))
 '(font-lock-warning-face ((t (:foreground "Violetred" :bold t))))
 '(list-mode-item-selected ((t (:foreground "green"))) t)
 '(message-cited-text ((t (:bold t :italic nil))))
 '(zmacs-region ((t (:background "RoyalBlue"))) t))




; auto completion
;;;;;;;;;;;;;;;;;
(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")

(global-set-key "\C-i" 'my-tab)

(defun my-tab (&optional pre-arg)
  "If preceeding character is part of a word then dabbrev-expand,
else if right of non whitespace on line then tab-to-tab-stop or
indent-relative, else if last command was a tab or return then dedent
one step, else indent 'correctly'"
  (interactive "*P")
  (cond ((= (char-syntax (preceding-char)) ?w)
         (let ((case-fold-search t)) (dabbrev-expand pre-arg)))
        ((> (current-column) (current-indentation))
         (indent-relative))
        (t (indent-according-to-mode)))
  (setq this-command 'my-tab))

(add-hook 'html-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'sgml-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'perl-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'text-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'php-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'ruby-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'java-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
(add-hook 'actionscript-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
; add more hooks here
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(menu-bar-mode t)
 '(newsticker-url-list (quote (("mind brain" "http://www.sciencedaily.com/rss/mind_brain.xml" nil nil nil) ("BBC" "http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml" nil nil nil) ("UDN" "http://udn.com/udnrss/focus.xml" nil nil nil) ("reddit" "http://www.reddit.com/.rss" nil nil nil) ("PPCT" "http://feeds.pocketpcthoughts.com/pocketpcthoughts" nil nil nil) ("/." "http://rss.slashdot.org/Slashdot/slashdot" nil nil nil))))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))




;   ;;;;
;   ;;;; Clojure mode
;   ;;;;
;   (pushnew "~/.emacs.d/jochu-clojure-mode" load-path)
;   (pushnew "~/.emacs.d/jochu-swank-clojure" load-path)
;   (require 'clojure-mode)
;    
;   ;;;;
;   ;;;; Setup slime
;   ;;;;
;    
;   (setf slime-lisp-implementations
;         '((clojure ("c:/dev/cvstree/clojure.svn/clojure.cmd") :init clojure-init)
;                   ;; (ecl ("/usr/bin/ecl"))
;                   ;; (sbcl ("/usr/bin/sbcl") :coding-system 'utf-8-unix)
;                   ))
;   (require 'slime-autoloads)
;   (slime-setup '(slime-scratch slime-editing-commands))
;   (pushnew  "c:/dev/cvstree/swank-clojure.git" load-path)
;   (require 'swank-clojure)
;    
;   (defun run-clojure ()
;     "Starts clojure in slime"
;     (interactive)
;     (slime 'clojure))

