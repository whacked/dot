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
  :defer t
  :mode (("\\.md\\'"       . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :custom
  (markdown-hide-markup nil)
  (markdown-xml-tag-font-lock t)
  :config
  (custom-set-faces
   '(markdown-header-face-1
     ((t (:inherit markdown-header-face :height 1.5 :weight bold :foreground "MidnightBlue"))))
   '(markdown-header-face-2
     ((t (:inherit markdown-header-face :height 1.3 :weight bold :foreground "DarkGreen"))))
   '(markdown-header-face-3
     ((t (:inherit markdown-header-face :weight bold :foreground "Firebrick"))))
   '(markdown-link-face
     ((t (:foreground "blue" :underline t))))
   '(markdown-inline-code-face
     ((t (:background "#EFEFEF" :foreground "#8B008B"
          :box (:line-width 1 :style released-button)))))
   '(markdown-code-face
     ((t (:background "#F5F5F5" :foreground "#333333"))))
   '(markdown-blockquote-face
     ((t (:foreground "DarkSlateGray" :slant italic :background "#F7F7F7")))))
  (add-hook 'markdown-mode-hook (lambda () (setq tab-width 2))))

;;; win-switch — repeated other-window via C-x o o o ...

(use-package win-switch
  :bind ("C-x o" . win-switch-dispatch)
  :custom (win-switch-idle-time 0.3))

;;; magit

(use-package magit)

;;; expand-region

(use-package expand-region
  :bind ("C-=" . er/expand-region))

;;; paredit — structural editing for Lisp modes

(use-package paredit
  :hook ((emacs-lisp-mode       . enable-paredit-mode)
         (lisp-mode             . enable-paredit-mode)
         (lisp-interaction-mode . enable-paredit-mode)
         (clojure-mode          . enable-paredit-mode)
         (clojurescript-mode    . enable-paredit-mode))
  :bind (:map paredit-mode-map
              ("C-S-d" . paredit-duplicate-after-point))
  :config
  (defun paredit-duplicate-after-point ()
    "Duplicate the sexp after point onto the next line."
    (interactive)
    (while (looking-at " ") (forward-char))
    (set-mark-command nil)
    (while (and (<= (point) (car (bounds-of-thing-at-point 'sexp)))
                (not (= (point) (line-end-position))))
      (forward-sexp)
      (while (looking-at " ") (forward-char)))
    (kill-ring-save (mark) (point))
    (paredit-newline)
    (set-mark-command nil)
    (yank)
    (exchange-point-and-mark)))

;;; obsidian.el — Obsidian vault interop
;; TODO: reevaluate whether necessary
(use-package obsidian
  :demand t
  :custom
  (obsidian-directory my-cloudsync-note-dir)
  (obsidian-inbox-directory "pages")
  :config
  (global-obsidian-mode t)
  :bind (:map obsidian-mode-map
              ("C-c C-o" . obsidian-follow-link-at-point)
              ("C-c C-b" . obsidian-backlink-jump)
              ("C-c C-l" . obsidian-insert-wikilink)))

;;; claude-code-ide
;;
;; Requires node on PATH.  exec-path-from-shell (in my-core.el) imports PATH
;; from the shell — ensure node/npm are in your shell profile.
;; eat (above) is the terminal backend.

(use-package claude-code-ide
  :straight (:type git :host github :repo "manzaltu/claude-code-ide.el")
  :config
  (setq claude-code-ide-terminal-backend 'eat)
  (claude-code-ide-emacs-tools-setup))

(provide 'my-packages)
;;; my-packages.el ends here
