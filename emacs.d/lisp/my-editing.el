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

;;; Window history

(winner-mode 1)

;;; quit-window -- always kill the buffer, not just bury it

(advice-add 'quit-window :filter-args
  (lambda (args)
    "Always kill the buffer when running `quit-window'."
    (cons t (cdr args))))

;;; dabbrev

;; TODO: review what this does. i no longer know
(require 'dabbrev)
(setq dabbrev-always-check-other-buffers t
      dabbrev-abbrev-char-regexp "\\sw\\|\\s_")

;;; Desktop stale-lock override
;;
;; Emacs writes a desktop lock file containing its PID.  On Linux, if the
;; previous Emacs crashed, the PID may be reused by a non-Emacs process,
;; which would prevent desktop restore.  `emacs-process-p' checks /proc/
;; (Linux-only; harmless on Darwin -- /proc/ won't exist, returns nil, so
;; the lock is always considered stale and desktop restore proceeds).

(defun emacs-process-p (pid)
  "Return PID if it belongs to a running Emacs process, else nil."
  (when pid
    (let ((cmdline-file (concat "/proc/" (int-to-string pid) "/cmdline")))
      (when (file-exists-p cmdline-file)
        (with-temp-buffer
          (insert-file-contents-literally cmdline-file)
          (goto-char (point-min))
          (when (search-forward "emacs" nil t)
            pid))))))

(advice-add 'desktop-owner :filter-return
  (lambda (pid)
    "Return nil if PID does not belong to a live Emacs process."
    (and (emacs-process-p pid) pid)))

;;; ansi-color and uniquify (built-in)

(require 'ansi-color)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;;; Misc interactive utilities

(defun surround-region-with-tag (tag-name beg end)
  "Wrap the region from BEG to END with an HTML/XML tag named TAG-NAME."
  (interactive "sTag name: \nr")
  (save-excursion
    (goto-char end)
    (insert "</" tag-name ">")
    (goto-char beg)
    (insert "<" tag-name ">")))

(defun clear-shell ()
  "Clear a comint (shell/ESS) buffer by truncating it to zero lines."
  (interactive)
  (let ((old-max comint-buffer-maximum-size))
    (setq comint-buffer-maximum-size 0)
    (comint-truncate-buffer)
    (setq comint-buffer-maximum-size old-max)))

;;; Unicode box-drawing table → plain org/markdown table

(defun utf-box-table->plain (beg end)
  "Convert a Unicode box-drawing table to a plain pipe table in region BEG to END.
Removes horizontal divider lines and replaces box-drawing vertical bars with
plain ASCII pipes, then realigns as an org table."
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list (point-min) (point-max))))
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      ;; Remove horizontal divider lines (lines containing only box-drawing
      ;; horizontal/corner/junction characters and whitespace).
      (goto-char (point-min))
      (while (re-search-forward
              "^[[:space:]]*[┌┬┐├┼┤└┴┘─]+[─┌┬┐├┼┤└┴┘[:space:]]*\n?" nil t)
        (replace-match ""))
      ;; Replace box-drawing vertical bars with plain ASCII pipes.
      (goto-char (point-min))
      (while (re-search-forward "[│]" nil t)
        (replace-match "|"))
      ;; Realign as org table if org-table is available.
      (when (fboundp 'org-table-align)
        (goto-char (point-min))
        (while (re-search-forward "^[[:space:]]*|" nil t)
          (org-table-align)
          ;; Jump past the table that was just aligned.
          (re-search-forward "^[^|]" nil 'move))))))

;;; remove text properties / decorations
(defun strip-text-properties (start end)
  "Remove all text properties (colors, faces, prefixes) from the region."
  (interactive "r")
  (let ((inhibit-read-only t))
    (set-text-properties start end nil)))


;;; Enable commands disabled by default

(put 'set-goal-column  'disabled nil)
(put 'narrow-to-region 'disabled nil)

(provide 'my-editing)
;;; my-editing.el ends here
