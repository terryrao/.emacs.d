;;; init-git.el --- Git is awesome -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

;; The awesome git client
(use-package magit
  :ensure t
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch)
         ;; Close transient with ESC
         :map transient-map
         ([escape] . transient-quit-one))
  :custom
  (magit-diff-refine-hunk t)
  (magit-status-margin '(t "%Y-%m-%d %H:%M " magit-log-margin-width t 18)))

;; Todo integration
(use-package magit-todos
  :ensure t
  :bind (:map magit-todos-section-map
         ("j" . nil)
         :map magit-todos-item-section-map
         ("j" . nil))
  :hook (magit-status-mode . magit-todos-mode)
  :config
  ;; Supress the `jT' keybind warning
  (advice-add 'magit-todos-mode :around (lambda (orig-fun &rest args)
                                          (ignore-error (apply orig-fun args)))))

;; Dont display empty groups
(use-package ibuffer
  :ensure nil
  :custom
  (ibuffer-show-empty-filter-groups nil))

;; Group buffers by git/svn/... project
(use-package ibuffer-vc
  :ensure t
  :commands (ibuffer-do-sort-by-alphabetic)
  :hook (ibuffer . (lambda ()
                     (ibuffer-vc-set-filter-groups-by-vc-root)
                     (unless (eq ibuffer-sorting-mode 'alphabetic)
                       (ibuffer-do-sort-by-alphabetic)))))

(use-package vc
  :ensure nil
  :custom
  (vc-handled-backends '(Git)))

;; Highlight uncommitted changes using git
(use-package diff-hl
  :ensure t
  :hook ((prog-mode . (lambda ()
                        (diff-hl-mode)
                        (diff-hl-flydiff-mode)
                        (diff-hl-margin-mode)))
         (magit-post-refresh . diff-hl-magit-post-refresh)
         (dired-mode . diff-hl-dired-mode-unless-remote)))

;; Git related modes
(use-package gitattributes-mode :ensure t)
(use-package gitconfig-mode :ensure t)
(use-package gitignore-mode :ensure t)

;; Open current file in browser
(use-package browse-at-remote
  :ensure t
  :bind (:map vc-prefix-map
         ("b" . bar-browse)
         ("c" . bar-to-clipboard)))

;; Pop up last commit information of current line
(use-package git-messenger
  :ensure t
  :bind (:map vc-prefix-map
         ("p" . git-messenger:popup-message)
         :map git-messenger-map
         ("m" . git-messenger:copy-message))
  :custom
  (git-messenger:show-detail t)
  (git-messenger:use-magit-popup t))

(provide 'init-git)

;;; init-git.el ends here
