;;; my-keybindings.el --- Global keybindings and minor-mode overrides -*- lexical-binding: t -*-
;;
;; Covers: quit guard, global key overrides, my-keys-minor-mode (window
;; movement), vim-like cursor placement, balance-windows refinement.

;;; Quit guard

(defun maybe-save-buffers-kill-emacs (really)
  "If REALLY is \"yes\", call `save-buffers-kill-emacs'."
  (interactive "sAre you sure about this? ")
  (when (equal really "yes")
    (save-buffers-kill-emacs)))

(global-set-key (kbd "C-x C-c") #'maybe-save-buffers-kill-emacs)

;;; Aliases

(defalias 'visu #'visual-line-mode)

;;; balance-windows refinement
;;
;; With \\[universal-argument], balance only the selected window's sibling
;; group (its parent subtree) instead of the whole frame.

(advice-add 'balance-windows :around
  (lambda (orig &optional window)
    "With prefix arg, balance only the selected window's sibling group."
    (interactive "P")
    (funcall orig (when window (window-parent)))))

;;; Global key overrides

;; s-p / s-P — consult navigation (supersede macOS "print" shortcut)
(global-set-key (kbd "s-p") #'consult-buffer)
(global-set-key (kbd "s-P") #'consult-mode-command)

;; C-x C-b — ibuffer (replaces list-buffers)
(global-set-key (kbd "C-x C-b") #'ibuffer)

;; M-o — ace-window (quick window switching)
(global-set-key (kbd "M-o") #'ace-window)

;;; my-keys-minor-mode — overrides that must beat major-mode maps
;;
;; A thin minor mode so our bindings win even when major modes rebind the
;; same keys.  Ref: http://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs

(defvar my-keys-minor-mode-map (make-keymap)
  "Keymap for `my-keys-minor-mode'.")

(define-minor-mode my-keys-minor-mode
  "Minor mode that holds global key overrides."
  :init-value t
  :lighter " my-keys"
  :keymap my-keys-minor-mode-map)

(my-keys-minor-mode 1)

;; Window movement: Super + arrow
(define-key my-keys-minor-mode-map [s-left]  #'windmove-left)
(define-key my-keys-minor-mode-map [s-right] #'windmove-right)
(define-key my-keys-minor-mode-map [s-up]    #'windmove-up)
(define-key my-keys-minor-mode-map [s-down]  #'windmove-down)

;; Org bindings that must override major-mode maps
(define-key my-keys-minor-mode-map (kbd "M-_") #'org-metaleft)
(define-key my-keys-minor-mode-map (kbd "M-+") #'org-metaright)

;;; Vim-like cursor placement (H / M / L within visible window)

(global-set-key (kbd "C-` H")
                (lambda () (interactive) (move-to-window-line-top-bottom 0)))
(global-set-key (kbd "C-` M")
                (lambda () (interactive) (move-to-window-line-top-bottom)))
(global-set-key (kbd "C-` L")
                (lambda () (interactive) (move-to-window-line-top-bottom -1)))

;;; Other key bindings

(define-key global-map (kbd "<f12>") 'dumb-jump-go)

(provide 'my-keybindings)
;;; my-keybindings.el ends here
