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

;;; ibuffer -- behaviour and grouping
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
;; own subdirectory -- no clobber.  The base dir must exist; Emacs creates
;; only the abi-versioned subdirectory inside it.
(when (fboundp 'treesit-library-abi-version)
  (let ((base (getenv "TREESIT_GRAMMAR_DIR")))
    (cond
     ((not base)
      (display-warning 'treesit
                       "TREESIT_GRAMMAR_DIR is not set -- tree-sitter grammars disabled"
                       :warning))
     ((not (file-directory-p base))
      (display-warning 'treesit
                       (format "TREESIT_GRAMMAR_DIR=%s does not exist -- tree-sitter grammars disabled" base)
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

;;; eval-in-repl -- send current line/region to a running REPL
;;
;; Handles two shell use cases:
;;   1. sh-mode file with an active *shell* buffer -- C-<return> sends current line
;;   2. org src block opened with C-' -- same binding works in the edit buffer
;;
;; The target shell is M-x shell (comint), not vterm/eat.
;; eir-eval-in-shell2 is a variant that toggles the jump-after-eval behaviour.

(use-package eval-in-repl
  :config
  (require 'eval-in-repl-shell)
  (defun eir-eval-in-shell2 ()
    "Send current line/region to shell, with opposite jump-after-eval behaviour."
    (interactive)
    (let ((eir-jump-after-eval (not eir-jump-after-eval)))
      (eir-eval-in-shell)))
  (add-hook 'sh-mode-hook
            (lambda ()
              (local-set-key (kbd "C-<return>") #'eir-eval-in-shell))))

;;; eat -- terminal emulator (used by claude-code-ide and general shell work)

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

;;; ace-window -- switch window by visual label
;; Coexists with win-switch (C-x o); use M-o for ace-window.

(use-package ace-window
  :bind ("M-o" . ace-window))

;;; win-switch -- repeated other-window via C-x o o o ...

(use-package win-switch
  :bind ("C-x o" . win-switch-dispatch)
  :custom (win-switch-idle-time 0.3))

;;; magit

(use-package magit)

;;; diff-hl -- diff indicators in the fringe (replaces git-gutter)
;;
;; diff-hl uses Emacs's built-in VC framework so it works with any VCS,
;; not just git.  Colours ported from the old git-gutter config:
;; modified=purple, added=green, deleted=red.  git-gutter used
;; :foreground for added/deleted; diff-hl uses :background -- spirit
;; is the same.

(use-package diff-hl
  :config
  (set-face-background 'diff-hl-change "purple")
  (set-face-background 'diff-hl-insert "green")
  (set-face-background 'diff-hl-delete "red")
  (global-diff-hl-mode))

;;; ov -- overlay library (used by my-highlight-duplicate-lines-in-region etc.)

(use-package ov)

;;; expand-region

(use-package expand-region
  :bind ("C-=" . er/expand-region))

;;; paredit -- structural editing for Lisp modes
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

;;; thingatpt+ and thing-cmds -- enhanced thing-at-point operations

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

;;; obsidian.el -- Obsidian vault interop
(use-package obsidian
  ;; :demand t removed -- use :commands so neither the package code nor the vault
  ;; scan block startup.  The package loads on first command invocation or when
  ;; the idle timer fires (whichever comes first).
  ;; :demand t
  :commands (my-obsidian-activate
             obsidian-follow-link-at-point
             obsidian-backlink-jump
             obsidian-capture
             obsidian-insert-wikilink
             obsidian-jump)
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

;;; csv-mode

(use-package csv-mode
  :defer t)

;;; dirvish -- modern dired replacement (supersedes dired+)

(setq dired-listing-switches "--time-style=full -alGgh1v")

(use-package all-the-icons  ;; used by dired/dirvish
  :ensure t
  :if (display-graphic-p))

(use-package dirvish
  :config
  (dirvish-override-dired-mode)
  (setq dirvish-attributes '(vc-state subtree-state all-the-icons collapse file-size)))

;;; dumb-jump -- zero-config xref backend (grep-based M-. fallback)

(use-package dumb-jump
  :config (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;;; git-timemachine -- walk file git history interactively
;; Note: upstream moved to https://codeberg.org/pidu/git-timemachine

(use-package git-timemachine
  :straight (:host codeberg :repo "pidu/git-timemachine")
  :defer t)

;;; polymode -- multiple major modes in one buffer

(use-package polymode
  :defer t)

;;; transpose-frame -- flip/rotate window layout

(use-package transpose-frame)

;;; treemacs -- file tree sidebar

(use-package treemacs
  :defer t)

;;; try -- install and try packages without keeping them

(use-package try
  :defer t)

;;; vundo -- visual undo tree (replaces undo-tree)
;;
;; undo-tree had persistent data-loss/corruption bugs and is effectively
;; unmaintained.  vundo is the community-endorsed replacement: it wraps
;; Emacs' native undo machinery (non-invasive, no data-loss risk) and
;; displays the tree horizontally.
;;
;; my-vundo is a transition helper: call it where you used to call
;; undo-tree-visualize.  It prints a loud reminder of vundo's key bindings
;; so you can build new muscle memory, then opens the vundo buffer.

(use-package vundo
  :config
  (defun my-vundo ()
    "Open vundo (replaces undo-tree-visualize).
Prints key bindings as a reminder during transition from undo-tree."
    (interactive)
    (message "VUNDO  navigate: C-f/C-b  change branch: C-n/C-p  quit: q  (was undo-tree-visualize)")
    (vundo))
  :bind ("C-x u" . my-vundo))

;;; Old collection packages ─────────────────────────────────────────────────

;;; calfw / calfw-org -- calendar grid view (low priority; commented out)
;; (use-package calfw)
;; (use-package calfw-org)

;;; dash -- list manipulation library (dep; no user config needed)
(use-package dash)

;;; deadgrep -- ripgrep results buffer (distinct UX from consult-ripgrep)
(use-package deadgrep
  :defer t)

;;; duplicate-thing -- duplicate line or region in-place
(use-package duplicate-thing)

;;; editorconfig -- apply .editorconfig indent/format settings per project
(use-package editorconfig
  :config (editorconfig-mode 1))

;;; embark + embark-consult -- contextual actions on candidates / things at point
(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;;; gptel -- LLM client (OpenAI, Anthropic, Ollama, …)
(use-package gptel
  :defer t)

;;; hl-todo -- highlight TODO/FIXME/BUG/HACK in comments (replaces fic-mode)
(use-package hl-todo
  :config (global-hl-todo-mode))

;;; html-to-hiccup -- convert HTML to Hiccup syntax (Clojure/ClojureScript)
(use-package html-to-hiccup
  :defer t)

;;; htmlize -- buffer→HTML conversion; required for org HTML export syntax highlighting
(use-package htmlize
  :defer t)

;;; ibuffer-vc -- group ibuffer list by VC repository (hooks set above in ibuffer section)
(use-package ibuffer-vc)

;;; iedit -- simultaneously edit multiple occurrences of symbol/region
(use-package iedit
  :defer t)

;;; jsonnet-mode
(use-package jsonnet-mode
  :defer t)

;;; jsonl -- JSON Lines format support (pairs with custom jsonl-record-editor in my-utils.el)
(use-package jsonl
  :defer t)

;;; jupyter -- org-babel + Jupyter kernel integration
(use-package jupyter
  :defer t)

;;; keycast -- display current command and keybinding in mode line (screencasts)
(use-package keycast
  :defer t)

;;; logview -- log file (log4j, syslog, …) colorization and filtering
(use-package logview
  :defer t)

;;; mermaid-mode (commented out -- uncomment if actively using Mermaid diagrams)
;; (use-package mermaid-mode :defer t)

;;; multiple-cursors -- edit multiple points simultaneously
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->"         . mc/mark-next-like-this)
         ("C-<"         . mc/mark-previous-like-this)
         ("C-c C-<"     . mc/mark-all-like-this)))

;;; nix-mode -- edit Nix expressions
(use-package nix-mode
  :mode "\\.nix\\'")

;;; nov.el -- epub reader (replaces ereader, which is stale)
(use-package nov
  :mode ("\\.epub\\'" . nov-mode))

;;; org-download -- drag/drop or yank images directly into org buffers
(use-package org-download
  :defer t)

;;; org-ql -- query language for org headings; org-sidebar is its UI companion
(use-package org-ql
  :defer t)

(use-package org-sidebar
  :defer t)

;;; projectile -- project management (alternative to built-in project.el)
;; project.el + consult is the long-term migration path, but projectile
;; retains more commands.  Bound under C-c p.
(use-package projectile
  :config (projectile-mode +1)
  :bind-keymap ("C-c p" . projectile-command-map))

;;; request -- HTTP client library
(use-package request
  :defer t)

;; required by jupyter-widget-client
(use-package simple-httpd :defer t)
;; skewer-mode -- JS live REPL (commented out; low active use)
;; (use-package skewer-mode  :defer t)

;;; slime -- Common Lisp development environment
(use-package slime
  :defer t)

;;; solarized-theme
(use-package solarized-theme
  :defer t)

;;; string-inflection -- cycle snake_case → UPCASE → CamelCase → camelCase → kebab-case
(use-package string-inflection
  :defer t)

;;; terraform-mode -- HCL/Terraform editing
(use-package terraform-mode
  :defer t)

;;; vterm -- full terminal emulator (libvterm-backed)
;;
;; On macOS with Emacs.app from nixpkgs: straight.el will try to compile
;; vterm-module.so via cmake at install time, but it cannot find the
;; libvterm that Emacs was built against, causing the build to fail.
;;
;; Clean fix with home.nix: install vterm via the nix emacs overlay so
;; the module is pre-built in the nix store, then change :straight to nil:
;;   (use-package vterm :straight nil :defer t)
;; and add the package to your home.nix emacs package list instead.
(use-package vterm
  :defer t)

;;; websocket -- WebSocket library (dep of jupyter, lsp-mode, etc.)
(use-package websocket
  :defer t)

;;; yasnippet -- template / snippet expansion system
(use-package yasnippet
  :config (yas-global-mode 1))

;;; ─────────────────────────────────────────────────────────────────────────

;;; claude-code-ide
;;
;; Requires node on PATH.  exec-path-from-shell (in my-core.el) imports PATH
;; from the shell -- ensure node/npm are in your shell profile.
;; eat (above) is the terminal backend.

(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  ;; :bind ("C-c C-'" . claude-code-ide-menu) ; Set your favorite keybinding
  :config
  ;; for mac compat
  (setq claude-code-ide-terminal-backend 'eat)
  (claude-code-ide-emacs-tools-setup))

;;; emacs-markdown-babel -- evaluate fenced code blocks in Markdown via org-babel
;;
;; Provides markdown-eval-current-code-block (f5 in markdown-mode).
;; Previously loaded via load-file from CLOUDSYNC; now sourced from GitHub.
(use-package emacs-markdown-babel
  :straight (:host github :repo "whacked/emacs-markdown-babel")
  :after markdown-mode
  :bind (:map markdown-mode-map ([f5] . markdown-eval-current-code-block)))

;;; mustache -- Mustache template rendering (dep of zotero-query via yesql)
(use-package mustache
  :defer t)

;;; esqlite -- SQLite interface (dep of zotero-query)
(use-package esqlite
  :defer t)

;;; hydra -- transient keybinding menus (dep of zotero-query)
(use-package hydra
  :defer t)

;;; zotero-query -- open Zotero items by key from Emacs
;;
;; Provides zotero-query, used by zotero-open-at-point in my-utils.el.
(use-package zotero-query
  :straight (:host github :repo "whacked/zotero-query.el"
             :files ("*.el" "external" "resources"))
  :init
  ;; zotero-query calls `first` which was removed from dash 2.18+.
  ;; Shim it via cl-lib without loading the deprecated cl package.
  (unless (fboundp 'first)
    (defalias 'first #'cl-first))
  :commands (zotero-query))

;;; ─── Language / syntax modes ─────────────────────────────────────────────────

;;; ess -- Emacs Speaks Statistics (R, Julia, SAS, etc.)
(use-package ess
  :defer t)

;;; graphviz-dot-mode -- .dot / .gv file syntax and preview
(use-package graphviz-dot-mode
  :defer t)

;;; haskell-mode -- Haskell editing and documentation
(use-package haskell-mode
  :defer t
  :hook ((haskell-mode . turn-on-haskell-doc-mode)
         (haskell-mode . turn-on-haskell-indentation)))

;;; haxe-mode -- Haxe language support
(use-package haxe-mode
  :defer t
  :bind (:map haxe-mode-map ("C-c C-c" . (lambda () (interactive) (compile "make")))))

;;; lua-mode -- Lua editing support
(use-package lua-mode
  :defer t)

;;; octave / MATLAB -- .m file editing
;;
;; Emacs ships octave-mode for .m files.  This auto-mode entry activates it.
;; If you use MATLAB (not Octave), comment this out and use matlab-mode instead:
;;   (use-package matlab-mode :defer t)
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))

;;; pyvenv -- Python virtualenv activation inside Emacs
;;
;; M-x pyvenv-activate: point Emacs at a virtualenv directory.
;; M-x pyvenv-workon: activate a virtualenvwrapper env by name.
;; Ensures python-mode, LSP, jupyter etc. use the right interpreter.
(use-package pyvenv
  :defer t)

;;; rainbow-mode -- colourize CSS colour strings in-buffer (#rrggbb, rgba(), etc.)
(use-package rainbow-mode
  :defer t)

;;; ─── Org-babel extensions ────────────────────────────────────────────────────

;;; ob-async -- run org-babel blocks asynchronously  (:async t header arg)
;;
;; Prevents Emacs from freezing while a slow code block (shell, Python, etc.)
;; executes.  Add :async t to any #+begin_src block to use it.
(use-package ob-async
  :defer t)

;;; ─── PDF ─────────────────────────────────────────────────────────────────────

;;; pdf-tools -- rich in-buffer PDF viewer (commented: needs epdfinfo binary)
;;
;; On macOS + nix the cleanest install is to let nix own the binary:
;;   1. Add pkgs.emacsPackages.pdf-tools to home.packages in home.nix.
;;   2. Find the elisp in the nix profile:
;;        ls ~/.nix-profile/share/emacs/site-lisp/
;;   3. Add that path to load-path and use :straight nil below.
;;
;; (use-package pdf-tools
;;   :straight nil
;;   :bind (:map pdf-view-mode-map ("h" . pdf-annot-add-highlight-markup-annotation))
;;   :config
;;   (pdf-tools-install :no-query)
;;
;;   ;; Fix: correct edge→region conversion for multi-line annotation highlights.
;;   ;; (from https://github.com/pinguim06/pdf-tools/commit/22629c7)
;;   (defun pdf-annot-edges-to-region (edges)
;;     "Get 4-entry region (LEFT TOP RIGHT BOTTOM) from annotation edge list."
;;     (let ((left0   (nth 0 (car edges)))
;;           (top0    (nth 1 (car edges)))
;;           (bottom0 (nth 3 (car edges)))
;;           (top1    (nth 1 (car (last edges))))
;;           (right1  (nth 2 (car (last edges))))
;;           (bottom1 (nth 3 (car (last edges)))))
;;       (list left0
;;             (+ top0    (/ (- bottom0 top0)    2))
;;             right1
;;             (- bottom1 (/ (- bottom1 top1) 2)))))
;;
;;   ;; Extract highlight annotations from a PDF as an org heading.
;;   ;; Usage: M-x pdf-annot-markups-as-org-text, then paste the result.
;;   (defun pdf-annot-markups-as-org-text (pdfpath &optional title level)
;;     "Return highlight annotations from PDFPATH as an org heading string."
;;     (interactive "fPath to PDF: ")
;;     (let* ((title      (or title (replace-regexp-in-string "-" " " (file-name-base pdfpath))))
;;            (level      (or level (1+ (org-current-level))))
;;            (levelstr   (make-string level ?*))
;;            (annots     (sort (pdf-info-getannots nil pdfpath)
;;                              #'pdf-annot-compare-annotations))
;;            (output     (concat levelstr " Quotes From " title "\n\n")))
;;       (mapc
;;        (lambda (annot)
;;          (when (eq 'highlight (assoc-default 'type annot))
;;            (let* ((page       (assoc-default 'page annot))
;;                   (real-edges (pdf-annot-edges-to-region
;;                                (pdf-annot-get annot 'markup-edges)))
;;                   (text       (or (assoc-default 'subject annot)
;;                                   (assoc-default 'content annot)
;;                                   (replace-regexp-in-string
;;                                    "\n" " "
;;                                    (pdf-info-gettext page real-edges nil pdfpath))))
;;                   (height     (nth 1 real-edges))
;;                   (linktext   (concat "[[pdfview:" pdfpath "::" (number-to-string page)
;;                                       "++" (number-to-string height) "][" title "]]")))
;;              (setq output (concat output text " (" linktext ", "
;;                                   (number-to-string page) ")\n\n")))))
;;        annots)
;;       output)))

;;; xterm-mouse -- enable mouse in terminal Emacs

(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;;; agent-shell -- AI shell with system package manager integration

(use-package agent-shell
  :ensure-system-package
  ((claude       . "brew install claude-code")
   (claude-agent-acp . "npm install -g @zed-industries/claude-agent-acp")))

(provide 'my-packages)
;;; my-packages.el ends here
