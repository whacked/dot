;;; init.el --- Main entry point -*- lexical-binding: t -*-

;;; Load path

;; Include emacs.d root so (require 'my-*) resolves to ./my-*.el
(add-to-list 'load-path (expand-file-name user-emacs-directory))

;; Local minor modes live in emacs.d/mode/
(add-to-list 'load-path (expand-file-name "mode" user-emacs-directory))

;;; Modules
;;
;; M-. on any symbol below jumps to the corresponding .el file.
;; (requires elisp-xref, available by default in Emacs 28+)

;; (require 'my-core)
;; (require 'my-ui)
;; (require 'my-completion)
;; (require 'my-editing)
;; (require 'my-packages)
;; (require 'my-org)
;; (require 'my-system)

;;; Custom file

;; custom.el is managed by Emacs; load it last so it can override
;; anything set above without interfering with module load order.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
