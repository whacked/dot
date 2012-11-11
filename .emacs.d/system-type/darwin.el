(when (file-exists-p (expand-file-name "~/dot/cne.emacs"))
  (load-file (expand-file-name "~/dot/cne.emacs")))
         ;;;;;; <OS X customizations> ;;;;;;
         ;;; turn apple key into Meta
(when (featurep 'ns)
  (setq ns-command-modifier 'meta)
  (if (eq window-system 'mac) (require 'carbon-font))
  (setq ; xwl-default-font "Monaco-12"
   xwl-japanese-font "Hiragino_Kaku_Gothic_ProN")
  (let ((charset-font `((japanese-jisx0208 . ,xwl-japanese-font)
                        (japanese-jisx0208 . ,xwl-japanese-font)
                        ;; (japanese-jisx0212 . ,xwl-japanese-font)
                        )))
                                        ; (set-default-font xwl-default-font)
    (mapc (lambda (charset-font)
            (set-fontset-font (frame-parameter nil 'font)
                              (car charset-font)
                              (font-spec :family (cdr charset-font) :size
                                         12)))
          charset-font))
  (defun osx-resize-current-window ()
    (interactive)
    (let* ((ncol (string-to-number (read-from-minibuffer "ncol? ")))
           (nrow (string-to-number (read-from-minibuffer "nrow? "))))
      (set-frame-size (selected-frame) ncol nrow)))
  (defun osx-move-current-window ()
    (interactive)
    (let* ((x (string-to-number (read-from-minibuffer "x? ")))
           (y (string-to-number (read-from-minibuffer "y? "))))
      (set-frame-position (selected-frame) x y)))
  (defun win:to1 ()
    (interactive)
    (set-frame-size (selected-frame) 200 56)
    (set-frame-position (selected-frame) 0 20))
  (defun win:to2 ()
    (interactive)
    (set-frame-position (selected-frame) 1440 -200)
    (set-frame-size (selected-frame) 268 78))

  ;;(setq ipython-command "/opt/local/bin/ipython")
  ;;(require 'ipython)
  ;;(setq py-python-command-args '( "-colors" "Linux"))
  ;;(require 'python-mode)
  (setenv "PYTHONPATH" "/opt/local/bin/python")

  ;; w3m
  ;;(add-to-list 'load-path "/opt/local/share/emacs/site-lisp/w3m")
  ;;(setq w3m-command "/usr/bin/w3m")
  ;;(require 'w3m-load)
  ;;(require 'w3m-e21)
  ;;(provide 'w3m-e23)

  ;;(setenv "PATH" (format "%s:%s" (getenv "PATH") "/usr/texbin:/usr/local/bin"))
  ;;(load "/usr/share/emacs/site-lisp/auctex.el" nil t t)
  ;;(load "/usr/share/emacs/site-lisp/preview-latex.el" nil t t)

         ;;;;;; </OS X customizations> ;;;;;;
  
  )

(message "using OS X")
