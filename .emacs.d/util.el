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