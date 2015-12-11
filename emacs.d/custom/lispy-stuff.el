(setq my-packages (append my-packages '(
         ;; lispy stuff
         queue
         paredit
         clojure-mode
	 popup
         seq
         cider
         expand-region
         hy-mode
         )))

(add-hook 'cider-repl-mode-hook (lambda ()
                                  (paredit-mode 1)))
(add-hook 'clojure-mode-hook (lambda ()
                               (require 'expand-region)
                               (global-set-key (kbd "C-=") 'er/expand-region)
                               (paredit-mode 1)))
