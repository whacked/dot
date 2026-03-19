;;; my-editing.el --- Editing defaults and behaviour -*- lexical-binding: t -*-
;;
;; Covers: file backups, desktop session, recentf, indent/tab defaults,
;; trailing whitespace. Keybindings live in my-keybindings.el.
;; Package-specific editing behaviour lives in the relevant package module.

;;; Backups

(setq backup-directory-alist
      `(("" . ,(expand-file-name "emacs-backup" user-emacs-directory))))

;;; Desktop session

;; Persist open buffers and window layout across restarts.
(desktop-change-dir user-emacs-directory)
(setq desktop-save-mode t)

;;; recentf

(recentf-mode 1)
(setq recentf-max-menu-items 100
      recentf-max-saved-items 200)

;;; Indent / tab defaults

(setq-default indent-tabs-mode nil
              tab-width 2)

;;; Save hooks

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(provide 'my-editing)
;;; my-editing.el ends here
