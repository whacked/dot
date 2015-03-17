;; ref http://orgmode.org/manual/Adding-hyperlink-types.html#Adding-hyperlink-types
(require 'org)

(org-add-link-type "isbn" 'org-isbn-open)

(defun org-isbn-open (isbn)
  "Visit the manpage on PATH.
     PATH should be a topic that can be thrown at the man command."
  (browse-url (concat "https://duckduckgo.com/?q=%5C"
                      "amazon+isbn+"
                      ;; "google+books+isbn+"
                      isbn)))

(org-add-link-type "pmid" 'org-pmid-open)

(defun org-pmid-open (pmid)
  "Visit the manpage on PATH.
     PATH should be a topic that can be thrown at the man command."
  (browse-url (concat "http://www.ncbi.nlm.nih.gov/pubmed/" pmid)))

(org-add-link-type "oclc" 'org-oclc-open)

(defun org-oclc-open (oclcnum)
  "Visit the manpage on PATH.
     PATH should be a topic that can be thrown at the man command."
  (browse-url (concat "http://xisbn.worldcat.org/webservices/xid/oclcnum/"
                      oclcnum
                      "?method=getMetadata&format=json&fl=*")))
