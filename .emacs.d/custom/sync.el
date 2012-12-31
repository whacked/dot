(defun sync-note! ()
  (interactive)
  (let ((current-line (count-lines 1 (point)))
        (cur-buf (current-buffer))
        (file-list (list "index.org.gpg" "jp.muse.gpg")))
    (let ((presave-list file-list))
      (while presave-list
        (when (get-buffer (car presave-list))
          (switch-to-buffer (car presave-list))
          (save-buffer))
        (setq presave-list (cdr presave-list))))

    (message (format "syncing now: %s" (now)))

    (cond ((string= system-name "natto-tp")
           ;; (start-process "sync-linode" "*Messages*" "/bin/bash" "sync-linode.sh")
           (call-process "/bin/bash" "sync-linode.sh"))
          ((string= system-name "Nokia-N900")
           ;; (start-process "sync-linode" "*Messages*" "/bin/sh" "/media/mmc1/mod/syncnote.sh")
           (call-process "/bin/sh" "/media/mmc1/mod/syncnote.sh"))
          ((string= system-name "localhost")
           (start-process "sync" "*Messages*" "/bin/bash" (expand-file-name "~/sync.sh"))))

    (let ((postsave-list file-list))
      (while postsave-list
        (when (get-buffer (car postsave-list))
          (switch-to-buffer (car postsave-list))
          (revert-buffer nil t)
          (show-all))
        (setq postsave-list (cdr postsave-list))))
    
    (switch-to-buffer cur-buf)
    (goto-line current-line)))

(setq sync-interval-S (* 60 10))
(defun *sync-note-repeater* ()
 (sync-note!)
 (run-with-idle-timer (time-add (seconds-to-time sync-interval-S) (current-idle-time)) nil '*sync-note-repeater*))

(defun start-sync ()
  (interactive)
  (setq *sync-note-timer* (run-with-idle-timer sync-interval-S t '*sync-note-repeater*)))

;; to cancel:
(defun stop-sync ()
  (interactive)
  (cancel-timer *sync-note-timer*))

