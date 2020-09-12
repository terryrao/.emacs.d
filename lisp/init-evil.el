;;; init-evil.el --- Bring vim back -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

(require 'init-core)

(use-package evil
  :ensure t
  :hook (after-init . evil-mode)
  :bind (:map evil-normal-state-map
         ("gs" . evil-avy-goto-char-timer)
         ("go" . evil-avy-goto-word-or-subword-1)
         ("gl" . evil-avy-goto-line))
  :config
  (evil-ex-define-cmd "q[uit]" 'kill-this-buffer)
  :custom
  ;; Switch to the new window after splitting
  (evil-split-window-below t)
  (evil-vsplit-window-right t)
  (evil-ex-complete-emacs-commands nil)
  (evil-ex-interactive-search-highlight 'selected-window)
  (evil-disable-insert-state-bindings t)
  (evil-insert-skip-empty-lines t)
  ;; j&k operate via visual line
  (evil-respect-visual-line-mode t)
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-want-fine-undo t)
  (evil-want-C-g-bindings t)
  (evil-want-Y-yank-to-eol t)
  (evil-want-abbrev-expand-on-insert-exit nil)
  (evil-symbol-word-search t))

(use-package evil-collection
  :ensure t
  :hook (evil-mode . evil-collection-init)
  :config
  ;; Disable `evil-collection' in certain modes
  (dolist (ig-mode '())
    (setq evil-collection-mode-list (remove ig-mode evil-collection-mode-list)))

  ;; Keybindings tweaks
  (evil-collection-define-key 'normal 'occur-mode-map
    ;; consistent with ivy
    (kbd "C-c C-e") 'occur-edit-mode)
  :custom
  (evil-collection-calendar-want-org-bindings t)
  (evil-collection-company-use-tng nil)
  (evil-collection-outline-bind-tab-p nil)
  (evil-collection-term-sync-state-and-mode-p nil)
  (evil-collection-setup-minibuffer nil)
  (evil-collection-setup-debugger-keys nil))

;; evil leader map
(use-package general
  :ensure t
  :after evil
  :config
  (general-create-definer leader-def
    :states 'normal
    :prefix "SPC"
    :keymaps 'override)

  (leader-def
    ;; file
    "f" '(:ignore t :which-key "file")
    "ff" 'find-file
    "fF" 'find-file-other-window
    "fj" 'counsel-fd-file-jump
    "fo" 'counsel-find-file-extern
    "fC" 'my/copy-current-file
    "fD" 'my/delete-current-file
    "fy" 'my/copy-current-filename
    "fR" 'my/rename-current-file
    "fr" 'counsel-recentf
    "fl" 'find-file-literally
    "fz" 'counsel-fzf

    ;; dired
    "d" '(:ignore t :which-key "file")
    "dd" 'counsel-fd-dired-jump
    "dj" 'dired-jump
    "dJ" 'dired-jump-other-window

    ;; buffer & bookmark
    "b" '(:ignore t :which-key "buffmark")
    "bb" 'switch-to-buffer
    "bB" 'switch-to-buffer-other-window
    "by" 'my/copy-current-buffer-name
    ;; --------------
    "bm" 'bookmark-set
    "bM" 'bookmark-set-no-overwrite
    "bi" 'bookmark-insert
    "br" 'bookmark-rename
    "bd" 'bookmark-delete
    "bw" 'bookmark-write
    "bj" 'bookmark-jump
    "bJ" 'bookmark-jump-other-window
    "bl" 'bookmark-bmenu-list
    "bs" 'bookmark-save

    ;; code
    "c" '(:ignore t :which-key "code")
    "cd" 'rmsbolt-compile
    "cc" 'compile
    "cC" 'recompile
    "cw" 'delete-trailing-whitespace
    "cx" 'quickrun

    ;; window
    "w" '(:keymap evil-window-map :which-key "window")
    "wx" 'kill-buffer-and-window
    "wu" 'my/transient-winner-undo
    "wg" 'my/transient-other-window-nav
    "w-" 'split-window-vertically
    "w/" 'split-window-horizontally

    ;; tab
    "t" '(:ignore t :which-key "tab")
    "tc" 'tab-bar-close-tab
    "ti" 'tab-switcher
    "tn" 'tab-bar-new-tab
    "to" 'tab-bar-close-other-tabs
    "tr" 'tab-bar-rename-tab-by-name
    "tt" 'tab-bar-select-tab-by-name
    "tu" 'tab-bar-undo-close-tab

    ;; search
    "s" '(:ignore t :which-key "search")
    "sa" 'swiper-all
    "sb" 'swiper
    "sg" 'counsel-rg
    "si" 'imenu
    "sj" 'evil-show-jumps
    "sr" 'evil-show-marks
    "ss" 'swiper-isearch
    "sS" 'swiper-isearch-thing-at-point
    "sw" 'my/lsp-ivy-workspace-symbol

    ;; insert
    "i" '(:ignore t :which-key "insert")
    "iq" 'quickurl-prefix-map
    "is" 'insert-mail-signature
    "it" 'insert-date-time

    ;; git
    "g" '(:ignore t :which-key "git")
    "gb" 'magit-branch-checkout
    "gB" 'magit-blame-addition
    "gc" 'magit-branch-and-checkout
    "gC" 'magit-commit-create
    "gd" 'magit-diff
    "gf" 'magit-find-file
    "gg" 'magit-status
    "gG" 'magit-status-here
    "gi" 'magit-init
    "gr" 'magit-rebase-interactive

    ;; project
    "p" '(:package projectile :keymap projectile-command-map :which-key "project")

    ;; app
    "a" '(:ignore t :which-key "app")
    "am" 'mu4e
    "ag" 'gnus
    "an" 'elfeed
    "ad" 'deft
    "ae" 'elpher
    "aj" 'jblog
    "aa" 'org-agenda
    "ac" 'org-capture
    "aC" 'calendar
    "al" 'org-store-link
    "at" 'org-todo-list

    ;; open
    "o" '(:ignore t :which-key "open")
    "ot" 'vterm
    "oT" 'vterm-other-window
    "oe" 'eshell
    "oE" 'my/eshell-other-window
    "os" (when (commandp 'osx-dictionary-search-word-at-point) 'osx-dictionary-search-word-at-point))

  (general-create-definer local-leader-def
    :states 'normal
    :prefix "SPC m")

  (local-leader-def
    :keymaps 'org-mode-map
    "." 'counsel-org-goto
    "/" 'counsel-org-goto-all
    "a" 'org-archive-subtree
    "d" 'org-deadline
    "e" 'org-set-effort
    "f" 'org-footnote-new
    "l" 'org-lint
    "p" 'org-set-property
    "q" 'org-set-tags-command
    "r" 'org-refile
    "s" 'org-schedule
    "t" 'org-todo
    "T" 'org-todo-list

    "c" '(:ignore t :which-key "clock")
    "cc" 'org-clock-in
    "cC" 'org-clock-out
    "cd" 'org-clock-mark-default-task
    "ce" 'org-clock-modify-effort-estimate
    "cE" 'org-set-effort
    "cg" 'org-clock-goto
    "cl" 'org-clock-in-last
    "cr" 'org-clock-report
    "cs" 'org-clock-display
    "cx" 'org-clock-cancel
    "c=" 'org-clock-timestamps-up
    "c-" 'org-clock-timestamps-down

    "i" '(:ignore t :which-key "insert")
    "id" 'org-insert-drawer
    "in" 'org-add-note)
  :custom
  (general-implicit-kbd t)
  (general-override-auto-enable t))

(use-package evil-surround
  :ensure t
  :hook (after-init . global-evil-surround-mode))

(use-package evil-magit
  :ensure t
  :after evil magit)

(provide 'init-evil)

;;; init-evil.el ends here
