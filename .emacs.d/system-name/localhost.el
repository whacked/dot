;; default hostname "localhost" for Ubuntu on Android images
(custom-set-variables
 '(menu-bar-mode nil)
 '(column-number-mode t)
 '(line-number-mode t)
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-window-setup (quote other-window))
 '(org-src-fontify-natively t)
 '(org-startup-folded (quote showeverything))
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(transient-mark-mode t))

(setq make-backup-files nil)
(setq auto-save-visited-file-name t)

(set-clipboard-coding-system 'utf-8)
(setq x-select-enable-clipboard t)
(setq visual-line-mode t)

(defalias 'yes-or-no-p 'y-or-n-p)

(load-file "~/.emacs.d/custom/package-management.el")
(setq my-packages
      '(el-get package
               ;; put el-get bundled packages here
               magit muse yaml-mode))
(el-get 'sync my-packages)



(defun ime ()
  (interactive) (toggle-input-method))
(defun ime-jp ()
  (interactive) (set-input-method "japanese"))
(defun ime-zh ()
  (interactive) (set-input-method "chinese-py-b5"))

(defun note! ()
  (interactive)
  (find-file "/external_sd/note/index.org.gpg")
  (end-of-buffer))

(defun jp! ()
  (interactive)
  (find-file "/external_sd/note/jp.muse.gpg")
  ;;(set-input-method "japanese")
  (end-of-buffer))

(setq default-frame-alist
      '((top . 0) (left . 0)
        (width . 207) (height . 21)))
(when (display-graphic-p)
  (set-frame-size (selected-frame) 207 21)
  (set-frame-position (selected-frame) 0 0)
  (split-window-horizontally)
  (note!)
  (other-window 1)
  (jp!)
  (other-window 1))

(global-auto-revert-mode t)
(defun sync-note ()
  (interactive)
  (let ((current-line (count-lines 1 (point))))
    (save-buffer)
    (message (format "syncing now: %s" (now)))
    (start-process "sync" "*Messages*" "/bin/bash" (expand-file-name "~/sync.sh"))
    (revert-buffer nil t)
    (show-all)
    (goto-line current-line)))
(setq sync-interval-S (* 60 10))
(setq *sync-note-timer* (run-with-idle-timer 0 sync-interval-S 'sync-note))
;; to cancel:
;; (cancel-timer *sync-note-timer*)











(org-remember-insinuate)
(setq org-default-notes-file "/external_sd/note/index.org.gpg")
(setq org-agenda-files (list org-default-notes-file))

;; customize keymapp
(setq x-alt-keysym 'meta) ;; fixes Alt key in VNC viewer
(global-set-key [(shift backspace)] 'undo)
(define-key global-map (kbd "C-.") 'org-remember)
(define-key global-map (kbd "C-c m") 'org-remember)

(setq org-remember-templates
 '(("Todo" ?t "* TODO %?\nAdded: %U from mobile" org-default-notes-file "Main")))


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
             (ampm (if (> 12 (string-to-int (substring tm-start 0 2))) "AM" "PM"))
             (alarm "5m")
             (name (save-excursion
                     (end-of-buffer)
                     (outline-previous-visible-heading 1)
                     (backward-char)
                     (when (re-search-forward org-complex-heading-regexp nil t)
                       (replace-regexp-in-string (concat "[[:space:]]*" org-ts-regexp "[[:space:]]*") "" (match-string 4))))))

        ;; example call: ./setcal --cal N900 --name test --start  "2012-09-02 16:01:00" --alarm exact
        (start-process "setcalendar-process" "*Messages*" "google" "calendar" "add"
                       (format "%s %s at %s %s" name date tm-start ampm)
                       "--reminder"
                       (format "%s" alarm))))))
(add-hook 'org-remember-mode-hook '(lambda () (visual-line-mode t)))
(add-hook 'org-remember-before-finalize-hook 'set-calendar-appt)

