 (use-package restart-emacs)


; (defalias 'yes-or-no-p 'y-or-n-p)
;; 使用下面的方式与上面的方式是等价的
(use-package emacs
  :config (defalias 'yes-or-no-p 'y-or-n-p))

;; line number

(use-package emacs
  :config
  (setq display-line-numbers-type 'visual)
  (global-display-line-numbers-mode t))

;;

(use-package ivy
  :defer 1
  :demand
  :hook (after-init . ivy-mode)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t
	ivy-initial-inputs-alist nil
	ivy-count-format "%d/%d "
	enable-recursive-minibuffers t
	ivy-re-builders-alist '(( t . ivy--regex-ignore-order))))
  ;;(ivy-posframe-mode t))

(use-package counsel
  :after (ivy)
  :bind (( "M-x" . counsel-M-x)
	 ("C-x C-f" . counsel-find-file)
	 ("C-c f" . counsel-recentf)
	 ("C-c g" . counsel-git)))


(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
	 ("C-r" . swiper-isearch-backward))
  :config (setq swiper-action-recenter t
		swiper-include-line-number-in-search t))


;; auto complete

;;(use-package company
;;  :ensure t
;;  :config
 ;; (setq company-dabbrev-code-everywhere t
;;	company-dabbrev-code-modes t
;;	company-dabbrev-code-other-buffers 'all
;;	company-dabbrev-downcase nil
;;	company-dabbrev-ignore-case t
;;	company-dabbrev-other-buffers 'all
;;	company-require-math nil
;;	company-minimum-prefix-length 2
;;	company-show-numbers t
;;	company-tooltip-limit 20
;;	company-idle-delay 0
;;	company-echo-delay 0
;;	company-tooltip-offset-display 'scrollbar
    ;;company-backends '((company-files company-yasnippet company-keywords company-capf)(company-abbrev company-dabbrev))
;;	company-begin-commands '(self-insert-command))
 ;;(push '(company-semantic :with company-yasnippet) company-backends)
;;  :hook ((after-init . global-company-mode)))

(use-package go-mode
  ;; :load-path "~/.emacs.d/vendor/go-mode"
  :mode ("\\.go\\'" . go-mode)
  :ensure
  ((goimports . "go get -u golang.org/x/tools/cmd/goimports")
   (godef . "go get -u github.com/rogpeppe/godef"))
  :init
  (setq gofmt-command "goimports"
        indent-tabs-mode t)
  :config
  (add-hook 'before-save-hook 'gofmt-before-save)
  :bind (:map go-mode-map
              ("\C-c \C-c" . compile)
              ("\C-c \C-g" . go-goto-imports)
              ("\C-c \C-k" . godoc)
              ("M-j" . godef-jump)))


(use-package company
  :ensure t
  :config
  (global-company-mode t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (setq company-backends
        '((company-files
           company-yasnippet
           company-keywords
           company-capf
           )
          (company-abbrev company-dabbrev))))

(add-hook 'emacs-lisp-mode-hook (lambda ()
                                  (add-to-list  (make-local-variable 'company-backends)
                                                '(company-elisp))))


;;

(use-package dumb-jump
  :bind (("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g x" . dumb-jump-go-prefer-external)
         ("M-g z" . dumb-jump-go-prefer-external-other-window))
  :config
  ;; (setq dumb-jump-selector 'ivy) ;; (setq dumb-jump-selector 'helm)
:init
(dumb-jump-mode)
  :ensure
)

;; 语法检查
(use-package flycheck
  :hook (after-init . global-flycheck-mode))

;; 如果只在编程语言的模式下启用，则使用以下配置
;;(use-package flycheck
;;  :hook (prog-mode . flycheck-mode))

;; settings  for crux

(use-package crux
  :bind (("C-a" . crux-move-beginning-of-line)
	 ("C-c ^" . crux-top-join-line)
	 ("C-x ," . crux-find-user-init-file)))


;; hotkey tips 

(use-package which-key
  :defer nil
  :config (which-key-mode))

;;  mini buffer interaction

(use-package ivy-posframe
  :init
  (setq ivy-posframe-display-functions-alist
	'((swiper . ivy-posframe-display-at-frame-center)
	  (complete-symbol . ivy-posframe-display-at-point)
	  (counsel-M-x . ivy-posframe-display-at-frame-center)
	  (counsel-find-file . ivy-posframe-display-at-frame-center)
	  (ivy-switch-buffer . ivy-posframe-display-at-frame-center)
	  (t . ivy-posframe-dilplay-at-frame-center))))
(ivy-posframe-mode t); 加上才能生效


;; 分屏切换

(use-package ace-window
  :bind (("M-o" . 'ace-window)))

;; popwin 窗口管理

(use-package popwin
  :config
  (push '(direx:direx-mode :position left :width 25 :dedicated t)
      popwin:special-display-config)
  (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window))
(popwin-mode 1)


(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))


(with-eval-after-load "go-mode"
  (with-eval-after-load "project"
    (defun project-find-go-module (dir)
      (when-let ((root (locate-dominating-file dir "go.mod")))
        (cons 'go-module root)))
    (cl-defmethod project-root ((project (head go-module)))
      (cdr project))
    (add-hook 'project-find-functions 'project-find-go-module)))

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))



(use-package evil
  :config
  (setq evil-shift-width 0)
  )
(evil-mode 1)

(provide 'init-package)
