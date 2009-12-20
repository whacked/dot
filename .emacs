(add-to-list 'load-path "~/.emacs.d")
(load-file "~/.emacs.d/findr.el")
(load-file "~/.emacs.d/linum.el")
(load-file "~/.emacs.d/yaml-mode/yaml-mode.el")
(load-file "~/.emacs.d/actionscript.el")
(load-file "~/.emacs.d/matlab.el")
(load-file "~/.emacs.d/revive.el")
(load-file "~/.emacs.d/php-mode.el")
(load "~/.emacs.d/nxhtml/autostart.el")

; windows only
; (load-file "~/.emacs.d/martin-w32-fullscreen.el")

; (global-linum-mode 1)

(setq matlab-auto-fill nil)
(setq inhibit-splash-screen t)
(line-number-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(setq-default truncate-lines t)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(desktop-save-mode 1)
(global-hl-line-mode 1)

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
 
(tool-bar-mode 0)
(menu-bar-mode 0)
 
(set-face-background 'hl-line "controlHighlightColor")
;(set-face-background 'hl-line "blue")
 
 
 
 
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
 
 
 
 
;;;;;;;;;;;;;;;;;;;;;;;
;; <auto completion> ;;
;;;;;;;;;;;;;;;;;;;;;;;
(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")
 
(global-set-key "\C-i" 'my-tab)
(global-set-key [M-left] 'windmove-left)
(global-set-key [M-right] 'windmove-right)
(global-set-key [M-up] 'windmove-up)
(global-set-key [M-down] 'windmove-down)
 
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
             (local-set-key "\C-i" 'my-tab)))
(add-hook 'sgml-mode-hook
          '(lambda ()
             (local-set-key "\C-i" 'my-tab)))
(add-hook 'perl-mode-hook
          '(lambda ()
             (local-set-key "\C-i" 'my-tab)))
(add-hook 'text-mode-hook
          '(lambda ()
             (local-set-key "\C-i" 'my-tab)))
(add-hook 'php-mode-hook
          '(lambda ()
             (local-set-key "\C-i" 'my-tab)))
(add-hook 'ruby-mode-hook
          '(lambda ()
             (local-set-key "\C-i" 'my-tab)))
(add-hook 'java-mode-hook
          '(lambda ()
             (local-set-key "\C-i" 'my-tab)))
(add-hook 'actionscript-mode-hook
          '(lambda ()
             (local-set-key "\C-i" 'my-tab)))
(add-hook 'lisp-mode-hook
          '(lambda ()
             (local-set-key "\C-i"     'my-tab)))
;;;;;;;;;;;;;;;;;;;;;;;
;; </auto completion> ;;
;;;;;;;;;;;;;;;;;;;;;;;



; add more hooks here
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(menu-bar-mode t)
 '(org-modules (quote (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m)))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))


;;; ;;;;;;;;;;;;;;;
;;; ;; <clojure> ;;
;;; ;;;;;;;;;;;;;;;
;;; (setq clojure-src-root $CLOJURE_PATH)
;;; (eval-after-load 'clojure-mode '(clojure-slime-config))
;;; (setq swank-clojure-jar-path (concat clojure-src-root "/clojure/clojure.jar")
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

; javascript-mode override
; 2009-06-13 18:45:02
(setq javascript-indent-level 2)

;;; taken from WINDOWS
;;; ; gnuserv
;;; (defvar dv-initial-frame (car (frame-list))     "Holds initial frame.")
;;; 
;;; (defun dv-focus-frame (frame)           "pop to top and give focus"
;;; ;;          Code 'borrowed' from frame.el.
;;; ;;         (Meaning I don't understand it. But it beats all I tried.  :)
;;;   (make-frame-visible frame)
;;;   (raise-frame frame)
;;;   (select-frame frame)
;;;   (w32-focus-frame frame))
;;; 
;;; (defun dv-focus-initial-frame ()        "Make the initial frame visible"
;;;   (dv-focus-frame dv-initial-frame))
;;; 
;;; (defvar dv-mail-frames ()               "Frames created by dv-do-mailto")
;;; 
;;; (defun dv-do-mailto (arg)               "For handling mailto URLs via gnudoit"
;;;   (dv-focus-frame (make-frame))
;;;   (message-mail (substring arg 7))
;;;   (delete-other-windows)
;;;   (setq dv-mail-frames (cons (selected-frame) dv-mail-frames)))
;;; 
;;; (defun dv-close-client-frame ()         "Close frame, kill client buffer."
;;;   (interactive)
;;;   (if (or (not (member (selected-frame) dv-mail-frames))
;;;           (and (> (length (buffer-name)) 4)
;;;                (equal (substring (buffer-name) 0 5) "*mail")
;;;                (not (buffer-modified-p))))
;;;       (kill-buffer (current-buffer)))
;;;   (setq dv-mail-frames (delete (selected-frame) dv-mail-frames))
;;;   (if (equal (selected-frame) dv-initial-frame)
;;;       (iconify-frame)
;;;     (delete-frame)))
;;; (global-set-key [\M-f4] 'dv-close-client-frame)
;;; 
;;; (defun dv-paste-to-temp ()              "Load clipboard in a temp buffer"
;;;   (dv-focus-frame (make-frame))
;;;   (switch-to-buffer (generate-new-buffer "temp"))
;;;   (clipboard-yank))
;;; 
;;; (add-to-list 'load-path "~/.emacs.d/GnuServe")
;;; (require 'gnuserv)
;;; (gnuserv-start)
;;; 
;;; 
;;; (setq air-adl-path $ADL_PATH)
;;; (defun air-run ()
;;;   (interactive)
;;;   (shell-command
;;;    (format 
;;;     (concat air-adl-path " " 
;;;             (first (split-string
;;;                     (first (split-string (buffer-file-name) "\\."))
;;;                     "-app"))
;;;             "-app.xml"
;;;             ))))




;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))



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
;;;;;;;;;;;;;;;;;;;;;;;;
;; </org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;;



(require 'ess-site)


;;;;;;;;;;;;;;;;;;;;;;
;; <custom command> ;;
;;;;;;;;;;;;;;;;;;;;;;
;;; http://emacs-fu.blogspot.com/2009/04/dot-emacs-trickery.html
;;; Don't quit unless you mean it!
(defun maybe-save-buffers-kill-emacs (really) 
  "If REALLY is 'yes', call save-buffers-kill-emacs."
  (interactive "sAre you sure about this? ")
  (if (equal really "yes") 
      (save-buffers-kill-emacs)))
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



; <CSS color values colored by themselves>
; http://xahlee.org/emacs/emacs_html.html
(defun hexcolour-add-to-font-lock ()
  (font-lock-add-keywords 
   nil 
   '((;"#[abcdef[:digit:]]\\{6\\}" ; 
      "#\\([abcdef[:digit:]]\\{6\\}\\|[abcdef[:digit:]]\\{3\\}\\)"
      (0 (put-text-property
          (match-beginning 0)
          (match-end 0)
          'face (list :background 
                      (let ((property (match-string-no-properties 0)))
                        (if (< 5 (length property))
                            property ; 6-char color
                          (format "#%s%s%s%s%s%s"
                                  (substring property 1 2)
                                  (substring property 1 2)
                                  (substring property 2 3)
                                  (substring property 2 3)
                                  (substring property 3 4)
                                  (substring property 3 4)
                                  ))  ; 3-char color
                       )
                      )))))))


(add-hook 'css-mode-hook 'hexcolour-add-to-font-lock)
; </CSS color values colored by themselves>







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
;;;;;; </OS X customizations> ;;;;;;


(add-to-list 'load-path "$PATH_TO_ORG_CONTRIB/org-mode/contrib/lisp")
(require 'org-babel-init)
(require 'org-babel-python)
(require 'org-babel-ruby)
(require 'org-babel-R)
(org-babel-load-library-of-babel)
;;;;;;;;;;;;;;;;;;;;;;
;; </custom command> ;;
;;;;;;;;;;;;;;;;;;;;;;





;;;;;;;;;;;;;;;;;;
;; <newsticker> ;;
;;;;;;;;;;;;;;;;;;
(setq newsticker-url-list
      '($URL_LIST        ))
;;;;;;;;;;;;;;;;;;;
;; </newsticker> ;;
;;;;;;;;;;;;;;;;;;;
