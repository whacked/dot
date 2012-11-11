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

(set-frame-size (selected-frame) 207 21)
(set-frame-position (selected-frame) 0 0)
(defalias 'yes-or-no-p 'y-or-n-p)

(load-file "~/.emacs.d/custom/package-management.el")
(setq my-packages
      (append
       '(el-get package
         ;; put el-get bundled packages here
         magit yaml-mode
         windata tree-mode ;; required for dirtree
         )
       (mapcar 'el-get-source-name el-get-sources)))
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

(split-window-horizontally)
(note!)
(other-window 1)
(jp!)
(other-window 1)
