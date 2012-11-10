(add-to-list 'load-path "/home/user/.emacs.d/maxframe")
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)
(maximize-frame)

(tool-bar-mode 0)
(menu-bar-mode 0)
(setq inhibit-splash-screen 1)
(setq make-backup-files nil)
;(add-to-list 'load-path "/home/user/.emacs.d") ;(require 'real-auto-save)
;(add-hook 'muse-mode-hook 'turn-on-real-auto-save)
;(add-hook 'org-mode-hook 'turn-on-real-auto-save)
(setq auto-save-visited-file-name t)

(set-default-coding-systems 'undecided-unix)

(set-clipboard-coding-system 'utf-8)
(setq x-select-enable-clipboard t)
(setq visual-line-mode t)

(defun ime ()
  (interactive) (toggle-input-method))
(defun ime-jp ()
  (interactive) (set-input-method "japanese"))
(defun ime-zh ()
  (interactive) (set-input-method "chinese-py-b5"))

(defun note! ()
  (interactive)
  (find-file "/tmp/ramdisk/note/note.muse.gpg")
  (end-of-buffer))

(defun jp! ()
  (interactive)
  (find-file "/tmp/ramdisk/note/jp.muse.gpg")
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

(defun gg () (interactive) (beginning-of-buffer))
(defun G () (interactive) (end-of-buffer))


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
    (if (file-exists-p filename)
        (message "file already saved")
      (progn
        (with-temp-buffer
          (insert
           (format "** %s - %s\n" (now) (newsticker--title item))
           (newsticker--link item)
           "\n\n"
           (newsticker--desc item))
          (write-file filename t)
          (shell-command (concat "sqlite3 /media/mmc1/note/article-cache.db \"SELECT text FROM articletext WHERE url='"
                                 (newsticker--link item) "'\" >> " (replace-regexp-in-string " " "\\\\ " filename))))
    ))

    (when (yes-or-no-p "open article? ")
          ;; (shell-command (concat "python ~/dropbox-sync/rss/scraper.py '" filename "' '" (newsticker--link item) "'"))
          (find-file-other-frame filename)
          (rex-mode)
          )
))
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
(setq org-default-notes-file "/tmp/ramdisk/note/index.org.gpg")
(define-key global-map [(control kp-enter)] 'org-remember)
(define-key global-map (kbd "C-p") 'org-time-stamp)
(define-key global-map (kbd "<ESC> <up>") '(lambda () (interactive) (other-window -1)))
(define-key global-map (kbd "<ESC> <down>") 'other-window)

(setq org-remember-templates
 '(("Todo" ?t "* TODO %?\nAdded: %U" "/tmp/ramdisk/note/index.org.gpg" "N900")
   ;("Memo" ?m "* %?\nAdded: %U" "/media/mmc1/note/memo.org")
   ;("NK" ?n "* %U %?\n\n %i\n %a\n\n" "/media/mmc1/note/nikki.org" "ALL")
   ;("Idea" ?i "* %^{Title}\n%?\n  %a\n  %U" "/media/mmc1/note/idea.org" "N900")
   ))
(setq org-agenda-files (quote(;"/media/mmc1/note/idea.org"
                              "/tmp/ramdisk/note/index.org.gpg")))

(global-set-key [(shift backspace)] 'advertised-undo)
(global-set-key [(control z)] 'ignore)
;(global-set-key (kbd "<escape> <up>") '(lambda () (interactive) (other-window -1)))
;(global-set-key (kbd "<escape> <down>") 'other-window)

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

        ;; example call: ./setcal --cal N900 --name test --start  "2012-09-02 16:01:00" --alarm exact
	(start-process "setcalendar-process" "*Messages*" "/home/user/setcal"
		       "--cal"
		       ;; "N900"
		       "gcal"
		       "--name"
		       (format "%s" name)
		       "--start"
		       (format "%s %s" date tm-start)
		       "--alarm"
		       (format "%s" alarm))))))
(add-hook 'org-remember-mode-hook '(lambda () (visual-line-mode t)))
(add-hook 'org-remember-before-finalize-hook 'set-calendar-appt)



(defun newsticker-mind-brain-try-fetch-article-hook (feed item)
  "if FEED is `mind brain', attempt to cache the article content"
  (when (string= feed "mind brain")
  ;; attempt to cache the item
  (start-process "cache-article-process" "*Messages*" "/usr/bin/python" 
  		       "/media/mmc1/DropN900/sync/rss/cachearticle.py"
  		       (newsticker--link item))))
(add-hook 'newsticker-new-item-functions 'newsticker-mind-brain-try-fetch-article-hook)

;(find-file "/media/mmc1/DropN900/sync/rss/janitor.org")

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
