;;; my-org.el --- Org-mode configuration -*- lexical-binding: t -*-
;;
;; Covers: org bootstrap, org-logseq, org keybindings, org-capture,
;; org-conf, org faces, and org utility functions.
;;
(require 'cl-lib)

;;; Org bootstrap
;;
;; Pin org to the built-in so straight doesn't try to clone/build it
;; and potentially shadow the Emacs-bundled version.

(straight-override-recipe (cons 'org '(:type built-in)))
(use-package org)

;;; org-logseq — Logseq interop for org files
;; TODO: review, not using
(use-package org-logseq
  :after org
  :straight (:type git :host github :repo "llcc/org-logseq")
  :custom
  ;; my-cloudsync-note-dir is set in my-core.el from $CLOUDSYNC
  (org-logseq-dir my-cloudsync-note-dir))

(defun my/org-logseq-auto-enable ()
  "Enable `org-logseq-mode' when the buffer is inside `org-logseq-dir'."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (when (and file-name ; Ensure a file is being visited
               (boundp 'org-logseq-dir) ; Ensure the variable is defined
               org-logseq-dir ; Ensure the variable is non-nil
               (file-in-directory-p file-name org-logseq-dir))
	  ;; If all checks pass, enable the mode
      (org-logseq-mode 1))))

;; Add the function to the org-mode hook, so it runs every time an
;; Org file is opened or org-mode is entered.
(add-hook 'org-mode-hook #'my/org-logseq-auto-enable)

;; Override org-logseq-fd-query to search by filename in addition to
;; #+TITLE / #+ALIAS (the upstream version only does the latter).
(defun org-logseq-fd-query (page-or-id)
  "Return an fd command string to find PAGE-OR-ID in `org-logseq-dir'."
  (let ((type  (car page-or-id))
        (query (cdr page-or-id)))
    (format (pcase type
		      ;; note that it wants the line number
              ('page "fd \"%s\" %s | sed 's/$/:1/'"))
            query (shell-quote-argument org-logseq-dir))))

(defun org-logseq-open-link ()
  "Open link at point. Supports url, id and page.
  or Block Ref or Embed overlays."
  (interactive)
  (when-let* ((t-l (or (org-logseq-get-block-ref-or-embed-link)
                       (org-logseq-get-link)
                       (org-logseq-get-block-id))))
    (let ((type (car t-l))
          (link (cdr t-l)))
      (pcase type
        ('url  (browse-url link))
        ('draw (org-logseq-open-excalidraw link))
        (_     (let ((result (shell-command-to-string
                              (org-logseq-fd-query t-l))))
                 (when (string-prefix-p "grep" result)
                   (error "grep searching error"))
                 (if (string= result "")
                     (org-logseq-new-page link)
                   (let* ((f-n   (split-string result ":" nil))
                          (fname  (car f-n))
                          (lineno (string-to-number (cadr f-n))))
                     (org-open-file fname t lineno)))))))))

;;; Org keybindings
;;
;; this comment is migrated over from config.org. may be obsolete
;; If you are getting =Symbol's value as variable is void: org-babel-safe-header-args=
;; errors you can try =M-x org-reload= and re-init.

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key my-keys-minor-mode-map (kbd "M-_") 'org-metaleft)
(define-key my-keys-minor-mode-map (kbd "M-+") 'org-metaright)
(define-key global-map (kbd "<f9>") 'org-agenda)

;; this is from appointment notification. unclear if needed?
;; check config.org "the appointment notification facility"
(display-time)

;;; org-mouse

(require 'org-mouse)

;; OLD STUFF COULD BE OBSOLETE
;;; org capture
;;
;; see http://pages.sachachua.com/.emacs.d/Sacha.html#orgheadline56
;; http://doc.norang.ca/org-mode.html#Capture
;; http://orgmode.org/manual/Template-elements.html
;; http://orgmode.org/manual/Capture-templates.html#Capture-templates

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

;; TODO: probably delete
;; (require 'org-drill)

;;; org-mode with remember
;; (org-remember-insinuate)
(setq org-directory "~/note/org")
(setq org-default-notes-file (concat (file-name-as-directory org-directory) "index.org.gpg"))

;;(define-key global-map "\C-cr" 'org-remember)
;; (define-key global-map "\M-\C-r" 'org-remember)
(global-set-key (kbd "C-c c") 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
;; (setq org-capture-templates
;;       (quote (("t" "todo" entry (file "~/git/org/refile.org")
;;                "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
;;               ("r" "respond" entry (file "~/git/org/refile.org")
;;                "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
;;               ("n" "note" entry (file "~/git/org/refile.org")
;;                "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
;;               ("j" "Journal" entry (file+datetree "~/git/org/diary.org")
;;                "* %?\n%U\n" :clock-in t :clock-resume t)
;;               ("w" "org-protocol" entry (file "~/git/org/refile.org")
;;                "* TODO Review %c\n%U\n" :immediate-finish t)
;;               ("m" "Meeting" entry (file "~/git/org/refile.org")
;;                "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
;;               ("p" "Phone call" entry (file "~/git/org/refile.org")
;;                "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
;;               ("h" "Habit" entry (file "~/git/org/refile.org")
;;                "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; see http://orgmode.org/manual/Template-elements.html

(setq org-capture-templates
'(
  ;; ("t" "Todo" entry
  ;;  "~/note/org/todos.org"
  ;;  "* TODO %?\nAdded: %U" "Main")
  ;; ("c" "CNE" entry
  ;;   "~/note/cne/cne.org"
  ;;  "* TODO %?\nAdded: %U" "All Todo")
  ;; ("n" "Nikki" entry
  ;;   "~/note/org/nikki.org"
  ;;  "* %U %?\n\n %i\n %a\n\n" "ALL")
  ;; ;; ("State" ?s "* %U %? " "~/note/org/state.org")
  ;; ("s" "Scholar" entry
  ;;  "~/note/org/scholar.org"
  ;;  "* %?\nadded: %U")
  ;; ("v" "Vocab" entry
  ;;   "~/note/org/vocab.org"
  ;;  "* %U %^{Word}\n%?\n# -*- xkm-export -*-\n")
  ;; ("i" "Idea" entry
  ;;       "~/note/org/idea.org"
  ;;      "* %^{Title}\n%?\n  %a\n  %U" "Main")
  ;;     ;;("Music" ?m "- %? %U\n" "~/note/org/music.org" "good")
  ;;     ("l" "learn" entry
  ;;      "omi%?" "~/note/org/learn.org" "captured")
  ;;     ("m" "mem" "** %U    :drill:\n
  ;;     :PROPERTIES:
  ;;     :DATE_ADDED: %U
  ;;     :SOURCE_URL: %a
  ;;     :END:
  ;; \n%i%?" "~/note/org/learn.org" "captured")
  ("d" "Dump" entry
   (file+headline "~/note/org/dump.org" "test")
   )
  ))

;;; Timestamps in org babel code blocks
;; https://emacs.stackexchange.com/a/35904

(defadvice org-babel-execute-src-block (after org-babel-record-execute-timestamp)
  (let ((code-block-params (nth 2 (org-babel-get-src-block-info)))
        (code-block-name (nth 4 (org-babel-get-src-block-info))))
    (let ((timestamp (cdr (assoc :timestamp code-block-params)))
          (result-params (assoc :result-params code-block-params)))
      (if (and (equal timestamp "t") (> (length code-block-name) 0))
          (save-excursion
            (search-forward-regexp (concat "#\\+RESULTS\\(\\[.*\\]\\)?: "
                                           code-block-name))
            (beginning-of-line)
            (search-forward "RESULTS")
            (kill-line)
            (insert (concat (format-time-string "[%F %r]: ") code-block-name)))
        (if (equal timestamp "t")
            (message (concat "Result timestamping requires a #+NAME: "
                             "and a ':results output' argument.")))))))
(ad-activate 'org-babel-execute-src-block)

;;; org-mode conf
;; ref https://zzamboni.org/post/beautifying-org-mode-in-emacs/

(setq org-agenda-restore-windows-after-quit t
      org-catch-invisible-edits "show"
      org-agenda-window-setup (quote other-window)
      org-drill-optimal-factor-matrix (quote ((2 (2.6 . 2.6) (2.7 . 2.691)) (1 (2.6 . 4.14) (2.36 . 3.86) (2.1799999999999997 . 3.72) (1.96 . 3.58) (1.7000000000000002 . 3.44) (2.5 . 4.0))))
      org-file-apps (quote ((auto-mode . emacs) ("\\.mm\\'" . default) ("\\.x?html?\\'" . default) ("\\.xoj\\'" . "xournal %s") ("\\.pdf\\'" . "evince %s")))
      org-modules (quote (org-bbdb org-bibtex org-gnus org-info
                                   ;; deprecate, causes problems now
                                   ;; org-jsinfo
                                   org-habit org-irc org-mew org-mhe org-rmail org-vm org-wl org-w3m
                                   ;; inclusion of this seems to cause problems with using
                                   ;; load-theme-buffer-local (but! not color-theme-buffer-local)
                                   ;; org-drill
                                   org-docview))
      org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-startup-folded (quote showeverything)
      org-ellipsis "⤵"
      ;; FIXME this probably doesn't work as expected
      org-startup-folded nil
      org-export-coding-system 'utf-8)

;;; org-babel language support

;; jupyter must be loaded before org-babel-do-load-languages so that
;; ob-jupyter registers itself and the (jupyter . t) entry works.
(require 'jupyter)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((R          . t)
   (python     . t)
   (ledger     . t)
   (jupyter    . t)
   (C          . t)
   (lua        . t)
   (emacs-lisp . t)
   (ruby       . t)
   (shell      . t)
   (clojure    . t)
   (lisp       . t)
   (haskell    . t)
   (dot        . t)
   (perl       . t)
   ;; (matlab  . t)  ; uncomment if using MATLAB instead of Octave
   (octave     . t)
   (org        . t)
   (latex      . t)
   (ditaa      . t)
   (sqlite     . t)))

;; ref https://zzamboni.org/post/beautifying-org-mode-in-emacs/
(when window-system
  (let* ((variable-tuple
          (cond ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                ((x-list-fonts "Inconsolata")     '(:font "Inconsolata"))
                (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
         (base-font-color     (face-foreground 'default nil 'default))
         (headline           `(:inherit default :inverse-video t :weight bold :foreground ,base-font-color)))

    (custom-theme-set-faces
     'user
     `(org-level-1 ((t (,@headline ,@variable-tuple :height 2.2 :foreground "brown"   :background "white"))))
     `(org-level-2 ((t (,@headline ,@variable-tuple :height 2.0 :foreground "red"     :background "white"))))
     `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.8 :foreground "orange"  :background "black"))))
     `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.6 :foreground "yellow3" :background "white"))))
     `(org-level-5 ((t (,@headline ,@variable-tuple :height 1.4 :foreground "green4"  :background "white"))))
     `(org-level-6 ((t (,@headline ,@variable-tuple :height 1.2 :foreground "blue"    :background "white"))))
     `(org-level-7 ((t (,@headline ,@variable-tuple))))
     `(org-level-8 ((t (,@headline ,@variable-tuple))))
     `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))
     '(table-cell ((t (:background "#DD8" :foreground "gray50" :inverse-video nil))))
     '(table-cell-face ((((class color)) (:background "#AA3" :foreground "gray90")))))))

;;; org-log-done

(setq org-log-done t)

;;; Special links

(require 'ol-eww)  ;; [[eww:...]]

;;; org screenshot
;; ref: http://emacsworld.blogspot.com/2011/05/automatic-screenshot-insertion-in-org.html

(defun org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the same directory as the org-buffer and insert a link to this file."
  (interactive)
  (let* ((png-filepath (concat
                        default-directory
                        "img/screenshot/"
                        (format-time-string "%Y-%m-%d_%H%M%S_")
                        (buffer-name) ".png"))
         (base-dir (file-name-directory png-filepath)))
    (unless (file-exists-p base-dir)
      (make-directory base-dir t))
    ;; -s  select window
    ;; -u  use the focused window
    (call-process "scrot" nil nil nil "-u" png-filepath)
    (insert (concat "[[" png-filepath "]]"))
    ;;(org-display-inline-images)
  ))


;; see http://nullprogram.com/blog/2013/02/06/
;; also see http://stackoverflow.com/questions/12915528/easier-outline-navigation-in-emacs
(defun org-navigate-mode--get-nav-buffer-name ()
  (concat (buffer-name) "--<nav>"))
(define-minor-mode org-navigate-mode
  "quick way to nagivate org files via indirect buffer"
  :lighter "my-onav"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "n") 'outline-next-visible-heading)
            (define-key map (kbd "p") 'outline-previous-visible-heading)
            (define-key map (kbd "j") 'outline-next-visible-heading)
            (define-key map (kbd "k") 'outline-previous-visible-heading)
            (define-key map (kbd "l") '(lambda ()
                                         (interactive)
                                         (let* ((nowbuf (current-buffer))
                                                ;; (headline-at-point (nth 4 (org-heading-components)))
                                                ;; (target-line-number (line-number-at-pos (org-find-exact-headline-in-buffer headline-at-point)))
                                                (target-line-number (line-number-at-pos))
                                                )
                                           (switch-to-buffer-other-window navigation-buffer)
                                           (goto-line target-line-number)
                                           (recenter-top-bottom 1)
                                           (switch-to-buffer-other-window nowbuf))))
            (define-key map (kbd "RET") '(lambda ()
                                           (interactive)
                                           (let ((target-line-number (line-number-at-pos)))
                                             (switch-to-buffer-other-window navigation-buffer)
                                             (goto-line target-line-number)
                                             (recenter-top-bottom 1))))
            map)
  (set (make-local-variable 'base-buffer) (current-buffer))
  (set (make-local-variable 'navigation-buffer-name) (org-navigate-mode--get-nav-buffer-name))
  (if org-navigate-mode
      (progn
        (set (make-local-variable 'navigation-buffer)
             (make-indirect-buffer base-buffer navigation-buffer-name))
        (split-window-horizontally)
        (other-window 1)
        (switch-to-buffer navigation-buffer)
        (org-mode)
        (outline-show-all)
        (other-window -1)
        (org-content 4)
        (read-only-mode 1)
        (message "hello navigate mode"))
    (progn
      (kill-buffer (get-buffer navigation-buffer-name))
      (delete-window)
      (outline-show-all)
      (read-only-mode 0)
      (message "bye navigate mode"))))

(defun sconvert--dxdoi-to-org (input-string)
  "convert http://dx.doi.org/blah to org-style doi:blah"
  (concat "doi:" (replace-regexp-in-string "http://dx.doi.org/" "" input-string)))

(defun org-resolve-citation (&optional input-query-string)
  (interactive)
  ;; (require 'json)
  ;; (require 'request)

  (let ((CROSSREF-URI "http://search.labs.crossref.org")
        ;; http://stackoverflow.com/questions/27910/finding-a-doi-in-a-document-or-page
        (re-doi     "\\b\\(10\\.[0-9]\\{3,\\}\\/[^[:space:]]+\\)\\b")
        ;; see calibre-mode.el for re-citekey regexp logic
        (re-citekey "\\b\\([^ :;,.]+?\\)\\(?:etal\\)?\\([[:digit:]]\\\{4\\\}\\)\\(.*?\\)\\b")
        (default-query-string (sentence-at-point)))

    (if (null input-query-string)
        (setq input-query-string
              (cond (mark-active
                     (buffer-substring (region-beginning) (region-end)))
                    ((string-match re-doi default-query-string)
                     (match-string 1 default-query-string))
                    (t
                     (read-string (format "search string: ") nil nil nil)))))
    ;; (message (format "%s" input-query-string))

    (quote
     ;; Match many free-form citations to DOIs.
     ;; Resolve citations to DOIs by POSTing a JSON list of free-form citations to this route.
     (request
      (concat CROSSREF-URI "/links")
      :type "POST"
      :parser 'buffer-string
      :data (json-encode (list
                          "M. Henrion, D. J. Mortlock, D. J. Hand, and A. Gandy, \"A Bayesian approach to star-galaxy classification,\" Monthly Notices of the Royal Astronomical Society, vol. 412, no. 4, pp. 2286-2302, Apr. 2011."
                          "Renear 2012"
                          ))
      ;; Be sure to mark the request's content type as JSON by specifying a Content-Type header in the request:
      ;; Content-Type: application/json
      :headers '(("Content-Type" . "application/json"))
      ;; Citations must contain at least three words, those with less will not match. Citations with a low match score will be returned without a potential match. Here's a sample response:
      :success (cl-function
                (lambda (&key data &allow-other-keys)
                  (insert (format "%s" data))))))


    (cl-destructuring-bind (key-to-retrieve postproc-fn query-string)
        (cond ((string-match re-doi input-query-string)
               (list 'title ;; 'fullCitation
                     (lambda (ttl) (concat "/" ttl "/"))
                     (match-string 0 input-query-string)))
              ((string-match re-citekey input-query-string)
               (list 'doi
                     'sconvert--dxdoi-to-org
                     (mapconcat
                      'identity
                      (list
                       (match-string 1 input-query-string)
                       (match-string 2 input-query-string)
                       (match-string 3 input-query-string))
                      " ")))
              (t
               (list 'doi 'sconvert--dxdoi-to-org input-query-string)))

      ;; need to re-bind into lexical scope
      (let* ((k2r key-to-retrieve)
                     (pfn postproc-fn)
                     (postfunc (cl-function
                                (lambda (&key data &allow-other-keys)
                                  ;; (message (format "%s" k2r))
                                  (deactivate-mark)
                                  (let ((res (elt data 0)))
                                    (message (format "%s\n\n'%s' copied to clipboard"
                                                     (cdr (assoc 'fullCitation res))
                                                     ;; (cdr (assoc 'title res))
                                                     ;; (cdr (assoc 'doi res))
                                                     (kill-new (format "%s" (funcall pfn (cdr (assoc k2r res))))))))))))
        (request
         (concat CROSSREF-URI "/dois" "?"
                 (request--urlencode-alist
                  `(("q" . ,query-string) ("page" . "1") ("rows" . "1"))))
         :parser 'json-read ;; 'buffer-string
         :success postfunc)))))

(global-set-key "\C-cR" 'org-resolve-citation)

;; see "../api.el" and "org-isbn.el"
(defun org-resolve-isbn (&optional input-query-string)
  (interactive)
  (let ((WORLDCAT-BASE-URL "http://www.worldcat.org/webservices/catalog/search/opensearch?"))
    (if (null input-query-string)
        (setq input-query-string
              (cond (mark-active
                     (buffer-substring (region-beginning) (region-end)))
                    (t
                     (read-string (format "search string: ") nil nil nil)))))
    (let* ((query-string input-query-string))
      ;; (concat WORLDCAT-BASE-URL
      ;;         (request--urlencode-alist
      ;;          `(("q" . ,query-string) ("count" . "1") ("wskey" . ,WORLDCAT-API-KEY))))
      (request
       (concat WORLDCAT-BASE-URL
               (request--urlencode-alist
                `(("q" . ,query-string) ("count" . "1") ("wskey" . ,WORLDCAT-API-KEY))))
       :type "GET"
       :parser (lambda () (libxml-parse-xml-region (point) (point-max)))
       :success (cl-function
                 (lambda (&key data &allow-other-keys)
                   (let ((get (lambda (node &rest names)
                                (if names
                                    (apply get
                                           (first (xml-get-children
                                                   node (car names)))
                                           (cdr names))
                                  (first (xml-node-children node))))))
                     (if (funcall get data 'entry 'identifier)
                         (let ((res (format "isbn:%s /%s/\n"
                                            (car (last (split-string (funcall get data 'entry 'identifier) ":")))
                                            ;; (funcall get data 'entry 'author 'name)
                                            (funcall get data 'entry 'title))))
                           (message (kill-new res)))
                       (message "no result")))))))))
(global-set-key "\C-cI" 'org-resolve-isbn)


;; http://stackoverflow.com/questions/15328515/iso-transclusion-in-emacs-org-mode
;; http://stackoverflow.com/a/15352203
(defun org-dblock-write:transclusion (params)
  (progn
    (with-temp-buffer
      (insert-file-contents (plist-get params :filename))
      (let ((range-start (or (plist-get params :min) (line-number-at-pos (point-min))))
            (range-end (or (plist-get params :max) (line-number-at-pos (point-max)))))
        (copy-region-as-kill (line-beginning-position range-start)
                             (line-end-position range-end))))
    (yank)))


;; http://stackoverflow.com/questions/10729639/organizing-notes-with-tags-in-org-mode
(defun org-tag-match-context (&optional todo-only match)
  "Identical search to `org-match-sparse-tree', but shows the content of the matches."
  (interactive "P")
  (org-agenda-prepare-buffers (list (current-buffer)))
  (org-overview)
  (org-remove-occur-highlights)
  (org-scan-tags '(progn (org-show-entry)
                         (org-show-context))
                 (cdr (org-make-tags-matcher match)) todo-only))


;; ref http://stackoverflow.com/questions/6050033/elegant-way-to-count-items
;; least dependency and easiest to get working version (Eli Barzilay)
(defun frequencies (list &optional test key)
  (let* ((test (or test #'equal))
         (h (make-hash-table :test test)))
    (dolist (x list)
      (let ((key (if key (funcall key x) x)))
        (puthash key (1+ (gethash key h 0)) h)))
    (let ((r nil))
      (maphash #'(lambda (k v) (push (cons k v) r)) h)
      (sort r #'(lambda (x y) (< (cdr x) (cdr y)))))))

;; ref http://stackoverflow.com/questions/24330980/enumerate-all-tags-in-org-mode
(defun org-get-tag-histogram ()
  (interactive)
  (let ((all-tags '()))
    (org-map-entries
     (lambda ()
       (let ((tag-string (car (last (org-heading-components)))))
         (when tag-string
           (setq all-tags
                 (append all-tags (split-string tag-string ":" t)))))))
    (let ((histogram (frequencies all-tags)))
      (when (called-interactively-p 'any)
        (message
         (let ((longest-keylen (apply 'max
                                      (mapcar (function (lambda (pair)
                                                          (length (car pair)))) histogram))))
           (mapconcat
            (function (lambda (pair)
                        (format "%s  %s"
                                (car pair)
                                (format
                                 (format "%%%dd" (1+ (- longest-keylen (length (car pair)))))
                                 (cdr pair))
                                )))
            histogram
            "\n"))))
      histogram)))

(provide 'my-org)
;;; my-org.el ends here
