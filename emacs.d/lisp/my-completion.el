;;; my-completion.el --- Minibuffer and in-buffer completion -*- lexical-binding: t -*-
;;
;; Stack: vertico (minibuffer UI) + consult (search/navigation commands)
;;        + marginalia (annotations) + corfu (in-buffer) + orderless (matching)

;;; Vertico -- vertical minibuffer completion UI

(use-package vertico
  :init
  (vertico-mode))

;; Hide M-x commands that don't apply to the current mode.
(use-package emacs
  :custom
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p))

;;; Consult -- search and navigation commands

;; consult-line subsumes swiper; consult-ripgrep subsumes counsel-rg.
(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :custom
  (consult-preview-key nil)
  (consult-narrow-key nil)
  :config
  (consult-customize
   consult-theme consult-line consult-line-at-point
   :preview-key '(:debounce 0.2 any)))

;;; Marginalia -- annotations in the minibuffer (e.g. docstrings next to M-x)
(use-package marginalia
  :init
  (marginalia-mode))

;;; Corfu -- in-buffer completion popup (replaces company-mode)
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  :bind (:map corfu-map
              ("TAB"     . corfu-next)
              ([tab]     . corfu-next)
              ("C-n"     . corfu-next)
              ("S-TAB"   . corfu-previous)
              ([backtab] . corfu-previous)
              ("C-p"     . corfu-previous))
  :init
  (global-corfu-mode))

;;; Orderless -- fuzzy/space-separated completion style
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(provide 'my-completion)
;;; my-completion.el ends here
