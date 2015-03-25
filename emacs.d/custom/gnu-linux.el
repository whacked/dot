;; use x-clipboard
(setq x-select-enable-clipboard t)
;; <ubuntu-tp customizations> ;;;;;;
;;
(setq user-emacs-directory "~/dot/emacs.d")
(setq el-get-dir "~/dot/emacs.d/el-get")

;; ;; use anthy
;; ;; http://www.emacswiki.org/emacs/IBusMode
;; (add-to-list 'load-path "/usr/share/emacs/site-lisp/ibus")
;; (require 'ibus)
;; (add-hook 'after-init-hook 'ibus-mode-on)
;; (setq ibus-agent-file-name "/usr/lib/ibus-el/ibus-el-agent")

(when (display-graphic-p)
  (add-to-list 'default-frame-alist '(width . 100))
  (add-to-list 'default-frame-alist '(height . 60)))


(defun djcb-opacity-modify (&optional dec)
  "modify the transparency of the emacs frame; if DEC is t,
    decrease the transparency, otherwise increase it in 10%-steps"
  (let* ((alpha-or-nil (frame-parameter nil 'alpha)) ; nil before setting
          (oldalpha (if alpha-or-nil alpha-or-nil 100))
          (newalpha (if dec (- oldalpha 10) (+ oldalpha 10))))
    (when (and (>= newalpha frame-alpha-lower-limit) (<= newalpha 100))
      (modify-frame-parameters nil (list (cons 'alpha newalpha))))))

 ;; C-8 will increase opacity (== decrease transparency)
 ;; C-9 will decrease opacity (== increase transparency
 ;; C-0 will returns the state to normal
(global-set-key (kbd "C-8") '(lambda()(interactive)(djcb-opacity-modify)))
(global-set-key (kbd "C-9") '(lambda()(interactive)(djcb-opacity-modify t)))
(global-set-key (kbd "C-0") '(lambda()(interactive)
                               (modify-frame-parameters nil `((alpha . 100)))))
