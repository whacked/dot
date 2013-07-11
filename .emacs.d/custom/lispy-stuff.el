(setq my-packages (append my-packages '(
         ;; lispy stuff
         paredit
         clojure-mode nrepl
         )))

(add-hook 'clojure-mode-hook (lambda () (paredit-mode 1)))
