(setq inhibit-splash-screen t)
(set-default-coding-systems 'undecided-unix)

(add-to-list 'load-path "~/.emacs.d")
(let ((system-name-el (concat "~/.emacs.d/system-name/" system-name ".el")))
  (when (file-exists-p system-name-el)
    (load-file system-name-el)))

