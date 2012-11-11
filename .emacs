(setq inhibit-splash-screen t)
(set-default-coding-systems 'undecided-unix)

(defun now (&optional return-date-only) (interactive "P") (message (format-time-string (if return-date-only "%Y-%m-%d" "%Y-%m-%d %H:%M:%S"))))
(defun insert-timestamp (&optional return-date-only)
  "Insert date at current cursor position in current active buffer"
  (interactive "P") (insert (now return-date-only)))

(add-to-list 'load-path "~/.emacs.d")
(let ((system-name-el (concat "~/.emacs.d/system-name/" system-name ".el")))
  (when (file-exists-p system-name-el)
    (load-file system-name-el)))

