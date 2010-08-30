(add-to-list 'load-path "~/.emacs.d")
(load-file "~/.emacs.d/actionscript.el")
(load-file "~/.emacs.d/revive.el")

;(load "~/.emacs.d/nxhtml/autostart.el")

; windows only
; (load-file "~/.emacs.d/martin-w32-fullscreen.el")

; (global-linum-mode 1)

(load-file "~/.emacs.d/matlab.el")
(setq matlab-auto-fill nil)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))

(setq inhibit-splash-screen t)
(line-number-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(setq-default truncate-lines t)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(desktop-save-mode 1)
(global-hl-line-mode 1)
(iswitchb-mode 1)

(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

(setq transient-mark-mode t)

(set-default-coding-systems 'undecided-unix)
 
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe Emacs" t)
(load-file "~/.emacs.d/windows.el")
(require 'windows)
(win:startup-with-window)
 
(setq-default truncate-lines t)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
 
;(tool-bar-mode 0)
;(menu-bar-mode 0)
 
;(set-face-background 'hl-line "controlHighlightColor")
;(set-face-background 'hl-line "blue")
 
 
 


 

(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")






;;;;;;;;;;;;;;;;;
;; <yasnippet> ;;
;;;;;;;;;;;;;;;;;

(add-to-list 'load-path
             "~/.emacs.d/plugins/yasnippet-read-only/")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/plugins/yasnippet-read-only/snippets")

;;;;;;;;;;;;;;;;;;
;; </yasnippet> ;;
;;;;;;;;;;;;;;;;;;





; add more hooks here
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(exec-path (quote ("/opt/local/bin" "/usr/bin" "/usr/local/bin" "/usr/sbin" "/bin")))
 '(menu-bar-mode t)
 '(org-modules (quote (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m)))
 '(org-startup-folded (quote showeverything))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))




;;; ;;;;;;;;;;;;;;;
;;; ;; <clojure> ;;
;;; ;;;;;;;;;;;;;;;
;;; (setq clojure-src-root "~/dev/clojure")
;;; (eval-after-load 'clojure-mode '(clojure-slime-config))
;;; (setq swank-clojure-jar-path (concat clojure-src-root "/clojure.jar")
;;;       swank-clojure-extra-classpaths
;;;       (list (concat clojure-src-root "/clojure-contrib/src/")))
;;; ;;;;;;;;;;;;;;;
;;; ;; </clojure> ;;
;;; ;;;;;;;;;;;;;;;

;;;;;;;;;;
;; <W3> ;;
;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/w3")
(add-to-list 'load-path "~/.emacs.d/w3/lisp")
(require 'w3-auto)
;;;;;;;;;;
;; </W3> ;;
;;;;;;;;;;


(setq TeX-command-master "latex")

(load "/usr/share/emacs/site-lisp/auctex.el" nil t t)
(load "/usr/share/emacs/site-lisp/preview-latex.el" nil t t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query t)





; javascript-mode override
; 2009-06-13 18:45:02
(setq javascript-indent-level 2)


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))

(require 'muse-wiki)



(setenv "PATH" (format "%s:%s" (getenv "PATH") "/usr/texbin:/usr/local/bin"))


(setq echo-keystrokes 0.1) ;; = delay for minibuffer display after pressing function key default is 1




;;;;;;;;;;;;;;;;;;;;;;;
;; <org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;; org-mode with remember
(org-remember-insinuate)
(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/todos.org"))
(define-key global-map "\C-cr" 'org-remember)

(setq org-remember-templates
 '(("Todo" ?t "* TODO [#%^{IMPORTANCE|B}] [%^{URGENCY|5}] %?\nAdded: %U" "~/org/todos.org" "Tasks")
   ("CNE-todo" ?c "* TODO [#%^{IMPORTANCE|B}] [%^{URGENCY|5}] %?\nAdded: %U" "~/org/cne.org" "All Todo")
   ("Nikki" ?n "* %U %?\n\n %i\n %a\n\n" "~/org/nikki.org" "ALL")
   ("State" ?s "* %U %? " "~/org/state.org")
   ("Vocab" ?v "* %U %^{Word}\n%?\n# -*- xkm-export -*-\n" "~/org/vocab.org")
   ("Idea" ?i "* %^{Title}\n%?\n  %a" "~/org/idea.org")))
(setq org-agenda-files (quote("~/org/cne.org"
                              "~/org/idea.org"
                              "~/org/nikki.org"
                              "~/org/todos.org"
                              "~/org/vocab.org"
                              "~/org/xkm.org"
                              "~/org/的.org")))

(require 'iimage)
;(setq iimage-mode-image-search-path (expand-file-name "~/"))
;;Match org file: links
(add-to-list 'iimage-mode-image-regex-alist
             (cons (concat "\\[\\[file:\\(~?" iimage-mode-image-filename-regex
                           "\\)\\]")  1))
;;;;;;;;;;;;;;;;;;;;;;;;
;; </org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;;



;; (require 'ess-site)


;;;;;;;;;;;;;;;;;;;;;;
;; <custom command> ;;
;;;;;;;;;;;;;;;;;;;;;;
;;; Don't quit unless you mean it!
(defun maybe-save-buffers-kill-emacs (really) 
  "If REALLY is 'yes', call save-buffers-kill-emacs."
  (interactive "sAre you sure about this? ")
  (if (equal really "yes") 
      (progn
        ;(win-save-all-configurations)
        (save-buffers-kill-emacs))))
(global-set-key [(control x)(control c)] 'maybe-save-buffers-kill-emacs)

(defun wsm () (interactive) (win-switch-menu))

(defun surround-region-with-tag (tag-name beg end)
  (interactive "sTag name: \nr")
  (save-excursion
    (goto-char end)
    (insert "</" tag-name ">")
    (goto-char beg)
    (insert "<" tag-name ">")
    ))
(defun wrap-region (lt rt beg end)
  "wrap region with arbitrary text, left goes to left, right goes to right"
  (interactive)
  (save-excursion
    (goto-char end)
    (insert rt)
    (goto-char beg)
    (insert lt)
    ))
(defun wrap-paren ()
  (interactive)
  (save-excursion
    (wrap-region "(" ")" (region-beginning) (region-end))))

(defun now ()
  (interactive)
  (message (format-time-string "%Y-%m-%d %H:%M:%S")))
(defun insert-timestamp ()
  "Insert date at current cursor position in current active buffer"
  (interactive)
  (insert (now)))

(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
          (oldalpha (if alpha-or-nil alpha-or-nil 100))
          (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

 ;; C-8 will increase opacity (== decrease transparency)
 ;; C-9 will decrease opacity (== increase transparency
 ;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))



(load-file "~/.emacs.d/jd-el/rainbow-mode.el")
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)




;;;;;; <OS X customizations> ;;;;;;
;;; turn apple key into Meta
(setq ns-command-modifier 'meta)
(if (eq window-system 'mac) (require 'carbon-font))
(setq ; xwl-default-font "Monaco-12"
      xwl-japanese-font "Hiragino_Kaku_Gothic_ProN")
(let ((charset-font `((japanese-jisx0208 . ,xwl-japanese-font)
                      (japanese-jisx0208 . ,xwl-japanese-font)
                      ;; (japanese-jisx0212 . ,xwl-japanese-font)
                      )))
  ; (set-default-font xwl-default-font)
  (mapc (lambda (charset-font)
          (set-fontset-font (frame-parameter nil 'font)
                            (car charset-font)
                            (font-spec :family (cdr charset-font) :size
                                       12)))
        charset-font))
(defun osx-resize-current-window ()
  (interactive)
  (let* ((ncol (string-to-number (read-from-minibuffer "ncol? ")))
         (nrow (string-to-number (read-from-minibuffer "nrow? "))))
    (set-frame-size (selected-frame) ncol nrow)
    ))
(defun osx-move-current-window ()
  (interactive)
  (let* ((x (string-to-number (read-from-minibuffer "x? ")))
         (y (string-to-number (read-from-minibuffer "y? "))))
    (set-frame-position (selected-frame) x y)
    ))
(defun osx-w1 ()
  (interactive)
  (set-frame-size (selected-frame) 200 56)
  (set-frame-position (selected-frame) 0 20))
(defun osx-w2 ()
  (interactive)
  (set-frame-position (selected-frame) 1440 -200)
  (set-frame-position (selected-frame) 1440 -200)
  (set-frame-size (selected-frame) 268 78))
(defun osx-w-lh ()
  (interactive)
  (set-frame-position (selected-frame) 40 22)
  (set-frame-size (selected-frame) 100 56))
(defun osx-w-rh ()
  (interactive)
  (set-frame-position (selected-frame) 600 22)
  (set-frame-size (selected-frame) 100 56))
;;;;;; </OS X customizations> ;;;;;;


(add-to-list 'load-path "~/ubin/elisp/org-6.36c/lisp")
(add-to-list 'load-path "~/ubin/elisp/org-6.36c/contrib/lisp")
(require 'org-install)
(require 'org-babel-init)
(require 'org-babel-python)
(require 'org-babel-ruby)
(require 'org-babel-R)
(org-babel-load-library-of-babel)
;;;;;;;;;;;;;;;;;;;;;;
;; </custom command> ;;
;;;;;;;;;;;;;;;;;;;;;;







;(setq ipython-command "/opt/local/bin/ipython")
;(require 'ipython)
;(setq py-python-command-args '( "-colors" "Linux"))
;(require 'python-mode)
(setenv "PYTHONPATH" "/opt/local/bin/python")




;;;;;;;;;;;;;;;;;;
;; <newsticker> ;;
;;;;;;;;;;;;;;;;;;
(setq newsticker-url-list
      '(("mind brain" "http://www.sciencedaily.com/rss/mind_brain.xml" nil nil nil)
        ("BBC" "http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml" nil nil nil)
        ("UDN" "http://udn.com/udnrss/focus.xml" nil nil nil)
        ("reddit" "http://www.reddit.com/.rss" nil nil nil)
        ("PPCT" "http://feeds.pocketpcthoughts.com/pocketpcthoughts" nil nil nil)
        ("slashdot" "http://rss.slashdot.org/Slashdot/slashdot" nil nil nil)
        ("Ken Tilton's blog" "http://smuglispweeny.blogspot.com/feeds/posts/default" nil nil nil)
        ("ku-ma-ne まめめも" "http://d.hatena.ne.jp/ku-ma-me/rss" nil nil nil)
        ("Lazy Pythonista" "http://lazypython.blogspot.com/feeds/posts/default" nil nil nil)
        ("catonmat" "http://feeds.feedburner.com/catonmat" nil nil nil)
        ("tim gowers" "http://gowers.wordpress.com/feed/" nil nil nil)
        ("Lambda the Ultimate" "http://lambda-the-ultimate.org/rss.xml" nil nil nil)
        ("Fire Hose Games" "http://www.firehosegames.com/feed/" nil nil nil)
        ("Language log" "http://languagelog.ldc.upenn.edu/nll/?feed=rss2" nil nil nil)
        ("Will Larson's code blog" "http://lethain.com/feeds/flow/code/" nil nil nil)
        ("The Big Picture" "http://www.ritholtz.com/blog/feed/" nil nil nil)
        ))
;;;;;;;;;;;;;;;;;;;
;; </newsticker> ;;
;;;;;;;;;;;;;;;;;;;




 


;; django mode
; (load "~/.emacs.d/django-mode/django-mode.el")
; (yas/load-directory "~/.emacs.d/django-mode/snippets")





;;; http://sites.google.com/site/steveyegge2/my-dot-emacs-file
;; someday might want to rotate windows if more than 2 of them
(defun win-swap ()
 "If you have 2 windows, it swaps them." (interactive) (cond ((not (= (count-windows) 2)) (message "You need exactly 2 windows to do this."))
 (t
 (let* ((w1 (first (window-list)))
	 (w2 (second (window-list)))
	 (b1 (window-buffer w1))
	 (b2 (window-buffer w2))
	 (s1 (window-start w1))
	 (s2 (window-start w2)))
 (set-window-buffer w1 b2)
 (set-window-buffer w2 b1)
 (set-window-start w1 s2)
 (set-window-start w2 s1)))))

;;; http://github.com/banister/window-rotate-for-emacs/blob/master/window-rotate.el
(defun rotate-windows-helper (x d)
  (if (equal (cdr x) nil) (set-window-buffer (car x) d)
    (set-window-buffer (car x) (window-buffer (cadr x))) (rotate-windows-helper (cdr x) d)))
 
(defun win-rotate ()
  (interactive)
  (rotate-windows-helper (window-list) (window-buffer (car (window-list))))
  (select-window (car (last (window-list)))))



(set-cursor-color "green")


(require 'swank-clojure)
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/clj-tuples-0.3.3.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/clojure-1.1.0.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/clojure-contrib-1.1.0.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/clojureql-1.0.0.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/clout-0.2.0-20100502.112537-4.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/commons-codec-1.4.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/commons-fileupload-1.2.1.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/commons-io-1.4.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/compojure-0.4.0-20100308.145053-8.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/derby-10.5.3.0_1.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/hiccup-0.2.4.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/jetty-6.1.14.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/jetty-util-6.1.14.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/matchure-0.9.1.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/mysql-connector-java-5.0.5.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/postgresql-8.2-504.jdbc4.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/ring-core-0.2.0.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/ring-jetty-adapter-0.2.0.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/ring-servlet-0.2.0.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/servlet-api-2.5-6.1.14.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/snakeyaml-1.5.jar")
(add-to-list 'swank-clojure-extra-classpaths "~/dev/clojure/xn/lib/vijual-0.1.0-20091229.021828-11.jar       ")



(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-jsc-light2)))
 

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit outline-1 :weight bold :height 1.6 :family "Verdana"))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.5 :family "Verdana"))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.4 :family "Verdana"))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.3 :family "Verdana"))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.2 :family "Verdana"))))
 '(org-level-6 ((t (:inherit outline-6 :height 1.1 :family "Verdana")))))


;; (global-set-key [M-left] 'windmove-left)
;; (global-set-key [M-right] 'windmove-right)
;; (global-set-key [M-up] 'windmove-up)
;; (global-set-key [M-down] 'windmove-down)
(global-set-key "\C-x\C-b" 'bs-show)


;;; custom override keys
;;; ref http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")
(define-key my-keys-minor-mode-map [M-left] 'windmove-left)
(define-key my-keys-minor-mode-map [M-right] 'windmove-right)
(define-key my-keys-minor-mode-map [M-up] 'windmove-up)
(define-key my-keys-minor-mode-map [M-down] 'windmove-down)
(define-key my-keys-minor-mode-map (kbd "M-_") 'org-metaleft)
(define-key my-keys-minor-mode-map (kbd "M-+") 'org-metaright)
(define-key my-keys-minor-mode-map [tab] 'yas/expand-from-trigger-key)
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)

