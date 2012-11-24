;; for sqlite
;; see http://mysite.verizon.net/mbcladwell/sqlite.html for technique
(defvar sql-sqlite-program "sqlite3")
(defvar sql-sqlite-process-buffer "*sqlite-process*"
  "*Name of the SQLITE process buffer.  This is where SQL commands are sent.")
(defvar sql-sqlite-output-buffer "*sqlite-output-buffer*"
  "Name of the buffer to which all SQLITE output is redirected.")

;; (apply 'make-comint "sqlite-process"  sql-sqlite-program  nil `(,sql-sqlite-db ))
;; (get-buffer-create sql-sqlite-output-buffer)
;; chomp is a utility that will remove whitespace from the results:
(defun sql-chomp (str)
  "Trim whitespace from string"
  (let ((s (if (symbolp str)(symbol-name str) str)))
    (save-excursion
      (while (and
              (not (null (string-match "^\\( \\|\f\\|\t\\|\n\\)" s)))
              (> (length s) (string-match "^\\( \\|\f\\|\t\\|\n\\)" s)))
        (setq s (replace-match "" t nil s)))
      (while (and
              (not (null (string-match "\\( \\|\f\\|\t\\|\n\\)$" s)))
              (> (length s) (string-match "\\( \\|\f\\|\t\\|\n\\)$" s)))
        (setq s (replace-match "" t nil s))))
    s))

(defun sqlite-query (sql-command &optional sqlite-process-buffer sqlite-output-buffer)
  (let* ((process-buffer (if sqlite-process-buffer sqlite-process-buffer
                           sql-sqlite-process-buffer ;; global
                           ))
         (output-buffer (if sqlite-output-buffer sqlite-output-buffer
                          sql-sqlite-output-buffer ;; global
                          )))
    (set-buffer output-buffer)      ;; Navigate to the output buffer.
    (erase-buffer)                             ;; Erase the contents of the output buffer, if any.
    (comint-redirect-send-command-to-process sql-command output-buffer (get-buffer-process process-buffer) nil)  ;; Send the sql-statement to SQLITE using the sqlite-process buffer
    (accept-process-output (get-buffer-process process-buffer) 1)  ;need to wait to obtain results
    
    (let*  ((begin (goto-char (point-min)))   ;; Switch back to the sqlite-output buffer and retrieve the results. One result row per line of the buffer. Extract each line as an element of the result list.
            (end (goto-char (point-max)))
            (num-lines (count-lines begin end))
            (counter 0)
            (results-rows ()))
      (goto-char (point-min))
      (while ( < counter num-lines)
        (setq results-rows (cons (sql-chomp (thing-at-point 'line)) results-rows))
        (forward-line)
        (setq counter (+ 1 counter)))
      (car `(,results-rows)))
    (replace-regexp-in-string "$" "|" (replace-regexp-in-string "^" "|" (buffer-string)))))
