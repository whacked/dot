;;; my-system.el --- OS-specific and per-machine initialization -*- lexical-binding: t -*-
;;
;; Covers OS-conditional settings.  Per-machine org files (system-name/,
;; user-login-name/) are pending adaptation from the old path-join /
;; EMACS.D-DIR infrastructure to expand-file-name + user-emacs-directory.

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
