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
;; Grammars live in /opt/tree-sitter/abi<N>/ where N is this build's
;; tree-sitter library ABI version.  Two Emacs builds linked against
;; different tree-sitter versions get separate subdirectories — no clobber.
(when (fboundp 'treesit-library-abi-version)
  (let ((grammar-dir (format "/opt/tree-sitter/abi%d"
                             (treesit-library-abi-version))))
    (make-directory grammar-dir t)
    ;; setq, not add-to-list: treesit-install-language-grammar writes to
    ;; (car treesit-extra-load-path), so it must be our versioned dir.
    (setq treesit-extra-load-path (list grammar-dir))))

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (global-treesit-auto-mode))

(provide 'my-packages)
;;; my-packages.el ends here
