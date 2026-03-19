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

(provide 'my-packages)
;;; my-packages.el ends here
