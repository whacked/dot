;;; my-system.el --- OS-specific initialization -*- lexical-binding: t -*-
;;
;; Covers OS-conditional settings.  Machine-specific overrides live in
;; local.el (gitignored), loaded at the end of init.el.

;;; OS-specific

;;;; GNU/Linux

(when (eq system-type 'gnu/linux)
  ;; use x-clipboard
  (setq x-select-enable-clipboard t)
  (when (display-graphic-p)
    (add-to-list 'default-frame-alist '(width . 100))
    (add-to-list 'default-frame-alist '(height . 60))))

;;;; Darwin

(when (eq system-type 'darwin)
  (when (featurep 'ns)
    ;; turn apple key into Meta
    ;; (setq ns-command-modifier 'meta)

    ;; ;; for macports
    ;; (setenv "PATH" (concat "/opt/local/bin:/opt/local/sbin:" (getenv "PATH")))
    ;; (setq exec-path (append exec-path '("/opt/local/bin:/opt/local/sbin:")))
    (message "mac config loaded")))

(provide 'my-system)
;;; my-system.el ends here
