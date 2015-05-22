(load-file "~/dot/emacs.d/custom/package-management.el")
(load-file "~/dot/emacs.d/custom/package-common.el")
(setq my-packages
      (append my-packages
       '(el-get package

         ;; provides describe-unbound-keys
         unbound

         deft
         muse

         ;; ESS
         ess
         
         fic-mode ;; to highlight TODO FIXME BUG etc
         )))


(load-file "~/dot/emacs.d/custom/coding.el")
(load-file "~/dot/emacs.d/custom/lispy-stuff.el")

(load-file "~/dot/emacs.d/custom/usual-environment.el")







(when
    (functionp 'set-scroll-bar-mode)
  (set-scroll-bar-mode 'right))


(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)




;;;;;;;;;;;;;;;;;;;;;;;
;; <org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'org-drill)

;;; org-mode with remember
;; (org-remember-insinuate)
(setq org-directory "~/note/org")
(setq org-default-notes-file (concat (file-name-as-directory org-directory) "index.org.gpg"))
;(define-key global-map "\C-cr" 'org-remember)


(define-key global-map "\M-\C-r" 'org-remember)
(setq org-remember-templates
 '(("Todo" ?t "* TODO %?\nAdded: %U" "~/note/org/todos.org" "Main")
   ("CNE" ?c "* TODO %?\nAdded: %U" "~/note/cne/cne.org" "All Todo")
   ("Nikki" ?n "* %U %?\n\n %i\n %a\n\n" "~/note/org/nikki.org" "ALL")
   ;; ("State" ?s "* %U %? " "~/note/org/state.org")
   ("Scholar" ?s "* %?\nadded: %U" "~/note/org/scholar.org")
   ("Vocab" ?v "* %U %^{Word}\n%?\n# -*- xkm-export -*-\n" "~/note/org/vocab.org")
   ("Idea" ?i "* %^{Title}\n%?\n  %a\n  %U" "~/note/org/idea.org" "Main")
   ;;("Music" ?m "- %? %U\n" "~/note/org/music.org" "good")
   ("learn" ?l "omi%?" "~/note/org/learn.org" "captured")
   ("mem" ?m "** %U    :drill:\n
    :PROPERTIES:
    :DATE_ADDED: %U
    :SOURCE_URL: %a
    :END:
\n%i%?" "~/note/org/learn.org" "captured")
   ("Dump" ?d "%?\n" "~/note/org/dump.org")))
(define-key global-map (kbd "<f12>") 'org-agenda)
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
             (tm-start (or time "00:00"))
             (alarm "5min")
             (name (save-excursion
                     (end-of-buffer)
                     (outline-previous-visible-heading 1)
                     (backward-char)
                     (when (re-search-forward org-complex-heading-regexp nil t)
                       (replace-regexp-in-string (concat "[[:space:]]*" org-ts-regexp "[[:space:]]*") "" (match-string 4))))))
        (start-process
         "kalarm-process" "*Messages*" "/usr/bin/kalarm" 
         "--color"
         "0x00FF00"
         "--time"
         (format "%s-%s" date tm-start)
         "--reminder"
         "0H5M"
         ;; doesn't work :(
         ;; "--play" "/usr/share/sounds/KDE-Im-Sms.ogg"
         "--beep"
         (format "%s" name))))))
(add-hook 'org-remember-mode-hook '(lambda () (visual-line-mode t)))
(add-hook 'org-remember-before-finalize-hook 'set-calendar-appt)

;;; attempt to use org-capture.
;;; remember's work flow is actually more pleasant.
;;; in single buffer visible phase, capture:
;;; 1. creates split buffer, gets selection
;;; 2. fills template in that buffer
;;; 3. completes capture in that buffer
;;; 4. restores original buffer
;;; this is identical to remember
;;; in split-buffer phase, capture:
;;; 1. opens selection window in non-focused buffer (good)
;;; 2. after get selection, fills template in focused buffer,
;;; i.e. it switches away from the window where the selection took place (bad)
;;; 3. when authoring buffer for capture is open, the previously
;;; focused buffer is again put in the split where the template
;;; selection screen came up (bad)
;;; 4. when finished, layout is restored (expected)
;;; the amount of attention shifting is pretty annoying
;;;
;;;;(define-key global-map "\M-\C-r" 'org-capture)
;;;(setq org-capture-templates
;;;      '(("t" "Todo" entry (file "~/note/org/todos.org" "Tasks")
;;;         "* TODO %?\nAdded: %U" :empty-lines 1)
;;;        ("c" "CNE-todo" entry ("~/note/cne/cne.org" "All Todo")
;;;         "* TODO [#%^{IMPORTANCE|B}] [%^{URGENCY|5}] %?\nAdded: %U")
;;;        ("n" "Nikki" entry (file+headline "~/note/org/nikki.org" "ALL")
;;;         "* %U %?\n\n %i\n %a\n\n" :empty-lines 1)
;;;        ("s" "State" entry (file "~/note/org/state.org")
;;;         "* %U %? " :empty-lines 1)
;;;        ("v" "Vocab" plain (file "~/note/org/vocab.org")
;;;         "** %U %^{Word}\n%?\n# -*- xkm-export -*-\n" :empty-lines 1)
;;;        ;; idea template used to be:
;;;        ;; "* %^{Title}\n%?\n  %a"
;;;        ;; but org-capture-fill-template calls (delete-other-windows)
;;;        ;; and maximizes the template-filling buffer
;;;        ;; which is pretty annoying. so simply stop using template prompts
;;;        ("i" "Idea" entry (file "~/note/org/idea.org")
;;;         "* %?\n  %a" :empty-lines 1)
;;;        ("d" "Dump" entry (file+datetree "~/note/org/dump.org")
;;;         "* %?\n%U\n" :empty-lines 1)))

