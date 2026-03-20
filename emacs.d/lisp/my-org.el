;;; my-org.el --- Org-mode configuration -*- lexical-binding: t -*-
;;
;; Covers so far: org bootstrap, org-logseq + fd-based link following.
;; Remaining org config (org-babel, org-conf, org-capture, faces) is
;; pending migration from config.org.

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

(provide 'my-org)
;;; my-org.el ends here
