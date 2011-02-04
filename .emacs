(setq inhibit-splash-screen t)

(add-to-list 'load-path "~/.emacs.d")
                
(dolist (path '("~/.emacs.d/revive.el"
                "~/.emacs.d/matlab.el"
                "~/.emacs.d/haxe-mode.el"
                "~/.emacs.d/jd-el/rainbow-mode.el"
                "~/.emacs.d/windows.el"
                "~/.emacs.d/bundle/zencoding/zencoding-mode.el"
                "~/.emacs.d/graphviz-dot-mode.el"
                "~/.emacs.d/elpa/yaml-mode-0.0.5/yaml-mode.el"
                ))
  (load-file path))

(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))

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

;; prevent special buffers from messing with the current layout
;; see: http://www.gnu.org/software/emacs/manual/html_node/emacs/Special-Buffer-Frames.html
(setq special-display-buffer-names
           '("*grep*" "*tex-shell*" "*Help*" "*Packages*" "*Capture*"))
(setq special-display-function 'my-special-display-function)
(defun my-special-display-function (buf &optional args)
  (special-display-popup-frame buf `((height . 40)
                                     (left . ,(+ 40 (frame-parameter (selected-frame) 'left)))
                                     (top . ,(+ 20 (frame-parameter (selected-frame) 'top))))))

(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")




(add-to-list 'load-path "~/.emacs.d/bundle/autopair-read-only/")
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers 
(add-hook 'js2-mode-hook #'(lambda () (setq autopair-dont-activate t))) ; the #'(lambda ...) form is the same as just doing (lambda ...). leaving it here just as example






;; <js mode customization>
;;;;; ref: https://github.com/mitchellh/dotfiles/blob/master/emacs.d/modes.el
;; js-mode (espresso)
;; Espresso mode has sane indenting so we use that.
(setq js-indent-level 2)

;; Customize JS2
(setq js2-basic-offset 2)
(setq js2-cleanup-whitespace t)

;; Custom indentation function since JS2 indenting is terrible.
;; Uses js-mode's (espresso-mode) indentation semantics.
;; Based on: http://mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
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
  (message "custom JS2 mode hook ran."))

;; Add the hook so this is all loaded when JS2-mode is loaded
(add-hook 'js2-mode-hook 'my-js2-mode-hook)
;; </js mode customization>



(setq-default truncate-lines t
              tab-width 2
              indent-tabs-mode nil
              echo-keystrokes 0.1 ;; = delay for minibuffer display after pressing function key default is 1
              )


; add more hooks here
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 ;;'(appt-disp-window-function (lambda (n-min-away tm-due message) (growl (format "in %s minutes" n-min-away) message)))
 '(column-number-mode t)
 '(desktop-save-mode t)
 '(exec-path (quote ("/opt/local/bin" "/usr/bin" "/usr/local/bin" "/usr/sbin" "/bin")))
 '(global-hl-line-mode t)
 '(hscroll-step 1)
 '(iswitchb-mode t)
 '(line-number-mode t)
 '(matlab-auto-fill nil)
 '(menu-bar-mode nil)
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-window-setup (quote other-window))
 '(org-export-blocks (quote ((src org-babel-exp-src-blocks nil) (comment org-export-blocks-format-comment t) (ditaa org-export-blocks-format-ditaa nil) (dot org-export-blocks-format-dot nil))))
 '(org-modules (quote (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m)))
 '(org-src-fontify-natively t)
 '(org-startup-folded (quote showeverything))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))

;; for smooth scrolling
; (setq scroll-conservatively 10000)


(set-scroll-bar-mode 'right)


(load "auctex.el" nil t t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex) 


(setq TeX-command-master "latex")

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query t)


; javascript-mode override
; 2009-06-13 18:45:02
(setq javascript-indent-level 2)



;;;;;;;;;;;;;;;;;;;;;;;
;; <org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;
; below add-to-list not required if org-mode successfully built with =make= and =make-install=
;(add-to-list 'load-path "~/.emacs.d/bundle/org-mode/lisp")
;(add-to-list 'load-path "~/.emacs.d/bundle/org-mode/contrib/lisp")
(add-to-list 'load-path "~/.emacs.d/dev")
(require 'org-install)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (python . t)
   (C . t)
   (lua . t)
   (gnuplot . t)
   (emacs-lisp . t)
   (ruby . t)
   (sh . t)
   (clojure . t)
   (lisp . t)
   (haskell . t)
   (dot . t)
   (perl . t)
   (matlab . t)
   (octave . t)
   (org . t)
   (latex . t)
   (ditaa . t)
   ))
(add-to-list 'load-path "~/.emacs.d/bundle/org-mode/contrib/lisp/")
(require 'org-drill)
(setq org-ditaa-jar-path "~/.emacs.d/bundle/org-mode/contrib/scripts/ditaa.jar")

(defun ansi-unansify (beg end)
  "to help fix ansi- control sequences in babel-sh output"
  (interactive (list (point) (mark)))
  (unless (and beg end)
    (error "The mark is not set now, so there is no region"))
  (insert (ansi-color-filter-apply (filter-buffer-substring beg end t))))

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;;; org-mode with remember
(org-remember-insinuate)
(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/todos.org"))
;(define-key global-map "\C-cr" 'org-remember)

(define-key global-map "\M-\C-r" 'org-remember)
(setq org-remember-templates
 '(("Todo" ?t "* TODO %?\nAdded: %U" "~/note/org/todos.org" "Tasks")
   ("CNE-todo" ?c "* TODO [#%^{IMPORTANCE|B}] [%^{URGENCY|5}] %?\nAdded: %U" "~/note/cne/cne.org" "All Todo")
   ("Nikki" ?n "* %U %?\n\n %i\n %a\n\n" "~/note/org/nikki.org" "ALL")
   ;; ("State" ?s "* %U %? " "~/note/org/state.org")
   ("Vocab" ?v "* %U %^{Word}\n%?\n# -*- xkm-export -*-\n" "~/note/org/vocab.org")
   ("Idea" ?i "* %^{Title}\n%?\n  %a\n  %U" "~/note/org/idea.org")
   ("Music" ?m "- %? %U\n" "~/note/org/music.org" "good")
   ("Dump" ?d "%?\n" "~/note/org/dump.org")))
(define-key global-map (kbd "<f12>") 'org-agenda)
(defun set-calendar-appt ()
  (save-excursion
    (end-of-buffer)
    (outline-previous-visible-heading 1)
    (backward-char)
    (when (re-search-forward org-ts-regexp nil t)
      (let* ((spl-matched (split-string (match-string 1) " "))
             (date (first spl-matched))
             (time (if (= 3 (length spl-matched)) ;; contains time
                       (third spl-matched)
                     ;; only contains date
                     nil))
             (tm-start (or time "00:00"))
             (alarm "5min")
             (name (save-excursion
                     (end-of-buffer)
                     (outline-previous-visible-heading 1)
                     (backward-char)
                     (when (re-search-forward org-complex-heading-regexp nil t)
                       (replace-regexp-in-string (concat "[[:space:]]*" org-ts-regexp "[[:space:]]*") "" (match-string 4))))))
        (start-process
         "kalarm-process" "*Messages*" "/usr/bin/kalarm" 
         "--color"
         "0x00FF00"
         "--time"
         (format "%s-%s" date tm-start)
         "--reminder"
         "0H5M"
         "--beep"
         (format "%s" name))))))
(add-hook 'org-remember-before-finalize-hook 'set-calendar-appt)

;;; attempt to use org-capture.
;;; remember's work flow is actually more pleasant.
;;; in single buffer visible phase, capture:
;;; 1. creates split buffer, gets selection
;;; 2. fills template in that buffer
;;; 3. completes capture in that buffer
;;; 4. restores original buffer
;;; this is identical to remember
;;; in split-buffer phase, capture:
;;; 1. opens selection window in non-focused buffer (good)
;;; 2. after get selection, fills template in focused buffer,
;;; i.e. it switches away from the window where the selection took place (bad)
;;; 3. when authoring buffer for capture is open, the previously
;;; focused buffer is again put in the split where the template
;;; selection screen came up (bad)
;;; 4. when finished, layout is restored (expected)
;;; the amount of attention shifting is pretty annoying
;;;
;;;;(define-key global-map "\M-\C-r" 'org-capture)
;;;(setq org-capture-templates
;;;      '(("t" "Todo" entry (file "~/note/org/todos.org" "Tasks")
;;;         "* TODO %?\nAdded: %U" :empty-lines 1)
;;;        ("c" "CNE-todo" entry ("~/note/cne/cne.org" "All Todo")
;;;         "* TODO [#%^{IMPORTANCE|B}] [%^{URGENCY|5}] %?\nAdded: %U")
;;;        ("n" "Nikki" entry (file+headline "~/note/org/nikki.org" "ALL")
;;;         "* %U %?\n\n %i\n %a\n\n" :empty-lines 1)
;;;        ("s" "State" entry (file "~/note/org/state.org")
;;;         "* %U %? " :empty-lines 1)
;;;        ("v" "Vocab" plain (file "~/note/org/vocab.org")
;;;         "** %U %^{Word}\n%?\n# -*- xkm-export -*-\n" :empty-lines 1)
;;;        ;; idea template used to be:
;;;        ;; "* %^{Title}\n%?\n  %a"
;;;        ;; but org-capture-fill-template calls (delete-other-windows)
;;;        ;; and maximizes the template-filling buffer
;;;        ;; which is pretty annoying. so simply stop using template prompts
;;;        ("i" "Idea" entry (file "~/note/org/idea.org")
;;;         "* %?\n  %a" :empty-lines 1)
;;;        ("d" "Dump" entry (file+datetree "~/note/org/dump.org")
;;;         "* %?\n%U\n" :empty-lines 1)))

(setq org-agenda-files (map 'list 'expand-file-name '("~/note/cne/cne.org"
                                                      "~/note/org/idea.org"
                                                      "~/note/org/dump.org"
                                                      "~/note/org/nikki.org"
                                                      "~/note/org/todos.org"
                                                      "~/note/org/vocab.org"
                                                      "~/note/org/的.org")))

(require 'iimage)
;(setq iimage-mode-image-search-path (expand-file-name "~/"))
;;Match org file: links
(add-to-list 'iimage-mode-image-regex-alist
             (cons (concat "file:\\(~?[]\\[\\(\\),~+./_0-9a-zA-Z -]+\\.\\(GIF\\|JP\\(?:E?G\\)\\|P\\(?:BM\\|GM\\|N[GM]\\|PM\\)\\|SVG\\|TIFF?\\|X\\(?:[BP]M\\)\\|gif\\|jp\\(?:e?g\\)\\|p\\(?:bm\\|gm\\|n[gm]\\|pm\\)\\|svg\\|tiff?\\|x\\(?:[bp]m\\)\\)\\)")  1))
;;;;;;;;;;;;;;;;;;;;;;;;
;; </org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; <OS-specific command> ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(defun now () (interactive) (message (format-time-string "%Y-%m-%d %H:%M:%S")))
(defun insert-timestamp ()
  "Insert date at current cursor position in current active buffer"
  (interactive) (insert (now)))

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


(cond ((eq system-type 'gnu/linux)
       (progn ;; Linux
         ;; <ubuntu-tp customizations> ;;;;;;
         (defun win:to1 ()
           (interactive)
           (set-frame-size (selected-frame) 177 50))
         (defun win:to2 ()
           (interactive)
           (set-frame-position (selected-frame) 1280 0)
           (set-frame-size (selected-frame) 268 73))
         (defun win:fullscreen ()
           (interactive)
           (let ((f (selected-frame)))
             (modify-frame-parameters f `((fullscreen . ,(if (eq nil (frame-parameter f 'fullscreen)) 'fullboth nil))))))
         ;; use x-clipboard
         (setq x-select-enable-clipboard t)
         ;; <ubuntu-tp customizations> ;;;;;;

         ;; (server-start)

         ;; use anthy
         ;; http://www.emacswiki.org/emacs/IBusMode
         (add-to-list 'load-path "/usr/share/emacs/site-lisp/ibus")
         (require 'ibus)
         (add-hook 'after-init-hook 'ibus-mode-on)
         (setq ibus-agent-file-name "/usr/lib/ibus-el/ibus-el-agent")
         )
       (message "using linux"))
      ((eq system-type 'darwin)
       (progn ;; OS X

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
         (defun win:to1 ()
           (interactive)
           (set-frame-size (selected-frame) 200 56)
           (set-frame-position (selected-frame) 0 20))
         (defun win:to2 ()
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

         ;;(setq ipython-command "/opt/local/bin/ipython")
         ;;(require 'ipython)
         ;;(setq py-python-command-args '( "-colors" "Linux"))
         ;;(require 'python-mode)
         (setenv "PYTHONPATH" "/opt/local/bin/python")
         (setenv "PATH" (concat "/opt/local/bin:" (getenv "PATH")))

         ;; w3m
         ;;(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/w3m")
         ;;(setq w3m-command "/usr/bin/w3m")
         ;;(require 'w3m-load)
         ;;(require 'w3m-e21)
         ;;(provide 'w3m-e23)

         ;;(setenv "PATH" (format "%s:%s" (getenv "PATH") "/usr/texbin:/usr/local/bin"))
         ;;(load "/usr/share/emacs/site-lisp/auctex.el" nil t t)
         ;;(load "/usr/share/emacs/site-lisp/preview-latex.el" nil t t)

         ;;;;;; </OS X customizations> ;;;;;;

         (message "using OS X")
         )
       )
      ((eq system-type 'windows-nt)
       (progn ;; Windows
         ;; windows only
         ;; (load-file "~/.emacs.d/martin-w32-fullscreen.el")
         
         (message "windows")
         )
       )
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; </OS-specific command> ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;




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





(load "~/.emacs.d/haskellmode-emacs/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)


;(add-to-list 'load-path "~/.emacs.d/bundle/icicles")
;(require 'icicles)



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
 ;'(region ((t (:background "PapayaWhip"))))
 )
;(set-cursor-color "orange")

(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     ;(load-file "~/.emacs.d/color-theme-6.6.0/themes/color-theme-featured.el")
     (color-theme-initialize)
     (color-theme-snow)
     ))
; snow's hl-line seems to be same as paren-match color
(set-face-background 'hl-line "PapayaWhip")



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
  ;; Add the original Emacs Lisp Package Archive
  (add-to-list 'package-archives
               '("elpa" . "http://tromey.com/elpa/"))
  ;; Add the user-contributed repository
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/"))
  (package-initialize))

(require 'muse-wiki)
;; w3 should be loaded by ELPA
(require 'w3-auto)

;; <yasnippet> ;; not using elpa version
(add-to-list 'load-path "~/.emacs.d/bundle/yasnippet-read-only/")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/load-directory "~/.emacs.d/bundle/yasnippet-read-only/snippets")
;; </yasnippet> ;;



;; thanks to http://kliketa.wordpress.com/2010/08/04/gtklook-browse-documentation-for-gtk-glib-and-gnome-inside-emacs/
(require 'gtk-look)
(setq browse-url-browser-function
 '(("file:.*/usr/share/doc/.*gtk.*-doc/.*" . w3m-browse-url)
   ("." . browse-url-firefox)))
(defun my-c-mode-hook ()
  (define-key c-mode-map (kbd "C-<return>") 'gtk-lookup-symbol)
  (message "C mode hook ran."))
(add-hook 'c-mode-hook 'my-c-mode-hook)

;;; (setq swank-clojure-binary (expand-file-name "~/.lein/bin/swank-clojure"))
;;; (setq slime-protocol-version "20100404")
;;; (setq swank-clojure-classpath (list
;;;                                (expand-file-name "~/.m2/repository/swank-clojure/swank-clojure/1.3.0-SNAPSHOT/swank-clojure-1.3.0-SNAPSHOT.jar")
;;;                                (expand-file-name "~/.m2/repository/org/clojure/clojure/1.2.0/clojure-1.2.0.jar")))



;; ref: http://emacs-fu.blogspot.com/2009/11/showing-pop-ups.html
(defun djcb-popup (title msg &optional icon sound)
  "Show a popup if we're on X, or echo it otherwise; TITLE is the title
of the message, MSG is the context. Optionally, you can provide an ICON and
a sound to be played"

  (interactive)
  (if (eq window-system 'x)
      (shell-command (concat "notify-send "

                             (if icon (concat "-i " icon) "")
                             " '" title "' '" msg "'")))
  (when sound (shell-command
               (concat "mplayer -really-quiet " sound " 2> /dev/null"))))

;; the appointment notification facility
(setq
 appt-message-warning-time 10 ;; warn 10 min in advance
 appt-display-mode-line t     ;; show in the modeline
 appt-display-format 'window) ;; use our func
(appt-activate 1)              ;; active appt (appointment notification)
(display-time)                 ;; time display is required for this...
(setq appt-audible t)

;; our little façade-function for djcb-popup
(defun djcb-appt-display (min-to-app new-time msg)
  (djcb-popup (format "Appointment in %s minute(s)" min-to-app) msg 
              "/usr/share/icons/gnome/32x32/status/appointment-soon.png"
              "/usr/share/sounds/ubuntu/stereo/phone-incoming-call.ogg"))
(setq appt-disp-window-function (function djcb-appt-display))

(defun org-add-appt-after-save-hook ()
  (if ;(string= mode-name "Org")
      (member (buffer-file-name) org-agenda-files)
      (org-agenda-to-appt)))
(add-hook 'after-save-hook 'org-add-appt-after-save-hook)

 ;; update appt each time agenda opened
(add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)

(defun kiwon/merge-appt-time-msg-list (time-msg-list)
  "Merge time-msg-list's elements if they have the same time."
  (let* ((merged-time-msg-list (list)))
    (while time-msg-list
      (if (eq (car (caar time-msg-list)) (car (caar (cdr time-msg-list))))
          (setq time-msg-list
                (cons
                 (append
                  (list (car (car time-msg-list)) ; time
                        (concat (car (cdr (car time-msg-list))) " / "(car (cdr (car (cdr time-msg-list)))))) ; combined msg
                  (cdr (cdr (car time-msg-list)))) ; rest information
                 (nthcdr 2 time-msg-list)))
        (progn (add-to-list 'merged-time-msg-list (car time-msg-list) t)
               (setq time-msg-list (cdr time-msg-list)))))
    merged-time-msg-list))

(defun kiwon/org-agenda-to-appt ()
  (prog2
      (setq appt-time-msg-list nil)
      (org-agenda-to-appt)
    (setq appt-time-msg-list (kiwon/merge-appt-time-msg-list appt-time-msg-list))))

(add-hook 'org-finalize-agenda-hook (function kiwon/org-agenda-to-appt))
