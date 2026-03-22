;;; my-core.el --- Core utilities, environment, and package bootstrap -*- lexical-binding: t -*-

;;; Utility functions

(defun path-join (&rest path-seq)
  "Join path components, treating all but the last as directories."
  (concat (mapconcat #'file-name-as-directory (butlast path-seq) "")
          (car (last path-seq))))

(defun now (&optional date-only)
  "Display current timestamp in the minibuffer.
With prefix arg DATE-ONLY, show date only (YYYY-MM-DD)."
  (interactive "P")
  (message (format-time-string (if date-only "%Y-%m-%d" "%Y-%m-%d %H:%M:%S%z"))))

(defun insert-timestamp (&optional date-only)
  "Insert current timestamp at point.
With prefix arg DATE-ONLY, insert date only (YYYY-MM-DD)."
  (interactive "P")
  (insert (format-time-string (if date-only "%Y-%m-%d" "%Y-%m-%d %H:%M:%S%z"))))

;;; exec-path: ensure nix profile binaries are reachable
;;
;; Done unconditionally and early so the nix toolchain is available to
;; straight.el (git, curl) and to exec-path-from-shell's shell invocation.

(let ((nix-bin (expand-file-name "~/.nix-profile/bin")))
  (unless (member nix-bin exec-path)
    (add-to-list 'exec-path nix-bin))
  (unless (string-match-p (regexp-quote nix-bin) (or (getenv "PATH") ""))
    (setenv "PATH" (concat nix-bin ":" (getenv "PATH")))))

;;; straight.el bootstrap

;; straight.el is the package manager. package.el is disabled in early-init.el.
;; This block is idempotent: the bootstrap.el load is skipped when straight is
;; already initialized (file exists and straight-use-package is already defined).
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         (or (bound-and-true-p straight-base-dir)
                             user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; use-package

;; Declare straight symbols to silence byte-compiler warnings when straight is
;; not yet loaded (e.g. during batch byte-compile checks).
(defvar straight-use-package-by-default)
(declare-function straight-use-package "straight")

(straight-use-package 'use-package)

;; Emacs 30 ships use-package as a built-in and registers autoloads
;; pointing to absolute nix store paths. If any (use-package ...) form fires
;; before use-package is fully loaded, that autoload triggers and loads the
;; nix built-in — which has no :straight keyword and can't find packages.
;; Explicitly requiring use-package here loads straight's version first,
;; calls (provide 'use-package-core), and prevents the autoload from firing.
(require 'use-package)

;; All use-package declarations use straight.el by default.
;; Do NOT set use-package-always-ensure alongside this — they conflict.
(setq straight-use-package-by-default t)

;;; org — load straight's org before any package can trigger the built-in
;;
;; Several packages (htmlize, org-ql, jupyter, org-download, etc.) depend on
;; org and will pull in Emacs's built-in org if straight hasn't loaded its
;; version yet, causing the "Org version mismatch" warning on every startup.
;; Explicitly bootstrapping org here, immediately after straight/use-package
;; are ready, prevents that race.
(straight-use-package 'org)

;;; exec-path-from-shell — import shell env into GUI Emacs
;;
;; GUI Emacs on macOS starts with launchd's minimal environment and does not
;; inherit shell exports.  exec-path-from-shell spawns an interactive shell
;; once at startup and copies the listed variables (plus PATH/MANPATH by
;; default) into Emacs.  Skip in terminal Emacs — env is already inherited.
;;
;; Runs after straight/use-package are ready, but before any code that reads
;; the imported vars (CLOUDSYNC, TREESIT_GRAMMAR_DIR).

(use-package exec-path-from-shell
  :if (display-graphic-p)
  :config
  (dolist (var '("TREESIT_GRAMMAR_DIR" "CLOUDSYNC"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize))

;;; Environment variables
;;
;; CLOUDSYNC: fall back to ~/cloudsync when not set in the environment.
;; In GUI Emacs exec-path-from-shell will have imported it above; this
;; fallback covers terminal Emacs and any machine where the var isn't exported.

(unless (getenv "CLOUDSYNC")
  (setenv "CLOUDSYNC" (expand-file-name "cloudsync" (getenv "HOME"))))

(defvar my-cloudsync-note-dir
  (expand-file-name "main/note/org" (getenv "CLOUDSYNC"))
  "Root directory for org notes inside CLOUDSYNC.")

(provide 'my-core)
;;; my-core.el ends here
