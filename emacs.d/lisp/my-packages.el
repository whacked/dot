;;; my-packages.el --- Miscellaneous package configuration -*- lexical-binding: t -*-
;;
;; Packages with enough config to warrant inline setup but not their own
;; module. Larger subsystems (completion, org) have dedicated modules.

;;; ibuffer

(setq ibuffer-fontification-alist
      '((10 buffer-read-only font-lock-constant-face)
        (15 (and buffer-file-name
                 (string-match ibuffer-compressed-file-name-regexp
                               buffer-file-name))
            font-lock-doc-face)
        (20 (string-match "^*" (buffer-name)) font-lock-keyword-face)
        (25 (and (string-match "^ " (buffer-name))
                 (null buffer-file-name))
            italic)
        (30 (memq major-mode ibuffer-help-buffer-modes)
            font-lock-comment-face)
        (35 (eq major-mode 'dired-mode) font-lock-function-name-face)
        (40 (string-match ".py" (buffer-name)) font-lock-type-face)
        (45 (string-match ".rb" (buffer-name)) font-lock-string-face)
        (50 (string-match ".org" (buffer-name)) font-lock-preprocessor-face)))

;;; ibuffer — behaviour and grouping
;;
;; ibuffer-fontification-alist is set above.

(setq ibuffer-expert t)

(add-hook 'ibuffer-mode-hook (lambda () (ibuffer-auto-mode 1)))

;; Group buffers by VC root and sort alphabetically on entry.
(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (ibuffer-do-sort-by-alphabetic)))

;; Open ibuffer with point on the most recently visited buffer.
(advice-add 'ibuffer :around
  (lambda (orig &rest args)
    "Open ibuffer with cursor on the most recently visited buffer."
    (let ((recent-buffer-name (buffer-name)))
      (apply orig args)
      (ibuffer-jump-to-buffer recent-buffer-name))))

;;; Tree-sitter grammar path
;;
;; Base dir comes from $TREESIT_GRAMMAR_DIR (set in shell profile / nix env).
;; Grammars live in <base>/abi<N>/ where N = (treesit-library-abi-version).
;; Two Emacs builds linked against different tree-sitter ABIs each get their
;; own subdirectory — no clobber.  The base dir must exist; Emacs creates
;; only the abi-versioned subdirectory inside it.
(when (fboundp 'treesit-library-abi-version)
  (let ((base (getenv "TREESIT_GRAMMAR_DIR")))
    (cond
     ((not base)
      (display-warning 'treesit
                       "TREESIT_GRAMMAR_DIR is not set — tree-sitter grammars disabled"
                       :warning))
     ((not (file-directory-p base))
      (display-warning 'treesit
                       (format "TREESIT_GRAMMAR_DIR=%s does not exist — tree-sitter grammars disabled" base)
                       :warning))
     (t
      (let ((grammar-dir (expand-file-name
                          (format "abi%d" (treesit-library-abi-version))
                          base)))
        (make-directory grammar-dir t)
        ;; setq, not add-to-list: treesit-install-language-grammar writes to
        ;; (car treesit-extra-load-path), so it must be our versioned dir.
        (setq treesit-extra-load-path (list grammar-dir)))
      (use-package treesit-auto
        :custom
        (treesit-auto-install 'prompt)
        :config
        (global-treesit-auto-mode))))))

;;; eat — terminal emulator (used by claude-code-ide and general shell work)

(use-package eat
  :straight (:type git
             :host codeberg
             :repo "akib/emacs-eat"
             :files ("*.el" ("term" "term/*.el") "*.texi"
                     "*.ti" ("terminfo/e" "terminfo/e/*")
                     ("terminfo/65" "terminfo/65/*")
                     ("integration" "integration/*")
                     (:exclude ".dir-locals.el" "*-tests.el"))))

;;; markdown-mode

(use-package markdown-mode
  :defer t ; Load the package only when you need it
  :mode (("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)) ; Auto-load for .md and .markdown files
  :custom
  (markdown-hide-markup nil) ; Hides the raw markup for things like **bold** and *italics*, showing just the formatted text.
  (markdown-xml-tag-font-lock t) ; Improves font-locking for embedded HTML/XML.
  :config
  ;; Customizing Faces for better visual hierarchy
  ;; Headings: Make them stand out more.
  (custom-set-faces
   ;; Level 1 Heading: Large and bold.
   '(markdown-header-face-1
     ((t (:inherit markdown-header-face :height 1.5 :weight bold :foreground "MidnightBlue"))))
   ;; Level 2 Heading: Slightly smaller and bold.
   '(markdown-header-face-2
     ((t (:inherit markdown-header-face :height 1.3 :weight bold :foreground "DarkGreen"))))
   ;; Level 3 Heading: Standard size, bold, and distinct color.
   '(markdown-header-face-3
     ((t (:inherit markdown-header-face :weight bold :foreground "Firebrick"))))
   ;; Links: Make the link text more noticeable.
   '(markdown-link-face
     ((t (:foreground "blue" :underline t))))
   ;; Inline Code: Give it a different background to separate it from regular text.
   '(markdown-inline-code-face
     ((t (:background "#EFEFEF" :foreground "#8B008B"
          :box (:line-width 1 :style released-button)))))
   ;; Block Code (Fenced Code Blocks): Use a distinct background color.
   '(markdown-code-face
     ((t (:background "#F5F5F5" :foreground "#333333"))))
   ;; Blockquotes: Add a border or distinct color for quotes.
   '(markdown-blockquote-face
     ((t (:foreground "DarkSlateGray" :slant italic :background "#F7F7F7")))))
  (add-hook 'markdown-mode-hook (lambda () (setq tab-width 2))))

;;; win-switch — repeated other-window via C-x o o o ...

(use-package win-switch
  :bind ("C-x o" . win-switch-dispatch)
  :custom (win-switch-idle-time 0.3))

;;; magit

(use-package magit)

;;; git-gutter — diff indicators in the fringe

(use-package git-gutter
  :config
  (global-git-gutter-mode t)
  (set-face-background 'git-gutter:modified "purple")
  (set-face-foreground 'git-gutter:added "green")
  (set-face-foreground 'git-gutter:deleted "red")
  (set-face-background 'git-gutter:unchanged "gray")
  (setq git-gutter:unchanged-sign " "))

;;; ov — overlay library (used by my-highlight-duplicate-lines-in-region etc.)

(use-package ov)

;;; expand-region

(use-package expand-region
  :bind ("C-=" . er/expand-region))

;;; paredit — structural editing for Lisp modes
;; http://inclojurewetrust.blogspot.com/2013/01/duplicating-s-expressions-on-line.html

(use-package paredit
  :hook ((emacs-lisp-mode       . enable-paredit-mode)
         (lisp-mode             . enable-paredit-mode)
         (lisp-interaction-mode . enable-paredit-mode)
         (hy-mode               . enable-paredit-mode)
         (cider-repl-mode       . enable-paredit-mode)
         (clojure-mode          . enable-paredit-mode)
         (clojurescript-mode    . enable-paredit-mode))
  :bind (:map paredit-mode-map
              ("C-S-d" . paredit-duplicate-after-point))
  :config
  (defun paredit-duplicate-after-point ()
    "Duplicate the sexp after point onto the next line."
    (interactive)
    ;; skips to the next sexp
    (while (looking-at " ") (forward-char))
    (set-mark-command nil)
    ;; while we find sexps we move forward on the line
    (while (and (<= (point) (car (bounds-of-thing-at-point 'sexp)))
                (not (= (point) (line-end-position))))
      (forward-sexp)
      (while (looking-at " ") (forward-char)))
    (kill-ring-save (mark) (point))
    ;; go to the next line and copy the sexprs we encountered
    (paredit-newline)
    (set-mark-command nil)
    (yank)
    (exchange-point-and-mark)))

;;; Lisp / Clojure packages
(use-package clojure-mode)
(use-package cider)
(use-package hy-mode)

(use-package clojure-utils
  :ensure t
  :straight (:host github :repo "plexus/emacs-clojure-utils")
  :after clojure-mode)

;;; thingatpt+ and thing-cmds — enhanced thing-at-point operations

(use-package thingatpt+
  :straight (:host github
                   :repo "emacsmirror/thingatpt-plus"
                   :files ("thingatpt+.el"))
  :defer t)

(use-package thing-cmds
  :straight (:host github
                   :repo "emacsmirror/thing-cmds"
                   :files ("thing-cmds.el"))
  :after thingatpt+
  :defer t)

;; (use-package clj-refactor)
;; (use-package inf-clojure)
;; (use-package sibilant-mode) ; barely used

;;; obsidian.el — Obsidian vault interop
;; TODO: reevaluate whether necessary
(use-package obsidian
  :demand t
  :custom
  ;; This directory will be used for `obsidian-capture' if set.
  (obsidian-directory my-cloudsync-note-dir)
  (obsidian-inbox-directory "pages")
  :config
  ;; Skip metadata extraction for files with no front matter, or whose
  ;; front matter exceeds 50 lines.  Files without a leading "---" block
  ;; rarely carry useful obsidian metadata, and the body-tag regex can
  ;; catastrophically backtrack on unusual content in large files.
  (advice-add 'obsidian-file-metadata :around
    (lambda (orig &optional file)
      (let* ((m (make-hash-table :test 'equal))
             (empty (progn (puthash 'tags nil m)
                           (puthash 'aliases nil m)
                           (puthash 'links nil m)
                           m))
             (target (or file (buffer-file-name)))
             (head (when (and target (file-exists-p target))
                     (with-temp-buffer
                       (insert-file-contents target nil 0 4096)
                       (buffer-string)))))
        (if (and head (s-starts-with-p "---" head))
            (let* ((split (s-split-up-to "---" head 2))
                   (fm (and (= (length split) 3) (nth 1 split))))
              (if (and fm (< (length (s-split "\n" fm)) 50))
                  (funcall orig file)
                empty))
          empty))))
  ;; Defer vault scan to idle time.  obsidian-rescan-cache reads every .md
  ;; file synchronously and the cache is in-memory only (always empty on
  ;; startup), so without deferral it blocks init on every launch.
  ;; Call M-x my-obsidian-activate manually if you need obsidian before
  ;; the timer fires.
  (defun my-obsidian-activate ()
    "Activate obsidian and scan vault.
Called automatically after 10 min idle; invoke manually via M-x if needed sooner."
    (interactive)
    (global-obsidian-mode t))
  (run-with-idle-timer 600 nil #'my-obsidian-activate)
  :bind (:map obsidian-mode-map
              ;; Replace C-c C-o with Obsidian.el's implementation. It's ok to use another key binding.
              ("C-c C-o" . obsidian-follow-link-at-point)
              ;; Jump to backlinks
              ("C-c C-b" . obsidian-backlink-jump)
              ;; If you prefer you can use `obsidian-insert-link'
              ("C-c C-l" . obsidian-insert-wikilink)))

;;; claude-code-ide
;;
;; Requires node on PATH.  exec-path-from-shell (in my-core.el) imports PATH
;; from the shell — ensure node/npm are in your shell profile.
;; eat (above) is the terminal backend.

(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  ;; :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  ;; for mac compat
  (setq claude-code-ide-terminal-backend 'eat)
  (claude-code-ide-emacs-tools-setup))

(provide 'my-packages)
;;; my-packages.el ends here
