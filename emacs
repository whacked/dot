(setq inhibit-splash-screen t)
(set-default-coding-systems 'undecided-unix)

(defun now (&optional return-date-only) (interactive "P") (message (format-time-string (if return-date-only "%Y-%m-%d" "%Y-%m-%d %H:%M:%S"))))
(defun insert-timestamp (&optional return-date-only)
  "Insert date at current cursor position in current active buffer"
  (interactive "P") (insert (now return-date-only)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; <OS-specific command> ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setenv "PATH" (concat "/opt:/opt/local/bin:" (getenv "PATH")))
(cond ((eq system-type 'gnu/linux)
       (load-file "~/dot/.emacs.d/custom/gnu-linux.el"))
      ((eq system-type 'darwin)
       (load-file "~/dot/.emacs.d/custom/darwin.el"))
      ((eq system-type 'windows-nt)
       (load-file "~/dot/.emacs.d/custom/windows-nt.el"))
      (t (message "unknown system???")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; </OS-specific command> ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/dot/.emacs.d")
(let ((system-name-el (concat "~/dot/.emacs.d/system-name/" system-name ".el")))
  (when (file-exists-p system-name-el)
    (load-file system-name-el)))

