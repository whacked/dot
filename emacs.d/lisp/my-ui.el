;;; my-ui.el --- Visual defaults and theme -*- lexical-binding: t -*-
;;
;; Covers: encoding defaults, global display modes, scroll behaviour,
;; UI chrome, and the colour theme. Editing-behaviour defaults
;; (indent, tabs, backups) live in my-editing.el.
;; Org-specific faces live in my-org.el.

;;; Encoding

(set-default-coding-systems 'utf-8)
(set-language-environment "UTF-8")

;;; Performance / display hygiene

;; Avoid performance issues with very long lines.
(global-so-long-mode 1)

;;; Global display modes

(transient-mark-mode 1)
(show-paren-mode 1)
(line-number-mode 1)
(column-number-mode 1)
(global-hl-line-mode 1)

;; Belt-and-suspenders: early-init.el suppresses these via frame-alist
;; before the first frame, but explicit calls ensure terminal Emacs also
;; starts clean.
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; To disable scroll bars entirely, uncomment the next line and remove
;; the set-scroll-bar-mode call below (and update early-init.el to match).
;; (when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'set-scroll-bar-mode) (set-scroll-bar-mode 'right))

;;; Scroll behaviour

(setq-default hscroll-step 1
              scroll-step 1
              scroll-conservatively 10000)

;;; Miscellaneous display settings

(setq-default inhibit-splash-screen t
              truncate-lines t)

;; Shorten the echo-area keystroke display delay (default is 1 second).
(setq echo-keystrokes 0.1)

;;; Colour theme

;; modus-operandi-tinted is built into Emacs 29+; no package required.
;; The second argument `t' skips the interactive confirmation prompt.
;; Guard prevents re-applying the theme on repeated loads.
(unless (member 'modus-operandi-tinted custom-enabled-themes)
  (load-theme 'modus-operandi-tinted t))

(provide 'my-ui)
;;; my-ui.el ends here
