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




(defun note! ()
  (interactive)
  (find-file "/external_sd/note/index.org.gpg")
  (end-of-buffer))

(defun jp! ()
  (interactive)
  (find-file "/external_sd/note/jp.muse.gpg")
  ;;(set-input-method "japanese")
  (end-of-buffer))

(when (display-graphic-p)
  (set-frame-size (selected-frame) 207 21)
  (set-frame-position (selected-frame) 0 0)
  (split-window-horizontally)
  (note!)
  (other-window 1)
  (jp!)
  (other-window 1))

(defun sync-note ()
  (start-process "sync" "*Messages*" "/bin/bash" (expand-file-name "~/sync.sh")))
(setq sync-interval-S (* 60 10))
(setq *sync-note-timer* (run-with-timer 0 sync-interval-S 'sync-note))
;; to cancel:
;; (cancel-timer *sync-note-timer*)
