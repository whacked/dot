;;; my-utils.el --- Interactive utilities and editing helpers -*- lexical-binding: t -*-
;;
;; Misc interactive commands collected from util.el and config.org inline
;; sections.  Larger subsystems (org, completion) have dedicated modules.
;;
(require 'cl-lib)

;;; Text manipulation utilities

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

;; probably obviated by align-regexp()
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
    (while (search-forward "&lsquo;" nil t) (replace-match "'" nil t))

    (goto-char (point-min))
    (while (search-forward "&rsquo;" nil t) (replace-match "'" nil t))

    (goto-char (point-min))
    (while (search-forward "&ldquo;" nil t) (replace-match "\u201c" nil t))

    (goto-char (point-min))
    (while (search-forward "&rdquo;" nil t) (replace-match "\u201d" nil t))

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
    (while (search-forward "\u2018" nil t) (replace-match "'" nil t))

    (goto-char (point-min))
    (while (search-forward "\u2019" nil t) (replace-match "'" nil t))

    (goto-char (point-min))
    (while (search-forward "\u201c" nil t) (replace-match "\"" nil t))

    (goto-char (point-min))
    (while (search-forward "\u201d" nil t) (replace-match "\"" nil t))

    (goto-char (point-min))
    (while (search-forward "\u2212" nil t) (replace-match "-" nil t))

    (goto-char (point-min))
    (while (search-forward "\u2013" nil t) (replace-match "-" nil t))

    )
  )

(defun remove-all-text-properties-in-buffer ()
  ;; https://emacs.stackexchange.com/a/12527
  (interactive)
  (let ((inhibit-read-only t))
    (set-text-properties (point-min) (point-max) nil)))

(defun copy-path-of-current-file-to-clipboard ()
  (interactive)
  (kill-new buffer-file-name))

(defun copy-path-of-current-directory-to-clipboard ()
  (interactive)
  (kill-new default-directory))

;;; Text format conversion

(defun js->json ()
  (interactive)
  (shell-command-on-region (region-beginning)
                           (region-end)
                           "node -e 'console.log(JSON.stringify(eval(require(\"fs\").readFileSync(0, \"utf-8\"))))'"
                           (current-buffer)
                           t))

;;;; html to hiccup

(defun html->hiccup ()
  (interactive)
  (shell-command-on-region (region-beginning)
                           (region-end)
                           "bootleg -d -e '(html (slurp *in*) :data :hiccup-seq)'"
                           (current-buffer)
                           t))

