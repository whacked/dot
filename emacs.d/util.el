(defun sequential-insert-number ()
  (interactive)
  (let* ((beg (string-to-number (read-from-minibuffer "from? ")))
        (end (string-to-number (read-from-minibuffer "to? ")))
        (pref (read-from-minibuffer "prefix? "))
        (post (read-from-minibuffer "postfix? "))
        
        (cmp (if (< beg end)
                 (defun cmp (x y) (<= beg end))
                 (defun cmp (x y) (>= beg end))))
        (next (if (< beg end)
                 (defun next (x) (+ x 1))
                 (defun next (x) (- x 1)))))
    
    (while (cmp beg end)
      (setq str_num (format "%s%d%s" pref beg post))
      (insert str_num)
      (let ((len (length str_num)))
        (while (> len 0)
          (backward-char)
          (setq len (- len 1))
          ))
      (next-line)
      (setq beg (next beg)))))


(defun strtr ()
  (interactive)
  (let* ((str-fr (read-from-minibuffer "from characters? "))
         (str-to (read-from-minibuffer "to characters? "))

         (len-str-fr (length str-fr))
         (len-str-to (length str-to))

         (chr-escape "$")
         (chr-escape-escape (format "%s%s" chr-escape chr-escape))
         )

    (if (= len-str-fr len-str-to)
        (progn
          (message "replacing...")
          ; first escape all control chars in the text
          (beginning-of-buffer)
          (replace-string chr-escape chr-escape-escape)

          ; then escape all replace chars
          (setq ls-str (list str-fr str-to))
          (setq ls-source-buffer ())
          (while ls-str
            (let* ((str-cur (car ls-str))
                   (idx 0)
                   (end (length str-cur))
                   (is-target (= (length ls-str) 1))
                  )
              (while (< idx end)
                (beginning-of-buffer)
                (if is-target
                    (progn
                      (setq chr-source (car ls-source-buffer))
                      (setq chr-target (substring str-cur idx (+ idx 1)))
                      (setq ls-source-buffer (cdr ls-source-buffer))
                      (replace-string chr-source chr-target)
                      )
                  (progn
                    (setq chr-source (substring str-cur idx (+ idx 1)))
                    (setq chr-source-escaped (format "%s%s" chr-escape chr-source))
                    (setq ls-source-buffer (cons chr-source-escaped ls-source-buffer))
                    (replace-string chr-source chr-source-escaped)
                    )
                  )
                (setq idx (+ idx 1))
              )
              
              (setq ls-str (cdr ls-str))
              (setq ls-source-buffer (reverse ls-source-buffer))
              )
            )

          ; then translate all escaped replace chars
          (setq idx 0)
          (beginning-of-buffer)

          ; then de-escape the escape chars
          (beginning-of-buffer)
          (replace-string chr-escape-escape chr-escape)
          (setq ls-source-buffer ())
          )
      (message "NOT EQUAL LENGTH! BYE!")
      )
    )
  )


