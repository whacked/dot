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

;;; Font selection
;;
;; Pick the first available monospace font from a preference list.
;; font-exist-p is also used by set-font (CJK alignment, below).
;; TODO: verify this still matters now?

(defun font-exist-p (fontname)
  "Test if this font is exist or not."
  (if (or (not fontname) (string= fontname ""))
      nil
    (if (not (x-list-fonts fontname)) nil t)))

(when window-system
  (let ((font-pair (cond ((font-exist-p "Consolas")
                          '("Consolas" . 10))
                         ((font-exist-p "Monaco")
                          '("Monaco" . 11))
                         ((font-exist-p "Droid Sans Mono")
                          '("Droid Sans Mono" . 11))
                         ((font-exist-p "Deja Vu Sans Mono")
                          '("Deja Vu Sans Mono" . 9))
                         ((font-exist-p "Inconsolata")
                          '("Inconsolata" . 9))
                         ((font-exist-p "Anonymous Pro")
                          '("Anonymous Pro" . 8)))))
    (when font-pair
      (defvar emacs-english-font (car font-pair))
      (let ((font-string (format "%s-%s" emacs-english-font (cdr font-pair))))
        (set-frame-font font-string nil t))
      (add-to-list
       'default-frame-alist
       `(font . ,(format "%s-%s" emacs-english-font (cdr font-pair)))))))

;; TODO: verify this still matters?
;;; CJK table alignment
;;
;; see http://coldnew.github.io/blog/2013/11-16_d2f3a/ 解決 org-mode 表格內中英文對齊的問題

(defvar emacs-cjk-font "Hiragino Sans GB W3"
  "The font name for CJK.")

(defvar emacs-font-size-pair '(13 . 16)
  "Default font size pair for (english . chinese)")

(defvar emacs-font-size-pair-list
  '(( 5 .  6) (10 . 12)
    (13 . 16) (15 . 18) (17 . 20)
    (19 . 22) (20 . 24) (21 . 26)
    (24 . 28) (26 . 32) (28 . 34)
    (30 . 36) (34 . 40) (36 . 44))
  "This list is used to store matching (englis . chinese) font-size.")

(defun set-font (english chinese size-pair)
  "Setup emacs English and Chinese font on x window-system."

  (if (font-exist-p english)
      (set-frame-font (format "%s:pixelsize=%d" english (car size-pair)) t))

  (if (font-exist-p chinese)
      (dolist (charset '(kana han symbol cjk-misc bopomofo))
        (set-fontset-font (frame-parameter nil 'font) charset
                          (font-spec :family chinese :size (cdr size-pair))))))

;;; Emoji
;; ref https://ianyepan.github.io/posts/emacs-emojis/

;; (dolist (x (font-family-list)) (insert (format "%s\n" x)))
(when (member "NotoEmoji Nerd Font Mono" (font-family-list))
  (set-fontset-font
   t 'symbol (font-spec :family "NotoEmoji Nerd Font Mono") nil 'prepend))

(provide 'my-ui)
;;; my-ui.el ends here
