(setq inhibit-splash-screen t)

(add-to-list 'load-path "~/.emacs.d")

(dolist (path '("~/.emacs.d/revive.el"
                "~/.emacs.d/matlab.el"
                "~/.emacs.d/jd-el/rainbow-mode.el"
                "~/.emacs.d/windows.el"
                "~/.emacs.d/elpa/yaml-mode-0.0.5/yaml-mode.el"
                "~/.emacs.d/bundle/zencoding/zencoding-mode.el"
                "~/.emacs.d/graphviz-dot-mode.el"
                ))
  (load-file path))

; windows only
; (load-file "~/.emacs.d/martin-w32-fullscreen.el")

(setq matlab-auto-fill nil)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))

;; set-true
(dolist (fn-setting '(line-number-mode
                      column-number-mode
                      show-paren-mode
                      desktop-save-mode
                      global-hl-line-mode
                      iswitchb-mode))
  (apply fn-setting '(t)))

(setq-default truncate-lines t
              tab-width 2
              indent-tabs-mode nil
              echo-keystrokes 0.1 ;; = delay for minibuffer display after pressing function key default is 1
              )

(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

(set-default-coding-systems 'undecided-unix)
 
(autoload 'save-current-configuration "revive" "Save status" t)
(autoload 'resume "revive" "Resume Emacs" t)
(autoload 'wipe "revive" "Wipe Emacs" t)
;; (autoload 'paredit-mode "paredit"
;;   "Minor mode for pseudo-structurally editing Lisp code." t)
;; (add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
;; (add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
;; (add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
(require 'windows)
(win:startup-with-window)


;(set-face-background 'hl-line "controlHighlightColor")
;(set-face-background 'hl-line "blue")
 
 
 


 

(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")




;;;;;;;;;;;;;;;;;
;; <yasnippet> ;;
;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/bundle/yasnippet-read-only/")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/bundle/yasnippet-read-only/snippets")

;;;;;;;;;;;;;;;;;;
;; </yasnippet> ;;
;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.d/bundle/autopair-read-only/")
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers 
(add-hook 'js2-mode-hook #'(lambda () (setq autopair-dont-activate t))) ; the #'(lambda ...) form is the same as just doing (lambda ...). leaving it here just as example






;;;;; js mode customization
;;;;; ref: https://github.com/mitchellh/dotfiles/blob/master/emacs.d/modes.el
;; js-mode (espresso)
;; Espresso mode has sane indenting so we use that.
(setq js-indent-level 2)

;; Customize JS2
(setq js2-basic-offset 2)
(setq js2-cleanup-whitespace t)

;; Custom indentation function since JS2 indenting is terrible.
;; Uses js-mode's (espresso-mode) indentation semantics.
;;
;; Based on: http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
;; (Thanks!)
(defun my-js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (js--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ js-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun my-js2-mode-hook ()
  (if (not (boundp 'js--proper-indentation))
      (progn (js-mode)
             (remove-hook 'js2-mode-hook 'my-js2-mode-hook)
             (js2-mode)
             (add-hook 'js2-mode-hook 'my-js2-mode-hook)))
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (message "JS2 mode hook ran."))

;; Add the hook so this is all loaded when JS2-mode is loaded
(add-hook 'js2-mode-hook 'my-js2-mode-hook)





; add more hooks here
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(appt-audible nil)
 '(appt-disp-window-function (lambda (n-min-away tm-due message) (growl (format "in %s minutes" n-min-away) message)))
 '(column-number-mode t)
 '(exec-path (quote ("/opt/local/bin" "/usr/bin" "/usr/local/bin" "/usr/sbin" "/bin")))
 '(menu-bar-mode nil)
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-window-setup (quote other-window))
 '(org-export-blocks (quote ((src org-babel-exp-src-blocks nil) (comment org-export-blocks-format-comment t) (ditaa org-export-blocks-format-ditaa nil) (dot org-export-blocks-format-dot nil))))
 '(org-modules (quote (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m)))
 '(org-startup-folded (quote showeverything))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))





(setq TeX-command-master "latex")

;; commented out for ubuntu
;;(load "/usr/share/emacs/site-lisp/auctex.el" nil t t)
;;(load "/usr/share/emacs/site-lisp/preview-latex.el" nil t t)
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
;; w3 should be loaded by ELPA
(require 'w3-auto)



;; commented out for ubuntu
;;(setenv "PATH" (format "%s:%s" (getenv "PATH") "/usr/texbin:/usr/local/bin"))




;;;;;;;;;;;;;;;;;;;;;;;
;; <org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;
;; commented out for ubuntu
(add-to-list 'load-path "~/.emacs.d/bundle/org-mode/lisp")
(add-to-list 'load-path "~/.emacs.d/bundle/org-mode/contrib/lisp")
(require 'org-install)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (python . t)
   (emacs-lisp . t)
   (ruby . t)
   (sh . t)
   (clojure . t)
   (haskell . t)
   (dot . t)
   ))
(defun ansi-unansify (beg end)
  "to help fix ansi- control sequences in babel-sh output"
  (interactive (list (point) (mark)))
  (unless (and beg end)
    (error "The mark is not set now, so there is no region"))
  (insert (ansi-color-filter-apply (filter-buffer-substring beg end t))))


(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(defun org-add-appt-after-save-hook ()
  (if (string= mode-name "Org") (org-agenda-to-appt)))
(add-hook 'after-save-hook 'org-add-appt-after-save-hook)
(appt-activate 1)

;;; org-mode with remember
(org-remember-insinuate)
(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/todos.org"))
;(define-key global-map "\C-cr" 'org-remember)
(define-key global-map "\M-\C-r" 'org-remember)

(setq org-remember-templates
 '(("Todo" ?t "* TODO %?\nAdded: %U" "~/note/org/todos.org" "Tasks")
   ("CNE-todo" ?c "* TODO [#%^{IMPORTANCE|B}] [%^{URGENCY|5}] %?\nAdded: %U" "~/note/org/cne.org" "All Todo")
   ("Nikki" ?n "* %U %?\n\n %i\n %a\n\n" "~/note/org/nikki.org" "ALL")
   ("State" ?s "* %U %? " "~/note/org/state.org")
   ("Vocab" ?v "* %U %^{Word}\n%?\n# -*- xkm-export -*-\n" "~/note/org/vocab.org")
   ("Idea" ?i "* %^{Title}\n%?\n  %a" "~/note/org/idea.org")))

(setq org-agenda-files '("~/note/org/cne.org"
                         "~/note/org/idea.org"
                         "~/note/org/nikki.org"
                         "~/note/org/todos.org"
                         "~/note/org/vocab.org"
                         "~/note/org/的.org"))

(require 'iimage)
;(setq iimage-mode-image-search-path (expand-file-name "~/"))
;;Match org file: links
(add-to-list 'iimage-mode-image-regex-alist
             (cons (concat "file:\\(~?[]\\[\\(\\),~+./_0-9a-zA-Z -]+\\.\\(GIF\\|JP\\(?:E?G\\)\\|P\\(?:BM\\|GM\\|N[GM]\\|PM\\)\\|SVG\\|TIFF?\\|X\\(?:[BP]M\\)\\|gif\\|jp\\(?:e?g\\)\\|p\\(?:bm\\|gm\\|n[gm]\\|pm\\)\\|svg\\|tiff?\\|x\\(?:[bp]m\\)\\)\\)")  1))
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
(defun kill-emacs-NOW-iikara ()
  (setq kill-emacs-hook nil)
  (kill-emacs))

(defun wsm () (interactive) (win-switch-menu))

(defun surround-region-with-tag (tag-name beg end)
  (interactive "sTag name: \nr")
  (save-excursion
    (goto-char end)
    (insert "</" tag-name ">")
    (goto-char beg)
    (insert "<" tag-name ">")))

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



(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(require 'ansi-color)


;;;;;; <ubuntu-tp customizations> ;;;;;;
(defun ubu-w1 ()
  (interactive)
  (set-frame-size (selected-frame) 177 50))
(defun ubu-w2 ()
  (interactive)
  (set-frame-position (selected-frame) 1280 0)
  (set-frame-size (selected-frame) 268 73))
;; use x-clipboard
(setq x-select-enable-clipboard t)
;;;;;; <ubuntu-tp customizations> ;;;;;;




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
    (set-frame-size (selected-frame) ncol nrow)))
(defun osx-move-current-window ()
  (interactive)
  (let* ((x (string-to-number (read-from-minibuffer "x? ")))
         (y (string-to-number (read-from-minibuffer "y? "))))
    (set-frame-position (selected-frame) x y)))
(defun osx-w1 ()
  (interactive)
  (set-frame-size (selected-frame) 200 56)
  (set-frame-position (selected-frame) 0 20))
(defun osx-w2 ()
  (interactive)
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
(defun osx-w-h ()
  (interactive)
  (set-frame-size (selected-frame) (frame-width) (cond ((= 56 (frame-height)) 67)
                                                       ((= 67 (frame-height)) 78)
                                                       ((= 78 (frame-height)) 56))))
;;;;;; </OS X customizations> ;;;;;;


;;;;;;;;;;;;;;;;;;;;;;
;; </custom command> ;;
;;;;;;;;;;;;;;;;;;;;;;







;(setq ipython-command "/opt/local/bin/ipython")
;(require 'ipython)
;(setq py-python-command-args '( "-colors" "Linux"))
;(require 'python-mode)
(setenv "PYTHONPATH" "/opt/local/bin/python")
(setenv "PATH" (concat "/opt/local/bin:" (getenv "PATH")))





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



;;; (require 'swank-clojure)
;;; (dolist (xn-lib-path '("clj-tuples-0.3.3.jar"
;;;                        "clojure-1.1.0.jar"
;;;                        "clojure-contrib-1.1.0.jar"
;;;                        "clojureql-1.0.0.jar"
;;;                        "clout-0.2.0-20100502.112537-4.jar"
;;;                        "commons-codec-1.4.jar"
;;;                        "commons-fileupload-1.2.1.jar"
;;;                        "commons-io-1.4.jar"
;;;                        "compojure-0.4.0-20100308.145053-8.jar"
;;;                        "derby-10.5.3.0_1.jar"
;;;                        "hiccup-0.2.4.jar"
;;;                        "jetty-6.1.14.jar"
;;;                        "jetty-util-6.1.14.jar"
;;;                        "matchure-0.9.1.jar"
;;;                        "mysql-connector-java-5.0.5.jar"
;;;                        "postgresql-8.2-504.jdbc4.jar"
;;;                        "ring-core-0.2.0.jar"
;;;                        "ring-jetty-adapter-0.2.0.jar"
;;;                        "ring-servlet-0.2.0.jar"
;;;                        "servlet-api-2.5-6.1.14.jar"
;;;                        "snakeyaml-1.5.jar"
;;;                        "vijual-0.1.0-20091229.021828-11.jar"))
;;;   (add-to-list 'swank-clojure-extra-classpaths (concat "~/dev/clojure/xn/lib/" xn-lib-path)))
;;; ;;;;;;;;;;;;;;;;;
;;; ;;;; <clojure> ;;
;;; ;;;;;;;;;;;;;;;;;
;;; ;;(setq clojure-src-root "~/dev/clojure")
;;; ;;;(eval-after-load 'clojure-mode '(clojure-slime-config))
;;; ;;(setq swank-clojure-jar-path (concat clojure-src-root "/clojure.jar")
;;; ;;      swank-clojure-extra-classpaths
;;; ;;      (list (concat clojure-src-root "/clojure-contrib/src/")))
;;; ;;(slime-setup)
;;; ;;;;;;;;;;;;;;;;;
;;; ;;;; </clojure> ;;
;;; ;;;;;;;;;;;;;;;;;




(load "~/.emacs.d/haskellmode-emacs/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

;; w3m
(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/w3m")
(setq w3m-command "/usr/bin/w3m")
(require 'w3m-load)
;; commented out for ubuntu
;;(require 'w3m-e21)
(provide 'w3m-e23)


;(add-to-list 'load-path "~/.emacs.d/bundle/icicles")
;(require 'icicles)


(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (load-file "~/.emacs.d/color-theme-6.6.0/themes/color-theme-featured.el")
     (color-theme-initialize)
     (color-theme-github)
     ))

; (set-default-font "Consolas 10")
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#f8f8ff" :foreground "#000000" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family "Consolas"))))
 '(font-lock-keyword-face ((t (:foreground "DarkOliveGreen" :weight bold))))
 '(org-level-1 ((t (:inherit outline-1 :weight bold :height 1.6 :family "Verdana"))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.5 :family "Verdana"))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.4 :family "Verdana"))))
 '(org-level-4 ((t (:inherit outline-4 :foreground "blue" :height 1.3 :family "Verdana"))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.2 :family "Verdana"))))
 '(org-level-6 ((t (:inherit outline-6 :height 1.1 :family "Verdana"))))
 '(region ((t (:background "PapayaWhip")))))
(set-cursor-color "orange")



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




;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
