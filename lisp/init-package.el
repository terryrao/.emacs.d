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

(use-package company
  :config
  (setq company-dabbrev-code-everywhere t
	company-dabbrev-code-modes t
	company-dabbrev-code-other-buffers 'all
	company-dabbrev-downcase nil
	company-dabbrev-ignore-case t
	company-dabbrev-other-buffers 'all
	company-require-math nil
	company-minimum-prefix-length 2
	company-show-numbers t
	company-tooltip-limit 20
	company-idle-delay 0
	company-echo-delay 0
	company-tooltip-offset-display 'scrollbar
	company-begin-commands '(self-insert-command))
  (push '(company-semantic :with company-yasnippet) company-backends)
  :hook ((after-init . global-company-mode)))

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


(provide 'init-package)
