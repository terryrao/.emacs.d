;;; init-org.el --- Org mode configurations -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :hook (org-mode . auto-fill-mode)
  :custom
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-confirm-babel-evaluate nil)
  (org-babel-load-languages '((shell . t)
                              (python . t)
                              (plantuml . t)
                              (ocaml . t)
                              (emacs-lisp . t))))

;; Pretty symbols
(use-package org-bullets
  :ensure t
  :hook (org-mode . org-bullets-mode))

(provide 'init-org)

;;; init-org.el ends here