(if (eq system-type 'darwin)
    (defun maximize-window () 
      (interactive)
      (shell-command "sh <<EOF
osascript <<OSA 1> /dev/null 2> /dev/null &
set display_info to (do shell script \"system_profiler -detailLevel mini | grep -a 'Main Display:' -B 4 | grep -a 'Resolution:'\")

set ws to every word of display_info
set wc to the count of ws
set w2 to wc - 2

set screen_height to item wc of ws
set screen_width to item w2 of ws

tell application \"System Events\"
	set frontmostApplication to name of the first process whose frontmost is true
	set frontmostApplication to frontmostApplication as string
	tell process frontmostApplication
		tell window 1
			set position to {0, 20}
			set size to {screen_width, screen_height}
		end tell
	end tell
end tell
OSA
EOF
"))
  )



























(defun align-lines-to-expr (pbeg pend)
  "finds the first matching `expr` in the second to last lines in *region* and aligns them to the `expr` in the first line in the *region*"
  (interactive (list (point) (mark)))
  (unless (and pbeg pend)
    (error "The mark is not set now, so there is no region"))
  (save-excursion
    (let ((idx-reference nil)
          (expr (read-from-minibuffer "what character? "))
          (nowbuf (buffer-name))
          (beg (min pbeg pend))
          (end (max pbeg pend)))
      (goto-char beg)
      (while (< (point) end)
        (let* ((line-end (progn
                           (move-end-of-line 1)
                           (- (point) 1)))
               (line-beg (progn
                           (move-beginning-of-line 1)
                           (- (point) 1)))
               (string-to-match (substring (buffer-string) line-beg line-end))
               (idx-match (string-match expr string-to-match))
               )
          (setq idx-reference (or idx-reference idx-match))
          (unless (or (not idx-match)
                      (<= idx-reference idx-match))
            (move-to-column idx-match)
            (let ((need-to-pad (- idx-reference idx-match)))
              (setq end (+ end need-to-pad))
              (insert (format (format "%%%ds" need-to-pad) ""))))
          (next-line))))))



;; http://xahlee.org/emacs/elisp_replace_html_entities_command.html
(defun replace-html-chars-region (start end)
  "Replace some HTML entities in region …."
  (interactive "r")
  (save-restriction 
    (narrow-to-region start end)

    (goto-char (point-min))
    (while (search-forward "&lsquo;" nil t) (replace-match "‘" nil t))

    (goto-char (point-min))
    (while (search-forward "&rsquo;" nil t) (replace-match "’" nil t))

    (goto-char (point-min))
    (while (search-forward "&ldquo;" nil t) (replace-match "“" nil t))

    (goto-char (point-min))
    (while (search-forward "&rdquo;" nil t) (replace-match "”" nil t))

    (goto-char (point-min))
    (while (search-forward "&eacute;" nil t) (replace-match "é" nil t))
    ;; more here
    )
  )

(defun replace-entity-chars-region (start end)
  "Replace special chars with normal chars"
  (interactive "r")
  (save-restriction 
    (narrow-to-region start end)

    (goto-char (point-min))
    (while (search-forward "‘" nil t) (replace-match "'" nil t))

    (goto-char (point-min))
    (while (search-forward "’" nil t) (replace-match "'" nil t))

    (goto-char (point-min))
    (while (search-forward "“" nil t) (replace-match "\"" nil t))

    (goto-char (point-min))
    (while (search-forward "”" nil t) (replace-match "\"" nil t))

    (goto-char (point-min))
    (while (search-forward "−" nil t) (replace-match "-" nil t))

    (goto-char (point-min))
    (while (search-forward "–" nil t) (replace-match "-" nil t))

    )
  )


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
                                         (let* (
                                                ;; (headline-at-point (nth 4 (org-heading-components)))
                                                ;; (target-line-number (line-number-at-pos (org-find-exact-headline-in-buffer headline-at-point)))
                                                (target-line-number (line-number-at-pos))
                                                )
                                           (other-window 1)
                                           (goto-line target-line-number)
                                           (recenter-top-bottom 1)
                                           (other-window -1))))
            map)
  (set (make-local-variable 'base-buffer) (current-buffer))
  (set (make-local-variable 'navigation-buffer-name) (concat (buffer-name) "--<nav>"))
  (if org-navigate-mode
      (progn
        (set (make-local-variable 'navigation-buffer)
             (make-indirect-buffer base-buffer navigation-buffer-name))
        (split-window-horizontally)
        (other-window 1)
        (switch-to-buffer navigation-buffer)
        (org-mode)
        (show-all)
        (other-window -1)
        (org-content 4)
        (read-only-mode 1)
        (message "hello navigate mode"))
    (progn
      (kill-buffer (get-buffer navigation-buffer-name))
      (delete-window)
      (show-all)
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
      :success (function*
                (lambda (&key data &allow-other-keys)
                  (insert (format "%s" data))))))


    (destructuring-bind (key-to-retrieve postproc-fn query-string)
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
      (lexical-let* ((k2r key-to-retrieve)
                     (pfn postproc-fn)
                     (postfunc (function*
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
    (lexical-let* ((query-string input-query-string))
      ;; (concat WORLDCAT-BASE-URL
      ;;         (request--urlencode-alist
      ;;          `(("q" . ,query-string) ("count" . "1") ("wskey" . ,WORLDCAT-API-KEY))))
      (request
       (concat WORLDCAT-BASE-URL
               (request--urlencode-alist
                `(("q" . ,query-string) ("count" . "1") ("wskey" . ,WORLDCAT-API-KEY))))
       :type "GET"
       :parser (lambda () (libxml-parse-xml-region (point) (point-max)))
       :success (function*
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

;; elscreen
(require 'elscreen)
(load "elscreen" "ElScreen" t)
(global-set-key (kbd "s-_") 'elscreen-previous)
(global-set-key (kbd "s-+") 'elscreen-next)
(setq elscreen-display-tab nil)

;; google-this
;; (global-set-key (kbd "C-x g") 'google-this-mode-submap)
(define-key google-this-mode-submap "c" 'google-scholar-search)
(defun google-scholar-search (prefix)
  "search in google scholar"
  (interactive "P")
  (google-search prefix "http://scholar.google.com/scholar?hl=en&btnG=&as_sdt=1%%2C22&q=%s"))


(defun myembed ()
  "prototype embed buffer fn for editing #+INCLUDE files 'in-place'"
  (interactive)
  (when (save-excursion
        (beginning-of-line 1)
        (looking-at (concat
                     ;; take regexp from org.el:org-edit-special
                     "\\(?:#\\+\\(?:setupfile\\|include\\):?[ \t]+\"?\\|[ \t]*<include\\>.*?file=\"\\)\\([^\"\n>]+\\)"
                     ;; sloppily match :lines ### portion
                     ".+\\(?::lines[ \t]+\"\\)\\([0-9]*\\)-\\([0-9]*\\)")))
    (let* ((file-to-visit (org-trim (match-string 1)))
           (line-to-visit (string-to-number (match-string 2)))
           (new-window-height (max
                               (- (string-to-number (match-string 3))
                                  line-to-visit)
                               5))
           (cur-line-num (line-number-at-pos))
           (top-line-num (save-excursion
                           (move-to-window-line-top-bottom 0)
                           (line-number-at-pos)))
          (cur-window-height (window-height))
          )
      
      (split-window nil (+ 4 (- cur-line-num top-line-num)))
      (recenter-top-bottom -1)
      (other-window 1)
      (split-window nil new-window-height)
      (find-file file-to-visit)
      (other-window 1)
      (goto-line (+ cur-line-num 1))
      (recenter-top-bottom 0)
      (other-window -1)
      (goto-line line-to-visit)
      (recenter-top-bottom)
      )))
(global-set-key "\C-cE" 'myembed)