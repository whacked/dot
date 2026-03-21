;;; init.el --- Main entry point -*- lexical-binding: t -*-

;;; Load path

;; Modules live in lisp/ — avoids the load-path=user-emacs-directory warning.
;; M-. on any (require 'my-*) symbol below navigates to the module file.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Local minor modes live in emacs.d/mode/
(add-to-list 'load-path (expand-file-name "mode" user-emacs-directory))

;;; Modules
;;
;; M-. on any symbol below jumps to the corresponding .el file.
;; (requires elisp-xref, available by default in Emacs 28+)

(require 'my-core)
(require 'my-system)
(require 'my-ui)
(require 'my-completion)
(require 'my-editing)
(require 'my-keybindings)
(require 'my-packages)
(require 'my-org)
(require 'my-utils)

;;; Local overrides (machine-specific, gitignored)

(let ((local (expand-file-name "local.el" user-emacs-directory)))
  (when (file-exists-p local)
    (load local)))

;;; Custom file

;; custom.el is managed by Emacs; load it last so it can override
;; anything set above without interfering with module load order.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