(setq org-agenda-files (map 'list 'expand-file-name '("~/note/org/main.org"
                                                      "~/note/org/index.org.gpg"
                                                      ;; "~/note/cne/cne.org"
                                                      )))
;;;;;;;;;;;;;;;;;;;;;;;;
;; </org mode config> ;;
;;;;;;;;;;;;;;;;;;;;;;;;



;; thanks to http://kliketa.wordpress.com/2010/08/04/gtklook-browse-documentation-for-gtk-glib-and-gnome-inside-emacs/
;NEW;(require 'gtk-look)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium-browser")
;;(setq browse-url-browser-function
;; '(("file:.*/usr/share/doc/.*gtk.*-doc/.*" . w3m-browse-url)
;;   ("." . browse-url-firefox)))





;; ;; FIXME cider
;; ;; nrepl
;; ;; ref: https://github.com/kingtim/nrepl.el
;; (add-hook 'nrepl-interaction-mode-hook
;;           'nrepl-turn-on-eldoc-mode)
;; ;; Stop the error buffer from popping up while working in the REPL buffer:
;; (setq nrepl-popup-stacktraces nil)
;; ;; Make C-c C-z switch to the *nrepl* buffer in the current window:
;; (add-to-list 'same-window-buffer-names "*nrepl*") 
;; ;; If you have paredit installed you can enabled it like this:
;; (add-hook 'nrepl-interaction-mode 'paredit-mode)





;; ref: http://emacs-fu.blogspot.com/2009/11/showing-pop-ups.html
(defun djcb-popup (title msg &optional icon sound)
  "Show a popup if we're on X, or echo it otherwise; TITLE is the title
of the message, MSG is the context. Optionally, you can provide an ICON and
a sound to be played"

  (interactive)
  (if (eq window-system 'x)
      (shell-command (concat "notify-send "

                             (if icon (concat "-i " icon) "")
                             " '" title "' '" msg "'")))
  (when sound (shell-command
               (concat "mplayer -really-quiet " sound " 2> /dev/null"))))

;; the appointment notification facility
(setq
 appt-message-warning-time 10 ;; warn 10 min in advance
 appt-display-mode-line t     ;; show in the modeline
 appt-display-format 'window) ;; use our func
(appt-activate 1)              ;; active appt (appointment notification)
(display-time)                 ;; time display is required for this...
(setq appt-audible t)

;; our little façade-function for djcb-popup
(defun djcb-appt-display (min-to-app new-time msg)
  (djcb-popup (format "Appointment in %s minute(s)" min-to-app) msg 
              "/usr/share/icons/gnome/32x32/status/appointment-soon.png"
              "/usr/share/sounds/ubuntu/stereo/phone-incoming-call.ogg"))
(setq appt-disp-window-function (function djcb-appt-display))

(defun org-add-appt-after-save-hook ()
  (if ;(string= mode-name "Org")
      (member (buffer-file-name) org-agenda-files)
      (org-agenda-to-appt)))
(add-hook 'after-save-hook 'org-add-appt-after-save-hook)

 ;; update appt each time agenda opened
(add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)

(defun kiwon/merge-appt-time-msg-list (time-msg-list)
  "Merge time-msg-list's elements if they have the same time."
  (let* ((merged-time-msg-list (list)))
    (while time-msg-list
      (if (eq (car (caar time-msg-list)) (car (caar (cdr time-msg-list))))
          (setq time-msg-list
                (cons
                 (append
                  (list (car (car time-msg-list)) ; time
                        (concat (car (cdr (car time-msg-list))) " / "(car (cdr (car (cdr time-msg-list)))))) ; combined msg
                  (cdr (cdr (car time-msg-list)))) ; rest information
                 (nthcdr 2 time-msg-list)))
        (progn (add-to-list 'merged-time-msg-list (car time-msg-list) t)
               (setq time-msg-list (cdr time-msg-list)))))
    merged-time-msg-list))

(defun kiwon/org-agenda-to-appt ()
  (prog2
      (setq appt-time-msg-list nil)
      (org-agenda-to-appt)
    (setq appt-time-msg-list (kiwon/merge-appt-time-msg-list appt-time-msg-list))))

;; (add-hook 'org-finalize-agenda-hook (function kiwon/org-agenda-to-appt))



;; pymacs see http://pymacs.progiciels-bpi.ca/pymacs.html#installation
;; (load-file "~/dot/emacs.d/bundle/pymacs/pymacs.el")
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;;;; ledger
;; (load "ledger")

;;;; freex mode
;;
;;(setq pymacs-load-path '("~/dev/elisp/org-freex"))
;;(add-to-list 'load-path (expand-file-name "~/dev/elisp/org-freex/"))
;;(load-file "~/dev/elisp/org-freex/freex-conf.el")
;;;;;;(load-file "~/dev/elisp/org-freex/freex-mode.el")
;;;;(require 'freex-mode)


 



;; ;; google calendar interaction
;; ;; see http://article.gmane.org/gmane.emacs.orgmode/27214
;; (defadvice org-agenda-add-entry-to-org-agenda-diary-file 
;;   (after add-to-google-calendar)
;;   "Add a new Google calendar entry that mirrors the diary entry just created by org-mode."
;;   (let ((type (ad-get-arg 0))
;; 	(text (ad-get-arg 1))
;; 	(d1 (ad-get-arg 2))
;; 	(year1 (nth 2 d1))
;; 	(month1 (car d1))
;; 	(day1 (nth 1 d1))
;; 	(d2 (ad-get-arg 3))
;; 	entry dates)
;;     (if (or (not (eq type 'block)) (not d2))
;; 	(setq dates (format "%d-%02d-%02d" year1 month1 day1))
;;       (let ((year2 (nth 2 d2)) (month2 (car d2)) (day2 (nth 1 d2)) (repeats (-
;; (calendar-absolute-from-gregorian d1)
;; 									       (calendar-absolute-from-gregorian d2))))
;; 	(if (> repeats 0)
;; 	    (setq dates (format "%d-%02d-%02d every day for %d days" year1 month1 day1 (abs repeats)))
;; 	  (setq dates (format "%d-%02d-%02d every day for %d days" year1 month1 day1 (abs repeats))))
;; 	))
;;     (setq entry  (format "/usr/local/bin/google calendar add --cal org \"%s on %s\"" text dates))
;;     ;;(message entry)
;;     (if (not (string= "MYLAPTOPCOMPUTER" mail-host-address))
;; 	(shell-command entry)
;;       (let ((offline "~/note/org/org2google-buffer"))
;; 	(find-file offline)
;; 	(goto-char (point-max))
;; 	(insert (concat entry "\n"))
;; 	(save-buffer)
;; 	(kill-buffer (current-buffer))
;; 	(message "Plain text written to %s" offline)))))
;; (ad-activate 'org-agenda-add-entry-to-org-agenda-diary-file)



;; in case useful: http://jblevins.org/projects/deft/
;; Deft is an Emacs mode for quickly browsing, filtering, and editing directories of plain text notes, inspired by Notational Velocity.
(setq deft-extension "org")
(setq deft-directory "~/note/org/")
(setq deft-text-mode 'org-mode)

(load-file "~/dot/emacs.d/custom/sync.el")



(setq desktop-save-mode nil)
(desktop-change-dir "~/dot/emacs.d")

