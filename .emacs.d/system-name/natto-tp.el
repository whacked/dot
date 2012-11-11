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
(setq my-packages
      (append
       '(el-get package
         ;; put el-get bundled packages here
         magit color-theme deft
         muse paredit autopair
         inf-ruby js2-mode json lua-mode markdown-mode ruby-mode rspec-mode yaml-mode zencoding-mode
         iedit frame-bufs ;; nxhtml
         unbound
         windata tree-mode ;; required for dirtree
         auctex
         transpose-frame
         )
       (mapcar 'el-get-source-name el-get-sources)))
(el-get 'sync my-packages)


(dolist (path '("~/.emacs.d/revive.el"
                "~/.emacs.d/bundle/mode/haxe-mode.el"
                "~/.emacs.d/matlab.el"
                "~/.emacs.d/windows.el"
                "~/.emacs.d/bundle/mode/graphviz-dot-mode.el"
                "~/.emacs.d/perspective/perspective.el"
                "~/.emacs.d/rainbow-mode.el"
                ))
  (load-file path))

(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))

(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))

 
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
(recentf-mode 1)

(require 'frame-bufs)
(frame-bufs-mode t)

(require 'windata)
(require 'tree-mode)
(require 'dirtree)
(autoload 'dirtree "dirtree" "Add directory to tree view" t)

;; perspective mode
;; ref: http://emacsrookie.com/2011/09/25/workspaces/
(persp-mode)
(defmacro custom-persp (name &rest body)
  `(let ((initialize (not (gethash ,name perspectives-hash)))
         (current-perspective persp-curr))
     (persp-switch ,name)
     (when initialize ,@body)
     (setq persp-last current-perspective)))
(defun custom-persp/org ()
  (interactive)
  (custom-persp "@org"
                (find-file (first org-agenda-files))))

;; superceded by el-get?
;;;;;;; This was installed by package-install.el.
;;;;;;; This provides support for the package system and
;;;;;;; interfacing with ELPA, the package archive.
;;;;;;; Move this code earlier if you want to reference
;;;;;;; packages in your .emacs.
;;;;(when
;;;;    (load
;;;;     (expand-file-name "~/.emacs.d/elpa/package.el"))
;;;;  ;; Add the original Emacs Lisp Package Archive
;;;;  (add-to-list 'package-archives
;;;;               '("elpa" . "http://tromey.com/elpa/"))
;;;;  ;; Add the user-contributed repository
;;;;  (add-to-list 'package-archives
;;;;               '("marmalade" . "http://marmalade-repo.org/packages/"))
;;;;  (package-initialize))



;; prevent special buffers from messing with the current layout
;; see: http://www.gnu.org/software/emacs/manual/html_node/emacs/Special-Buffer-Frames.html
(setq special-display-buffer-names
           '("*grep*" "*tex-shell*" "*Help*" "*Packages*" "*Capture*"))
(setq special-display-function 'my-special-display-function)
;; (defun my-special-display-function (buf &optional args)
;;   (special-display-popup-frame buf))
(defun my-special-display-function (buf &optional args)
  (special-display-popup-frame buf `((height . 40)
                                     ;; (left . ,(+ 40 (frame-parameter (selected-frame) 'left)))
                                     ;; (top . ,(+ 20 (frame-parameter (selected-frame) 'top)))
                                     )))

(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")



(autopair-global-mode) ;; enable autopair in all buffers 
(add-hook 'js2-mode-hook #'(lambda () (setq autopair-dont-activate t))) ; the #'(lambda ...) form is the same as just doing (lambda ...). leaving it here just as example
;; fix autopair infinite loop in sldb
(add-hook 'sldb-mode-hook #'(lambda () (setq autopair-dont-activate t)))
(add-hook 'clojure-mode-hook #'(lambda ()
                                 (setq autopair-dont-activate t)
                                 (paredit-mode)))
;; highlight cljs with clojure-mode
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))


(load-file "~/.emacs.d/filetype/javascript.el")

(eval-after-load 'haxe-mode
  '(define-key haxe-mode-map (kbd "C-c C-c")
     (lambda () (interactive) (compile "make"))))



(setq-default truncate-lines t
              tab-width 2
              indent-tabs-mode nil
              echo-keystrokes 0.1 ;; = delay for minibuffer display after pressing function key default is 1
              )

;;; see http://www.emacswiki.org/emacs/DeskTop
;;; desktop-override-stale-locks.el begins here
(defun emacs-process-p (pid)
  "If pid is the process ID of an emacs process, return t, else nil.
Also returns nil if pid is nil."
  (when pid
    (let* ((cmdline-file (concat "/proc/" (int-to-string pid) "/cmdline")))
      (when (file-exists-p cmdline-file)
        (with-temp-buffer
          (insert-file-contents-literally cmdline-file)
          (goto-char (point-min))
          (search-forward "emacs" nil t)
          pid)))))

(defadvice desktop-owner (after pry-from-cold-dead-hands activate)
  "Don't allow dead emacsen to own the desktop file."
  (when (not (emacs-process-p ad-return-value))
    (setq ad-return-value nil)))
;;; desktop-override-stale-locks.el ends here

; add more hooks here
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(desktop-save-mode t)
 '(dirtree-windata (quote (frame left 0.15 delete)))
 '(exec-path (quote ("/opt/local/bin" "/usr/bin" "/usr/local/bin" "/usr/sbin" "/bin")))
 '(global-hl-line-mode t)
 '(hscroll-step 1)
 '(ibuffer-fontification-alist (quote ((10 buffer-read-only font-lock-constant-face) (15 (and buffer-file-name (string-match ibuffer-compressed-file-name-regexp buffer-file-name)) font-lock-doc-face) (20 (string-match "^*" (buffer-name)) font-lock-keyword-face) (25 (and (string-match "^ " (buffer-name)) (null buffer-file-name)) italic) (30 (memq major-mode ibuffer-help-buffer-modes) font-lock-comment-face) (35 (eq major-mode (quote dired-mode)) font-lock-function-name-face) (40 (string-match ".py" (buffer-name)) font-lock-type-face) (45 (string-match ".rb" (buffer-name)) font-lock-string-face) (50 (string-match ".org" (buffer-name)) font-lock-preprocessor-face))))
 '(iswitchb-mode t)
 '(line-number-mode t)
 '(matlab-auto-fill nil)
 '(menu-bar-mode nil)
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-window-setup (quote other-window))
 '(org-drill-optimal-factor-matrix (quote ((2 (2.6 . 2.6) (2.7 . 2.691)) (1 (2.6 . 4.14) (2.36 . 3.86) (2.1799999999999997 . 3.72) (1.96 . 3.58) (1.7000000000000002 . 3.44) (2.5 . 4.0)))))
 '(org-export-blocks (quote ((src org-babel-exp-src-blocks nil) (comment org-export-blocks-format-comment t) (ditaa org-export-blocks-format-ditaa nil) (dot org-export-blocks-format-dot nil))))
 '(org-file-apps (quote ((auto-mode . emacs) ("\\.mm\\'" . default) ("\\.x?html?\\'" . default) ("\\.xoj\\'" . "xournal %s") ("\\.pdf\\'" . "xournal %s"))))
 '(org-modules (quote (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-drill)))
 '(org-src-fontify-natively t)
 '(org-startup-folded (quote showeverything))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))

;; for smooth scrolling
; (setq scroll-conservatively 10000)


(when
    (functionp 'set-scroll-bar-mode)
  (set-scroll-bar-mode 'right))

(when (load "auctex.el" t t t) ;; first t = don't throw error if not exist
  (load "preview-latex.el" nil t t)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq TeX-command-master "latex")
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-save-query t))

;;;;;;;;;;;;;;;;;;;;;;;
;; <org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;
; below add-to-list not required if org-mode successfully built with =make= and =make-install=
(add-to-list 'load-path "~/.emacs.d/bundle/org-mode/lisp")
(add-to-list 'load-path "~/.emacs.d/bundle/org-mode/contrib/lisp")
(add-to-list 'load-path "~/.emacs.d/dev")
(require 'org-install)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (python . t)
   (ledger . t)
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


(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))
(when (executable-find "ipython")
  (require 'ipython)
  (setq org-babel-python-mode 'python-mode))

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
 '(("Todo" ?t "* TODO %?\nAdded: %U" "~/note/org/todos.org" "Main")
   ("CNE" ?c "* TODO %?\nAdded: %U" "~/note/cne/cne.org" "All Todo")
   ("Nikki" ?n "* %U %?\n\n %i\n %a\n\n" "~/note/org/nikki.org" "ALL")
   ;; ("State" ?s "* %U %? " "~/note/org/state.org")
   ("Scholar" ?s "* %?\nadded: %U" "~/note/org/scholar.org")
   ("Vocab" ?v "* %U %^{Word}\n%?\n# -*- xkm-export -*-\n" "~/note/org/vocab.org")
   ("Idea" ?i "* %^{Title}\n%?\n  %a\n  %U" "~/note/org/idea.org" "Main")
   ;;("Music" ?m "- %? %U\n" "~/note/org/music.org" "good")
   ("learn" ?l "omi%?" "~/note/org/learn.org" "captured")
   ("mem" ?m "** %U    :drill:\n
    :PROPERTIES:
    :DATE_ADDED: %U
    :SOURCE_URL: %a
    :END:
\n%i%?" "~/note/org/learn.org" "captured")
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
         ;; doesn't work :(
         ;; "--play" "/usr/share/sounds/KDE-Im-Sms.ogg"
         "--beep"
         (format "%s" name))))))
(add-hook 'org-remember-mode-hook '(lambda () (visual-line-mode t)))
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

(setq org-agenda-files (map 'list 'expand-file-name '("~/note/org/main.org"
                                                      "~/note/cne/cne.org"
                                                      "~/note/org/freex/index.org"
                                                      "~/note/org/todos.org")))

(require 'iimage)
;(setq iimage-mode-image-search-path (expand-file-name "~/"))
;;Match org file: links
(add-to-list 'iimage-mode-image-regex-alist
             (cons (concat "file:\\(~?[]\\[\\(\\),~+./_0-9a-zA-Z -]+\\.\\(GIF\\|JP\\(?:E?G\\)\\|P\\(?:BM\\|GM\\|N[GM]\\|PM\\)\\|SVG\\|TIFF?\\|X\\(?:[BP]M\\)\\|gif\\|jp\\(?:e?g\\)\\|p\\(?:bm\\|gm\\|n[gm]\\|pm\\)\\|svg\\|tiff?\\|x\\(?:[bp]m\\)\\)\\)")  1))
;;;;;;;;;;;;;;;;;;;;;;;;
;; </org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;;


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
  (interactive)
  (setq kill-emacs-hook nil)
  (kill-emacs))

(defalias 'wsm 'win-switch-menu)
(defalias 'visu 'visual-line-mode)

(defun surround-region-with-tag (tag-name beg end)
  (interactive "sTag name: \nr")
  (save-excursion
    (goto-char end)
    (insert "</" tag-name ">")
    (goto-char beg)
    (insert "<" tag-name ">")))

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(require 'ansi-color)

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; <OS-specific command> ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setenv "PATH" (concat "/opt:/opt/local/bin:" (getenv "PATH")))
(cond ((eq system-type 'gnu/linux)
       (load-file "~/.emacs.d/system-type/gnu-linux.el"))
      ((eq system-type 'darwin)
       (load-file "~/.emacs.d/system-type/darwin.el"))
      ((eq system-type 'windows-nt)
       (load-file "~/.emacs.d/system-type/windows-nt.el"))
      (t (message "unknown system???")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; </OS-specific command> ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(require 'transpose-frame)


(load "~/.emacs.d/bundle/haskell-mode/haskell-site-file")
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
 '(default ((t (:inherit nil :stipple nil :background "#f8f8ff" :foreground "#000000" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family (if (featurep (quote ns)) "Monaco" "Consolas")))))
 '(font-lock-keyword-face ((t (:foreground "DarkOliveGreen" :weight bold))))
 '(org-level-1 ((t (:inherit outline-1 :weight bold :height 1.6 :family "Verdana"))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.5 :family "Verdana"))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.4 :family "Verdana"))))
 '(org-level-4 ((t (:inherit outline-4 :foreground "blue" :height 1.3 :family "Verdana"))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.2 :family "Verdana"))))
 '(org-level-6 ((t (:inherit outline-6 :height 1.1 :family "Verdana"))))
 '(table-cell ((t (:background "#DD8" :foreground "gray50" :inverse-video nil))))
 '(table-cell-face ((((class color)) (:background "#AA3" :foreground "gray90")))))
;(set-cursor-color "orange")

(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-snow)
     ))
; snow's hl-line seems to be same as paren-match color
(set-face-background 'hl-line "PapayaWhip")


(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


(global-set-key "\C-x\C-b" 'ibuffer)
(setq ibuffer-expert t)
(add-hook 'ibuffer-mode-hook '(lambda () (ibuffer-auto-mode 1)))
;; (setq ibuffer-show-empty-filter-groups nil)
(load-file "~/.emacs.d/bundle/ibuffer-vc/ibuffer-vc.el")
(add-hook 'ibuffer-hook
  (lambda ()
    (ibuffer-vc-set-filter-groups-by-vc-root)
    (ibuffer-do-sort-by-alphabetic)))
;; see http://www.emacswiki.org/emacs/IbufferMode#toc3
;; Switching to ibuffer puts the cursor on the most recent buffer
(defadvice ibuffer (around ibuffer-point-to-most-recent) ()
  "Open ibuffer with cursor pointed to most recent buffer name"
  (let ((recent-buffer-name (buffer-name)))
    ad-do-it
    (ibuffer-jump-to-buffer recent-buffer-name)))
(ad-activate 'ibuffer)

;;;; see http://lispuser.net/emacs/emacstips.html
;;(defvar *original-dired-font-lock-keywords* dired-font-lock-keywords)
;;(defun dired-highlight-by-extensions (highlight-list)
;;  "highlight-list accept list of (regexp [regexp] ... face)."
;;  (let ((lst nil))
;;    (dolist (highlight highlight-list)
;;      (push `(,(concat "\\.\\(" (regexp-opt (butlast highlight)) "\\)$")
;;              (".+" (dired-move-to-filename)
;;               nil (0 ,(car (last highlight)))))
;;            lst))
;;    (setq dired-font-lock-keywords
;;          (append *original-dired-font-lock-keywords* lst))))
;;(dired-highlight-by-extensions
;;  '(("txt" font-lock-variable-name-face)
;;    ("rb" font-lock-string-face)
;;    ("org" "lisp" "el" "pl" "c" "h" "cc" font-lock-constant-face)))

;;; custom override keys
;;; ref http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs
(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")
(define-key my-keys-minor-mode-map [M-left] 'windmove-left)
(define-key my-keys-minor-mode-map [M-right] 'windmove-right)
(define-key my-keys-minor-mode-map [M-up] 'windmove-up)
(define-key my-keys-minor-mode-map [M-down] 'windmove-down)
(define-key my-keys-minor-mode-map (kbd "M-_") 'org-metaleft)
(define-key my-keys-minor-mode-map (kbd "M-+") 'org-metaright)
;;(define-key my-keys-minor-mode-map [tab] 'yas/expand-from-trigger-key)
(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)
(my-keys-minor-mode 1)
(winner-mode 1)



;; w3 should be loaded by ELPA
;NEW;(require 'w3-auto)

(add-to-list 'load-path "~/.emacs.d/bundle/undo-tree")
(require 'undo-tree)

(add-to-list 'load-path "~/.emacs.d/bundle/minimap/")
(require 'minimap)

;; thanks to http://kliketa.wordpress.com/2010/08/04/gtklook-browse-documentation-for-gtk-glib-and-gnome-inside-emacs/
;NEW;(require 'gtk-look)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium-browser")
;;(setq browse-url-browser-function
;; '(("file:.*/usr/share/doc/.*gtk.*-doc/.*" . w3m-browse-url)
;;   ("." . browse-url-firefox)))
(defun my-c-mode-hook ()
  (define-key c-mode-map (kbd "C-<return>") 'gtk-lookup-symbol)
  (message "C mode hook ran."))
(add-hook 'c-mode-hook 'my-c-mode-hook)

;;; (setq swank-clojure-binary (expand-file-name "~/.lein/bin/swank-clojure"))
;;; (setq slime-protocol-version "20100404")
;;; (setq swank-clojure-classpath (list
;;;                                (expand-file-name "~/.m2/repository/swank-clojure/swank-clojure/1.3.0-SNAPSHOT/swank-clojure-1.3.0-SNAPSHOT.jar")
;;;                                (expand-file-name "~/.m2/repository/org/clojure/clojure/1.2.0/clojure-1.2.0.jar")))
(setq slime-multiprocessing t)
(set-language-environment "UTF-8")
(setq slime-net-coding-system 'utf-8-unix)




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



; to clear shell in ESS mode
; http://stackoverflow.com/questions/3447531/emacs-ess-version-of-clear-console
(defun clear-shell ()
   (interactive)
   (let ((old-max comint-buffer-maximum-size))
     (setq comint-buffer-maximum-size 0)
     (comint-truncate-buffer)
     (setq comint-buffer-maximum-size old-max)))
(put 'set-goal-column 'disabled nil)
(put 'narrow-to-region 'disabled nil)


;; for sqlite
;; see http://mysite.verizon.net/mbcladwell/sqlite.html for technique
(defvar sql-sqlite-program "sqlite3")
(defvar sql-sqlite-process-buffer "*sqlite-process*"
  "*Name of the SQLITE process buffer.  This is where SQL commands are sent.")
(defvar sql-sqlite-output-buffer "*sqlite-output-buffer*"
  "Name of the buffer to which all SQLITE output is redirected.")

;; (apply 'make-comint "sqlite-process"  sql-sqlite-program  nil `(,sql-sqlite-db ))
;; (get-buffer-create sql-sqlite-output-buffer)
;; chomp is a utility that will remove whitespace from the results:
(defun sql-chomp (str)
  "Trim whitespace from string"
  (let ((s (if (symbolp str)(symbol-name str) str)))
    (save-excursion
      (while (and
              (not (null (string-match "^\\( \\|\f\\|\t\\|\n\\)" s)))
              (> (length s) (string-match "^\\( \\|\f\\|\t\\|\n\\)" s)))
        (setq s (replace-match "" t nil s)))
      (while (and
              (not (null (string-match "\\( \\|\f\\|\t\\|\n\\)$" s)))
              (> (length s) (string-match "\\( \\|\f\\|\t\\|\n\\)$" s)))
        (setq s (replace-match "" t nil s))))
    s))

(defun sqlite-query (sql-command &optional sqlite-process-buffer sqlite-output-buffer)
  (let* ((process-buffer (if sqlite-process-buffer sqlite-process-buffer
                           sql-sqlite-process-buffer ;; global
                           ))
         (output-buffer (if sqlite-output-buffer sqlite-output-buffer
                          sql-sqlite-output-buffer ;; global
                          )))
    (set-buffer output-buffer)      ;; Navigate to the output buffer.
    (erase-buffer)                             ;; Erase the contents of the output buffer, if any.
    (comint-redirect-send-command-to-process sql-command output-buffer (get-buffer-process process-buffer) nil)  ;; Send the sql-statement to SQLITE using the sqlite-process buffer
    (accept-process-output (get-buffer-process process-buffer) 1)  ;need to wait to obtain results
    
    (let*  ((begin (goto-char (point-min)))   ;; Switch back to the sqlite-output buffer and retrieve the results. One result row per line of the buffer. Extract each line as an element of the result list.
            (end (goto-char (point-max)))
            (num-lines (count-lines begin end))
            (counter 0)
            (results-rows ()))
      (goto-char (point-min))
      (while ( < counter num-lines)
        (setq results-rows (cons (sql-chomp (thing-at-point 'line)) results-rows))
        (forward-line)
        (setq counter (+ 1 counter)))
      (car `(,results-rows)))
    (replace-regexp-in-string "$" "|" (replace-regexp-in-string "^" "|" (buffer-string)))))

;; pymacs see http://pymacs.progiciels-bpi.ca/pymacs.html#installation
;; (load-file "~/.emacs.d/bundle/pymacs/pymacs.el")
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;;;; ledger
;; (load "ledger")

;;;; freex mode
;;
;;(setq pymacs-load-path '("~/dev/elisp/org-freex"))
;;(add-to-list 'load-path (expand-file-name "~/dev/elisp/org-freex/"))
;;(load-file "~/dev/elisp/org-freex/freex-conf.el")
;;;;;;(load-file "~/dev/elisp/org-freex/freex-mode.el")
;;;;(require 'freex-mode)


 



;; ;; google calendar interaction
;; ;; see http://article.gmane.org/gmane.emacs.orgmode/27214
;; (defadvice org-agenda-add-entry-to-org-agenda-diary-file 
;;   (after add-to-google-calendar)
;;   "Add a new Google calendar entry that mirrors the diary entry just created by org-mode."
;;   (let ((type (ad-get-arg 0))
;; 	(text (ad-get-arg 1))
;; 	(d1 (ad-get-arg 2))
;; 	(year1 (nth 2 d1))
;; 	(month1 (car d1))
;; 	(day1 (nth 1 d1))
;; 	(d2 (ad-get-arg 3))
;; 	entry dates)
;;     (if (or (not (eq type 'block)) (not d2))
;; 	(setq dates (format "%d-%02d-%02d" year1 month1 day1))
;;       (let ((year2 (nth 2 d2)) (month2 (car d2)) (day2 (nth 1 d2)) (repeats (-
;; (calendar-absolute-from-gregorian d1)
;; 									       (calendar-absolute-from-gregorian d2))))
;; 	(if (> repeats 0)
;; 	    (setq dates (format "%d-%02d-%02d every day for %d days" year1 month1 day1 (abs repeats)))
;; 	  (setq dates (format "%d-%02d-%02d every day for %d days" year1 month1 day1 (abs repeats))))
;; 	))
;;     (setq entry  (format "/usr/local/bin/google calendar add --cal org \"%s on %s\"" text dates))
;;     ;;(message entry)
;;     (if (not (string= "MYLAPTOPCOMPUTER" mail-host-address))
;; 	(shell-command entry)
;;       (let ((offline "~/note/org/org2google-buffer"))
;; 	(find-file offline)
;; 	(goto-char (point-max))
;; 	(insert (concat entry "\n"))
;; 	(save-buffer)
;; 	(kill-buffer (current-buffer))
;; 	(message "Plain text written to %s" offline)))))
;; (ad-activate 'org-agenda-add-entry-to-org-agenda-diary-file)



;; in case useful: http://jblevins.org/projects/deft/
;; Deft is an Emacs mode for quickly browsing, filtering, and editing directories of plain text notes, inspired by Notational Velocity.
(setq deft-extension "org")
(setq deft-directory "~/note/org/")
(setq deft-text-mode 'org-mode)




;; eliminate strange error with this for now
(defvar warning-suppress-types nil)



(defadvice balance-windows (around allow-interactive-prefix
                                   (&optional selected-window-only))
  "modify balance-windows so that if given C-u prefix, apply only to (selected-window)"
  (interactive "P")
  (when selected-window-only
    (ad-set-arg 0 (selected-window)))
  ad-do-it)
(ad-activate 'balance-windows)


(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)
