(add-to-list 'load-path "/home/user/.emacs.d/maxframe")
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)
(maximize-frame)

(tool-bar-mode 0)
(menu-bar-mode 0)
(setq inhibit-splash-screen 1)

;(add-to-list 'load-path "/home/user/.emacs.d")
;(require 'real-auto-save)
;(add-hook 'muse-mode-hook 'turn-on-real-auto-save)
;(add-hook 'org-mode-hook 'turn-on-real-auto-save)
(setq auto-save-visited-file-name t)


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

(add-to-list 'load-path "/home/user/.emacs.d/muse-3.20/lisp")
(require 'muse-mode)
(add-to-list 'load-path "/media/mmc1/src/org-mode/lisp")
(add-to-list 'load-path "/media/mmc1/src/org-mode/contrib/lisp")
(require 'org)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (ruby . t)
   (perl . t)
   (emacs-lisp . t)
   (sh . t)))

(split-window-vertically)
(note!)
(muse-mode)
(other-window 1)
(jp!)
(muse-mode)
(other-window 1)


(defun now ()
  (interactive)
  (message (format-time-string "%Y-%m-%d %H:%M:%S")))
(defun insert-timestamp ()
  "Insert date at current cursor position in current active buffer"
  (interactive)
  (insert (now)))



(enlarge-window 6)

(setq newsticker-url-list
      '(("mind brain" "http://www.sciencedaily.com/rss/mind_brain.xml" nil nil nil)
       ))
(defadvice newsticker-save-item (around override-the-uninformative-default-save-format)
  (interactive)
  (let ((filename ;(read-string "Filename: "
                               (concat "~/dropbox-sync/rss/" feed "-"
				       (replace-regexp-in-string "'" ""
					       (replace-regexp-in-string "[^a-zA-Z0-9_ -]" "-"
						(newsticker--title item)))
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
 '(newsticker-automatically-mark-items-as-old nil)
 '(newsticker-enable-logo-manipulations nil)
 '(newsticker-obsolete-item-max-age 172800)
 '(newsticker-treeview-listwindow-height 5)
 '(newsticker-treeview-treewindow-width 12)
 '(newsticker-url-list-defaults nil))

(add-hook 'newsticker-treeview-list-mode-hook
	  '(lambda ()
	     (define-key newsticker-treeview-list-mode-map
	       (kbd ".") 'newsticker-treeview-save-item)))

(defun org-add-appt-after-save-hook ()
  (if (string= mode-name "Org") (org-agenda-to-appt)))
(add-hook 'after-save-hook 'org-add-appt-after-save-hook)
(appt-activate 1)

;;; org-mode with remember
(org-remember-insinuate)
(setq org-default-notes-file "/media/mmc1/note/todos.org")
(define-key global-map [(control kp-enter)] 'org-remember)
(define-key global-map (kbd "C-,") 'org-time-stamp)

(setq org-remember-templates                                                                                                                                                                      
 '(("Todo" ?t "* TODO %?\nAdded: %U" "/media/mmc1/note/todos.org" "Tasks")
   ("Memo" ?m "* %?\nAdded: %U" "/media/mmc1/note/memo.org")
   ("Idea" ?i "* %^{Title}\n%?\n  %a" "/media/mmc1/note/idea.org")))
(setq org-agenda-files (quote("/media/mmc1/note/idea.org"
                              "/media/mmc1/note/todos.org")))

(global-set-key [(shift backspace)] 'advertised-undo)
(global-set-key [(control z)] 'ignore)


(defalias 'yes-or-no-p 'y-or-n-p)


(defun set-calendar-appt ()
  (save-excursion
    (end-of-buffer)
    (outline-previous-visible-heading 1)
    (backward-char)
    (when (re-search-forward org-ts-regexp nil t)
      (let* ((spl-matched (split-string (match-string 1) " "))
	     (date (first spl-matched))
	     (time (if (= 3 (length spl-matched)) ;; contains time
		       (third spl-matched)
		     ;; only contains date
		     nil))
	     (tm-start (if time
			   (concat time ":00")
			 "00:00:00"))
	     (alarm "5min")
	     (name (save-excursion
		     (end-of-buffer)
		     (outline-previous-visible-heading 1)
		     (backward-char)
		     (when (re-search-forward org-complex-heading-regexp nil t)
		       (replace-regexp-in-string (concat "[[:space:]]*" org-ts-regexp "[[:space:]]*") "" (match-string 4))))))

	(start-process "setcalendar-process" "*Messages*" "/home/user/setcal" 
		       "--name"
		       (format "%s" name)
		       "--start"
		       (format "%s %s" date tm-start)
		       "--alarm"
		       (format "%s" alarm))))))
(add-hook 'org-remember-before-finalize-hook 'set-calendar-appt)