;;; JSON/JSONL record editor (widget-based)
;; ref https://www.gnu.org/software/emacs/manual/html_node/elisp/Parsing-JSON.html
;; ref https://www.mssl.ucl.ac.uk/swift/om/sw/help/man/widget.html
(require 'widget)

;; (eval-when-compile
;;   (require 'wid-edit))

(defvar record-editor--buffer)
(defun jsonl-record-editor (source-json callback)
  ;; test value: "{\"Nul\": null, \"Int\": 9, \"Num\": 3.14, \"Str\": \"hello\\nlines\", \"Boo\": true, \"Arr\": [1, 2, \"d\"], \"Obj\": {\"f\": \"multi\\nline\\ntext\"}}"
  (switch-to-buffer "*Record Editor*")
  (kill-all-local-variables)
  (make-local-variable 'record-editor--buffer)

  (let ((inhibit-read-only t))
    (erase-buffer))

  ;; (widget-insert "Here is some documentation.\n")

  (setq record-editor--buffer (json-read-from-string source-json))
  (mapcar (lambda (pair)
            (let* ((key (car pair))
                           (value (cdr pair))
                           (emacs-value-type (type-of value))
                           (json-value-type (cond ((eq emacs-value-type 'hash-table) 'object)
                                                  ((eq emacs-value-type 'vector) 'array)
                                                  ((eq emacs-value-type 'float) 'number)
                                                  ((eq emacs-value-type 'integer) 'number)
                                                  ((eq emacs-value-type 'symbol)
                                                   (if (eq value nil) 'null
                                                     'boolean))
                                                  ((eq emacs-value-type 'string) 'string)))
                           (decoder
                            (cond ((eq json-value-type 'number) 'string-to-number)
                                  ((eq json-value-type 'string) 'identity)
                                  ((eq json-value-type 'boolean)
                                   (lambda (val)
                                     (if (string= val "true") t :json-false)))
                                  ((eq json-value-type 'null)
                                   (lambda (val)
                                     (if (string= val "null") nil val)))
                                  (t (lambda (val)
                                       ;; (message "decoding: <%s>%s: %s (%s)" json-value-type key val (type-of value))
                                       (json-read-from-string val))))))

              (widget-insert (format "[%07s] %s: " json-value-type key))

              (if (and (eq json-value-type 'string)
                       (s-contains? "\n" value))
                  (insert "\n"))

              (cond ((eq json-value-type 'boolean)
                     (let* ((serialized-boolean (if (eq value t)
                                                    "true" "false"))
                            (other-boolean (if (eq value t)
                                               "false" "true")))
                       (widget-insert "\n")
                       (widget-create 'radio-button-choice
                                      :indent 10
                                      :value serialized-boolean
                                      :notify (lambda (widget &rest ignore)
                                                (let ((new-value (widget-value widget)))
                                                  (message "You selected %s /// %s" new-value (string= new-value "true"))
                                                  (setcdr (assq key record-editor--buffer)
                                                          (if (string= new-value "true")
                                                              t
                                                            :json-false))))
                                      (list 'item serialized-boolean)
                                      (list 'item other-boolean))))
                    (t
                     (widget-create 'editable-field
                                    ;; :size 20
                                    :value (cond ((eq json-value-type 'string)
                                                  (s-replace "\\n" "\n" value))

                                                 ((eq json-value-type 'null)
                                                  "null")

                                                 (t
                                                  (json-encode value)))
                                    :notify (lambda (widget &rest ignore)
                                              (let ((new-value (widget-value widget)))
                                                (condition-case nil
                                                    (let* ((decoded-value (funcall decoder new-value)))
                                                      (when nil
                                                        (message "<%s>%s [%s]  --{%s}-->  %s" json-value-type key new-value decoder decoded-value)
                                                        ;; consider this if you do on-the-fly sanitation
                                                        ;; (widget-value-set widget (widget-value widget))

                                                        (when (eq json-value-type 'string)
                                                          (message "WE GOT STRING: ^%s$" new-value)
                                                          (message "DECODED: ^%s$" decoded-value)))

                                                      ;; (message "%s" (json-encode record-editor--buffer))
                                                      (setcdr (assq key record-editor--buffer) decoded-value))
                                                  (error nil)))))))))
          record-editor--buffer)

  (when nil

    ;; don't see a way to do this easily with keyboard. must use mouse on the tag?
    (widget-create 'menu-choice
                   :tag "Choose"
                   :value "This"
                   :help-echo "Choose me, please!"
                   :notify (lambda (widget &rest ignore)
                             (message "%s is a good choice!"
                                      (widget-value widget)))
                   '(item :tag "This option" :value "This")
                   '(choice-item "That option")
                   '(editable-field :menu-tag "No option" "Thus option"))

    (widget-insert "\n\nSelect multiple:\n\n")
    (widget-create 'checkbox t)
    (widget-insert " This\n")
    (widget-create 'checkbox nil)
    (widget-insert " That\n")
    (widget-create 'checkbox
                   :notify (lambda (&rest ignore) (message "Tickle"))
                   t)
    (widget-insert " Thus\n\nSelect one:\n\n"))

  (widget-insert "\n")
  (let* ((source-json source-json)
                 (callback callback)
                 (on-submit (lambda (&rest ignore)
                              (interactive)
                              (let ((rendered-json (json-encode record-editor--buffer)))
                                (kill-buffer)
                                (funcall callback rendered-json)))))
    (widget-create 'push-button
                   :notify (lambda (&rest ignore)
                             (jsonl-record-editor source-json callback))
                   "reset")

    (widget-insert " or ")
    (widget-insert "C-c C-c to ")
    (widget-create 'push-button :notify on-submit "SUBMIT")
    (widget-insert "\n")
    (use-local-map (copy-keymap widget-keymap))
    (local-set-key (kbd "C-c C-c") on-submit))
  ;; this function is what sets up the widget component styling (grey background color)
  ;; and :notify functions
  (widget-setup)
  (beginning-of-buffer))

(defun edit-jsonl-record ()
  "Create the widgets from the Widget manual."
  (interactive)
  (save-excursion
    (let* ((current-position (point))  ;; save-excursion not working as I thought it would
                   (beg (progn
                          (beginning-of-line)
                          (point)))
                   (end (progn
                          (end-of-line)
                          (point)))
                   (source-json
                    ;; (thing-at-point 'line t)
                    (buffer-substring beg end))
                   (maybe-json-data
                    (condition-case err
                        (json-read-from-string source-json)
                      (error err
                             (message "failed to parse json: %s" err)
                             nil))))
      (jsonl-record-editor
       source-json
       (lambda (rendered-json)
         (kill-region beg end)
         (insert rendered-json)
         (goto-char current-position))))))

;;; single-lineify — collapse region to one line and back
;; ref https://stackoverflow.com/a/14202425

(defun single-lineify ()
  (interactive)
  (save-excursion
    (let* ((beg (region-beginning))
           (end (region-end))
           (resulting-text
            (thread-last (buffer-substring-no-properties beg end)
              (s-trim)
              (s-replace "\n" "\\n"))))
      (kill-region beg end)
      (insert resulting-text))))

(defun de-single-lineify ()
  (interactive)
  (save-excursion
    (let* ((beg (region-beginning))
           (end (region-end))
           (resulting-text
            (thread-last
                (buffer-substring-no-properties beg end)
              (s-replace "\\n" "\n"))))
      (kill-region beg end)
      (insert resulting-text))))

;;; Highlight duplicate / repeated lines (requires ov package)
;; ref https://emacs.stackexchange.com/a/13122

(defun my-highlight-duplicate-lines-in-region (&optional show-all)
  ;; ref https://emacs.stackexchange.com/a/13122
  "optional = show all, otherwise don't highlight first occurences"
  (interactive "P")
  (when mark-active
    (let* (($beg (region-beginning))
           ($end (region-end))
           ($st (buffer-substring-no-properties
                 $beg $end))
           ($lines)
           $first-occurrence-with-dup
           $dup)
      (deactivate-mark t)
      (save-excursion
        (goto-char $beg)
        (while (< (point) $end)
          (let* (($b (point))
                 ($e (point-at-eol))
                 ($c (buffer-substring-no-properties $b $e))
                 ($a (assoc $c $lines)))
            (when (not (eq $b $e))
              (if $a
                  (progn
                    (setq $dup (cons $b $dup))
                    (if show-all
                        (setq $dup (cons (cdr $a) $dup))
                      (setq $first-occurrence-with-dup
                             (cons (cdr $a) $first-occurrence-with-dup))))
                (setq $lines
                      (cons (cons $c $b) $lines)))))
          (forward-line 1))
        (mapc (lambda ($p)
                (ov-set (ov-line $p) 'face '(:foreground "red")))
              (sort (delete-dups $dup) '<))
        (mapc (lambda ($p)
                (ov-set (ov-line $p) 'face '(:foreground "green")))
              $first-occurrence-with-dup)))))

(defun my-highlight-repeated-lines (&optional show-all)
  (interactive "P")
  "highlight lines if they are identical to the line above it"
  (when mark-active
    (let* (($beg (region-beginning))
           ($end (region-end))
           ($st (buffer-substring-no-properties
                 $beg $end))
           previous-line
           $same-as-previous-line)
      (deactivate-mark t)
      (save-excursion
        (goto-char $beg)
        (while (< (point) $end)
          (let* (($b (point))
                 ($e (point-at-eol))
                 ($c (buffer-substring-no-properties $b $e)))
            (when (and (not (eq $b $e))
                       (string= $c previous-line))
              (progn
                (setq $same-as-previous-line (cons $b $same-as-previous-line))))
            (setq previous-line $c))
          (forward-line 1))
        (mapc (lambda ($p)
                (ov-set (ov-line $p) 'face '(:foreground "red")))
              $same-as-previous-line)))))

(provide 'my-utils)
;;; my-utils.el ends here
