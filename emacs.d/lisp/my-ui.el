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
;; Sarasa Mono J is preferred: it combines Iosevka (ASCII) + Source Han Sans
;; (CJK) with a built-in 2:1 glyph-width ratio, giving perfect org-mode table
;; alignment for Chinese, Japanese, and Korean without any fontset tricks.
;; Install via nix: pkgs.sarasa-gothic.
;;
;; Falls back to plain monospace fonts when Sarasa is not installed.

(defun font-exist-p (fontname)
  "Return non-nil if FONTNAME is available on this system."
  (and fontname
       (not (string= fontname ""))
       (x-list-fonts fontname)))

(when window-system
  (let ((font-pair (or (and (font-exist-p "Sarasa Mono J")      '("Sarasa Mono J" . 13))
                       (and (font-exist-p "Consolas")            '("Consolas" . 10))
                       (and (font-exist-p "Monaco")              '("Monaco" . 11))
                       (and (font-exist-p "Droid Sans Mono")     '("Droid Sans Mono" . 11))
                       (and (font-exist-p "DejaVu Sans Mono")    '("DejaVu Sans Mono" . 9))
                       (and (font-exist-p "Inconsolata")         '("Inconsolata" . 9))
                       (and (font-exist-p "Anonymous Pro")       '("Anonymous Pro" . 8)))))
    (when font-pair
      (defvar emacs-english-font (car font-pair))
      (let ((font-string (format "%s-%s" emacs-english-font (cdr font-pair))))
        (set-frame-font font-string nil t)
        (add-to-list 'default-frame-alist (cons 'font font-string))))))

;;; CJK font -- org-mode table alignment
;;
;; When Sarasa Mono J is the primary font (see above), its ASCII and CJK glyphs
;; have a built-in 2:1 width ratio -- no fontset overlay or rescaling needed.
;; my-cjk-setup is skipped in that case.
;;
;; When falling back to a plain ASCII font (Consolas, Monaco, etc.), separate
;; CJK fonts are overlaid via set-fontset-font and scaled via
;; face-font-rescale-alist so 1 CJK glyph = 2× ASCII glyph width.
;;
;; Note: for the hybrid approach (Sarasa as CJK overlay on a non-Sarasa base),
;; use (push '("Sarasa Mono J" . ,(/ 16.0 13.0)) face-font-rescale-alist).
;; ref: https://lists.gnu.org/archive/html/emacs-orgmode/2023-03/msg00415.html

;;; # CJK alignment test (E=English C=Chinese J=Japanese K=Korean)
;;; # Alignment test: every cell in the ←4→ column must be exactly 4 display
;;; # units wide, every cell in ←8→ must be 8.  If fonts are correct all the
;;; # | separators will be perfectly vertical.
;;; # org-mode test table
;;  | Combo   | ←4→ | ←8→    |
;;  |---------+-------+----------|
;;  | E       | ABCD  | ABCDEFGH |
;;  | C       | 中文  | 一二三四 |
;;  | J       | あい  | あいうえ |
;;  | K       | 가나  | 가나다라 |
;;  |---------+-------+----------|
;;  | E+C     | AB中  | ABCD中文 |
;;  | E+J     | ABあ  | ABCDあい |
;;  | E+K     | AB가  | ABCD가나 |
;;  | C+J     | 中あ  | 中文あい |
;;  | C+K     | 中가  | 中文가나 |
;;  | J+K     | あ가  | あい가나 |
;;  |---------+-------+----------|
;;  | E+C+J+K | --    | AB中あ가 |

(defun my-cjk-setup ()
  "Configure CJK fonts for org-mode table alignment.
Each CJK glyph must render at exactly 2× the ASCII glyph width.
face-font-rescale-alist scales the font until the ratio is correct.
The 1.2 factor suits Monaco/Consolas + Hiragino on macOS; tweak if needed.

Call M-x my-cjk-setup-report to see which fonts were actually selected."
  (when (display-graphic-p)
    (let ((kana-font   (seq-find #'font-exist-p
                                 '("Hiragino Kaku Gothic ProN"
                                   "Hiragino Sans"
                                   "YuGothic"
                                   "Source Han Sans")))
          (han-font    (seq-find #'font-exist-p
                                 '("Hiragino Sans GB"
                                   "PingFang SC"
                                   "STHeiti"
                                   "Source Han Sans SC"
                                   "WenQuanYi Micro Hei")))
          (hangul-font (seq-find #'font-exist-p
                                 '("Apple SD Gothic Neo"
                                   "Nanum Gothic"))))
      ;; Rescale factors: scale × natural-glyph-width must = 2 × ASCII-glyph-width.
      ;; Hiragino glyphs are naturally wider than Apple SD Gothic Neo, so they
      ;; need a smaller factor.  Tune these if rows still look off.
      (when kana-font
        (set-fontset-font t 'kana (font-spec :family kana-font))
        (add-to-list 'face-font-rescale-alist (cons kana-font 1.0)))
      (when han-font
        (dolist (charset '(han cjk-misc bopomofo))
          (set-fontset-font t charset (font-spec :family han-font)))
        (add-to-list 'face-font-rescale-alist (cons han-font 1.0)))
      (when hangul-font
        (set-fontset-font t 'hangul (font-spec :family hangul-font))
        (add-to-list 'face-font-rescale-alist (cons hangul-font 1.2)))
      (list :kana kana-font :han han-font :hangul hangul-font))))

(defun my-cjk-setup-report ()
  "Show which CJK fonts were selected for table alignment."
  (interactive)
  (let ((result (my-cjk-setup)))
    (message "CJK fonts: kana=%s  han=%s  hangul=%s"
             (or (plist-get result :kana)   "NOT FOUND")
             (or (plist-get result :han)    "NOT FOUND")
             (or (plist-get result :hangul) "NOT FOUND"))))

;; Skip CJK overlay when Sarasa Mono is primary -- it handles CJK natively.
(unless (and (boundp 'emacs-english-font)
             (string-match-p "Sarasa" emacs-english-font))
  (my-cjk-setup))

;;; Emoji
;; ref https://ianyepan.github.io/posts/emacs-emojis/

;; (dolist (x (font-family-list)) (insert (format "%s\n" x)))
(when (member "NotoEmoji Nerd Font Mono" (font-family-list))
  (set-fontset-font
   t 'symbol (font-spec :family "NotoEmoji Nerd Font Mono") nil 'prepend))

(provide 'my-ui)
;;; my-ui.el ends here
