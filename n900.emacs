(add-to-list 'load-path "/home/user/.emacs.d/maxframe")
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)
(maximize-frame)

(tool-bar-mode 0)
(menu-bar-mode 0)
(setq inhibit-splash-screen 1)

(set-clipboard-coding-system 'utf-8)
(setq x-select-enable-clipboard t)


(defun note! ()
  (interactive)
  (find-file "/media/mmc1/note/note.muse")
  (end-of-buffer))

(defun jp! ()
  (interactive)
  (find-file "/media/mmc1/note/jp.muse")
  (set-input-method "japanese")
  (end-of-buffer))

(split-window-vertically)
(note!)
(other-window 1)
(jp!)
(other-window 1)


(defun now ()
  (interactive)
  (message (format-time-string "%Y-%m-%d %H:%M:%S")))
(defun insert-timestamp ()
  "Insert date at current cursor position in current active buffer"
  (interactive)
  (insert (now)))



(enlarge-window 6)

(add-to-list 'load-path "/home/user/.emacs.d/muse-3.20/lisp")
(require 'muse-mode)
(muse-mode)

(setq newsticker-url-list
      '(("mind brain" "http://www.sciencedaily.com/rss/mind_brain.xml" nil nil nil)
       ))
(defadvice newsticker-save-item (around override-the-uninformative-default-save-format)
  (interactive)
  (let ((filename ;(read-string "Filename: "
                               (concat feed "-"
                                       (replace-regexp-in-string
                                        " " "_" (newsticker--title item))
                                       ".muse")));)
    (with-temp-buffer
      (insert
       (format "** %s - %s\n" (now) (newsticker--title item))
       (newsticker--link item)
       "\n\n"
       (newsticker--desc item))
      (write-file filename t))))
(ad-activate 'newsticker-save-item)

(defalias 'rss 'newsticker-show-news)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(newsticker-enable-logo-manipulations nil)
 '(newsticker-treeview-listwindow-height 5)
 '(newsticker-treeview-treewindow-width 12)
 '(newsticker-url-list-defaults nil))

(add-hook 'newsticker-treeview-list-mode-hook
	  '(lambda ()
	     (define-key newsticker-treeview-list-mode-map
	       (kbd ".") 'newsticker-treeview-save-item)))

