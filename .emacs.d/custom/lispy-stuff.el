(setq my-packages (append my-packages '(
         ;; lispy stuff
         paredit
         clojure-mode
         cider
         expand-region
         )))

(add-hook 'clojure-mode-hook (lambda ()
                               (require 'expand-region)
                               (global-set-key (kbd "C-=") 'er/expand-region)
                               (paredit-mode 1)))
