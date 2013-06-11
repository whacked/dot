(el-get 'sync my-packages)

(dolist (path '("~/dot/.emacs.d/revive.el"
                "~/dot/.emacs.d/windows.el"
                "~/dot/.emacs.d/bundle/mode/haxe-mode.el"
                "~/dot/.emacs.d/bundle/mode/matlab.el"
                ))
  (load-file path))

(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))

(setq backup-directory-alist '(("" . "~/dot/.emacs.d/emacs-backup")))

 
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

;; ;; perspective mode
;; ;; ref: http://emacsrookie.com/2011/09/25/workspaces/
;; (persp-mode)
;; (defmacro custom-persp (name &rest body)
;;   `(let ((initialize (not (gethash ,name perspectives-hash)))
;;          (current-perspective persp-curr))
;;      (persp-switch ,name)
;;      (when initialize ,@body)
;;      (setq persp-last current-perspective)))
;; (defun custom-persp/org ()
;;   (interactive)
;;   (custom-persp "@org"
;;                 (find-file (first org-agenda-files))))


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
(setq default-frame-alist
      '((top . 0) (left . 0)
        (width . 84) (height . 60)))

;; new behavior in emacs 24?
;; http://superuser.com/questions/397806/emacs-modify-quit-window-to-delete-buffer-not-just-bury-it
(defadvice quit-window (before quit-window-always-kill)
  "When running `quit-window', always kill the buffer."
  (ad-set-arg 0 t))
(ad-activate 'quit-window)

(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t)
(setq dabbrev-abbrev-char-regexp "\\sw\\|\\s_")



;; autopair mode
;; (autopair-global-mode) ;; enable autopair in all buffers 
;; (add-hook 'js2-mode-hook #'(lambda () (setq autopair-dont-activate t))) ; the #'(lambda ...) form is the same as just doing (lambda ...). leaving it here just as example
;; ;; fix autopair infinite loop in sldb
;; (add-hook 'sldb-mode-hook #'(lambda () (setq autopair-dont-activate t)))
;; (add-hook 'clojure-mode-hook #'(lambda ()
;;                                  (setq autopair-dont-activate t)
;;                                  (paredit-mode)))


;; highlight cljs with clojure-mode
(add-to-list 'auto-mode-alist '("\.cljs$" . clojure-mode))


(load-file "~/dot/.emacs.d/filetype/javascript.el")

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
 ;; '(org-export-blocks (quote ((src org-babel-exp-src-blocks nil) (comment org-export-blocks-format-comment t) (ditaa org-export-blocks-format-ditaa nil) (dot org-export-blocks-format-dot nil))))
 '(org-file-apps (quote ((auto-mode . emacs) ("\\.mm\\'" . default) ("\\.x?html?\\'" . default) ("\\.xoj\\'" . "xournal %s") ("\\.pdf\\'" . "xournal %s"))))
 '(org-modules (quote (org-bbdb org-bibtex org-gnus org-info org-jsinfo org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m org-drill)))
 '(org-src-fontify-natively t)
 '(org-startup-folded (quote showeverything))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))

;; for smooth scrolling
; (setq scroll-conservatively 10000)


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
;;(add-to-list 'load-path "~/dot/.emacs.d/bundle/org-mode/lisp")
;;(add-to-list 'load-path "~/dot/.emacs.d/bundle/org-mode/contrib/lisp")
(add-to-list 'load-path "~/dot/.emacs.d/dev")
(require 'org)
;; force org-babel src edit to use same window instead of splitting
(setq org-src-window-setup 'current-window)
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
;; don't make python-mode launch a shell everytime a .py file is
;; loaded
(setq py-start-run-py-shell nil)
;; (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;; (add-to-list 'interpreter-mode-alist '("python" . python-mode))
;; (when (executable-find "ipython")
;;   (require 'ipython)
;;   (setq org-babel-python-mode 'python-mode))

(setq org-ditaa-jar-path "~/dot/.emacs.d/bundle/org-mode/contrib/scripts/ditaa.jar")

(defun ansi-unansify (beg end)
  "to help fix ansi- control sequences in babel-sh output"
  (interactive (list (point) (mark)))
  (unless (and beg end)
    (error "The mark is not set now, so there is no region"))
  (insert (ansi-color-filter-apply (filter-buffer-substring beg end t))))

(setq org-log-done t)



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

(require 'transpose-frame)


(load "~/dot/.emacs.d/bundle/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)


;(add-to-list 'load-path "~/dot/.emacs.d/bundle/icicles")
;(require 'icicles)



; (set-default-font "Consolas 10")
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 ;; '(default ((t (:inherit nil :stipple nil :background "#f8f8ff" :foreground "#000000" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "unknown" :family (if (featurep (quote ns)) "Monaco" "Consolas")))))
 '(org-level-1 ((t (:inherit outline-1 :inverse-video t :weight bold :height 1.6 :family "Verdana"))))
 '(org-level-2 ((t (:inherit outline-2 :inverse-video t :weight bold :height 1.5 :family "Verdana"))))
 '(org-level-3 ((t (:inherit outline-3 :inverse-video t :weight bold :height 1.4 :family "Verdana"))))
 '(org-level-4 ((t (:inherit outline-4 :inverse-video t :weight bold :height 1.3 :family "Verdana"))))
 '(org-level-5 ((t (:inherit outline-5 :inverse-video t :weight bold :height 1.2 :family "Verdana"))))
 '(org-level-6 ((t (:inherit outline-6 :inverse-video t :weight bold :height 1.1 :family "Verdana"))))
 '(table-cell ((t (:background "#DD8" :foreground "gray50" :inverse-video nil))))
 '(table-cell-face ((((class color)) (:background "#AA3" :foreground "gray90"))))
 )

;(set-cursor-color "orange")

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


(global-set-key "\C-x\C-b" 'ibuffer)
(setq ibuffer-expert t)
(add-hook 'ibuffer-mode-hook '(lambda () (ibuffer-auto-mode 1)))
;; (setq ibuffer-show-empty-filter-groups nil)
(load-file "~/dot/.emacs.d/bundle/ibuffer-vc/ibuffer-vc.el")
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

(add-to-list 'load-path "~/dot/.emacs.d/bundle/undo-tree")
(require 'undo-tree)

(add-to-list 'load-path "~/dot/.emacs.d/bundle/minimap/")
(require 'minimap)


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


(load-file "~/dot/.emacs.d/dev/sqlite.el")




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

;; not playing nice with daemon
(when nil
  (if (display-graphic-p)
      (color-theme-solarized-light)
    (color-theme-solarized-dark)))
