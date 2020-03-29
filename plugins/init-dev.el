;;; init-dev.el --- Programming development -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

;; Compilation Mode
(use-package compile
  :ensure nil
  :preface
  ;; ANSI Coloring
  ;; @see https://stackoverflow.com/questions/13397737/ansi-coloring-in-compilation-mode
  (defun my-colorize-compilation-buffer ()
    "ANSI coloring in compilation buffers."
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  :hook (compilation-filter . my-colorize-compilation-buffer)
  :custom
  (compilation-scroll-output t))

;; Highlight TODO
(use-package hl-todo
  :ensure t
  :bind (:map hl-todo-mode-map
         ([C-f3] . hl-todo-occur)
         ("C-c t p" . hl-todo-previous)
         ("C-c t n" . hl-todo-next)
         ("C-c t o" . hl-todo-occur))
  :hook (after-init . global-hl-todo-mode)
  :config
  (dolist (keyword '("BUG" "ISSUE" "FIXME" "XXX" "NOTE" "NB"))
    (cl-pushnew `(,keyword . ,(face-foreground 'error)) hl-todo-keyword-faces))
  (dolist (keyword '("WORKAROUND" "HACK" "TRICK"))
    (cl-pushnew `(,keyword . ,(face-foreground 'warning)) hl-todo-keyword-faces)))

;; Show trailing whitespaces
(use-package whitespace
  :ensure nil
  :hook ((prog-mode markdown-mode conf-mode) . whitespace-mode)
  :custom
  (whitespace-style '(face trailing)))

;; Visual diff interface
(use-package ediff
  :ensure nil
  :hook (ediff-quit . winner-undo) ;; restore windows layout
  :custom
  (ediff-diff-options "-w") ;; turn off whitespace checking
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-merge-split-window-function 'split-window-horizontally))

;; Quickrun codes, including cpp. awesome!
(use-package quickrun
  :ensure t
  :defer 1
  :custom (quickrun-focus-p nil)
  :bind (("C-c x" . quickrun)))

;; Superb compiler explorer implementation
(use-package rmsbolt
  :ensure t
  :defer 1
  :custom
  (rmsbolt-asm-format nil)
  (rmsbolt-default-directory "/tmp"))

;; Project management
(use-package projectile
  :ensure t
  :bind (:map projectile-mode-map
         ("C-c p" . projectile-command-map))
  :hook (prog-mode . projectile-mode)
  :custom
  (projectile-completion-system 'ivy)
  (projectile-indexing-method 'hybrid)
  (projectile-read-command nil) ;; no prompt in projectile-compile-project
  (projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o" ".swp" ".so"))
  (projectile-ignored-projects '("/tmp"))
  :config
  ;; projectile-ripgrep requires `ripgrep'
  (use-package ripgrep
    :defer t
    :ensure t)

  ;; cmake project build
  (projectile-register-project-type 'cmake '("CMakeLists.txt")
                                    :configure "cmake -Bbuild"
                                    :compile "cmake --build build"
                                    :test "cd build && ctest --output-on-failure")

  ;; bazel project builds
  (projectile-register-project-type 'bazel '("WORKSPACE")
                                    :compile "bazel build //..."
                                    :test "bazel test //...")

  (dolist (dir '(".ccls-cache"
                 ".clangd"
                 "bazel-bin"
                 "bazel-out"
                 "bazel-testlogs"))
    (push dir projectile-globally-ignored-directories))
  )

;; Lint tool
(use-package flycheck
  :ensure t
  :hook (prog-mode . flycheck-mode)
  :custom
  (flycheck-check-syntax-automatically '(save mode-enabled))
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-indication-mode 'right-fringe)
  ;; clang/gcc/cppcheck flycheckers never know the include path
  (flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :config
  ;; consistent with help-mode
  (with-eval-after-load 'evil
    (evil-set-initial-state 'flycheck-error-list-mode 'normal)
    (evil-define-key 'normal flycheck-error-list-mode-map
      "q" 'quit-window))
  )

(use-package flymake
  :disabled
  :custom
  (flymake-fringe-indicator-position 'right-fringe))

;; xref
(use-package ivy-xref
  :ensure t
  :init
  ;; xref initialization is different in Emacs 27 - there are two different
  ;; variables which can be set rather than just one
  (when (>= emacs-major-version 27)
    (setq xref-show-definitions-function #'ivy-xref-show-defs))
  ;; Necessary in Emacs <27. In Emacs 27 it will affect all xref-based
  ;; commands other than xref-find-definitions (e.g. project-find-regexp)
  ;; as well
  (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

;; Draw a diagram in an easy way
(use-package plantuml-mode
  :ensure t
  :custom
  (plantuml-default-exec-mode 'executable)
  (plantuml-output-type "txt"))

;; An offline docset
(use-package zeal-at-point
  :ensure t
  :bind (:map prog-mode-map
         ("C-c z z" . zeal-at-point)
         ("C-c z s" . zeal-at-point-search))
  :custom
  (zeal-at-point-mode-alist '((c++-mode . ("cpp" "boost"))
                              (rust-mode . "rust"))))

;; Jump to definition, used as a fallback of lsp-find-definition
(use-package dumb-jump
  :ensure t
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g q" . dumb-jump-quick-look)
         ("M-g b" . dumb-jump-back)
         ("M-g i" . dumb-jump-go-prompt)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :custom
  (dumb-jump-quiet t)
  (dumb-jump-aggressive t)
  (dumb-jump-selector 'ivy)
  (dump-jump-prefer-searcher 'rg))

(use-package pulse
  :ensure nil
  :custom-face
  (pulse-highlight-start-face ((t (:inherit highlight))))
  (pulse-highlight-face ((t (:inherit highlight))))
  :preface
  (defun my/pulse-line (&rest _)
    "Pulse the current line."
    (pulse-momentary-highlight-one-line (point)))
  (defun my/recenter-and-pulse (&rest _)
    "Recenter and pulse the current line."
    (recenter)
    (my/pulse-line))
  :hook ((counsel-grep-post-action
          dumb-jump-after-jump
          bookmark-after-jump
          imenu-after-jump) . my/recenter-and-pulse)
  :init
  ;; better evil notification
  (advice-add #'evil-goto-line     :after #'my/recenter-and-pulse)
  (advice-add #'evil-window-top    :after #'my/pulse-line)
  (advice-add #'evil-window-middle :after #'my/pulse-line)
  (advice-add #'evil-window-bottom :after #'my/pulse-line))

;; Hiding structured data
(use-package hideshow
  :ensure nil
  :bind (:map prog-mode-map
         ("C-c TAB" . hs-toggle-hiding)
         ("M-+" . hs-show-all))
  :hook (prog-mode . hs-minor-mode)
  :custom
  (hs-special-modes-alist
   (mapcar 'purecopy
           '((c-mode "{" "}" "/[*/]" nil nil)
             (c++-mode "{" "}" "/[*/]" nil nil)
             (rust-mode "{" "}" "/[*/]" nil nil)))))

;; Config files mode
(use-package yaml-mode :ensure t)
(use-package toml-mode :ensure t)

(require 'init-cpp)
(require 'init-rust)
(require 'init-ocaml)
(require 'init-bazel)
(require 'init-haskell)

(provide 'init-dev)

;;; init-dev.el ends here
