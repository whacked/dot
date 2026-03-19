;;; early-init.el --- Early initialization -*- lexical-binding: t -*-
;;
;; Loaded by Emacs before package.el and the GUI are initialized.
;; Keep this minimal: only things that must run before the frame exists.

;;; Startup performance

;; Raise GC threshold during startup to reduce GC pauses.
;; Reset to a reasonable value after init via after-init-hook.
(setq gc-cons-threshold (* 128 1024 1024))
(add-hook 'after-init-hook
          (lambda () (setq gc-cons-threshold (* 16 1024 1024))))

;;; Package management

;; We use straight.el instead of package.el. Disable package.el here
;; so it does not initialize or touch elpa directories at startup.
(setq package-enable-at-startup nil)

;;; Suppress UI flash

;; Disable GUI elements before the frame is created to avoid a brief
;; flash of the toolbar/scrollbar on startup.
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;;; early-init.el ends here
