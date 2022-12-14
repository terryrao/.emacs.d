;; theme 
(use-package gruvbox-theme
  :init (load-theme 'gruvbox-dark-soft t))

;; mode line need load after theme
(use-package smart-mode-line
  :init
  (setq sml/no-confirm-load-theme t
	sml/theme 'respectful) 
  (sml/setup)) 


(use-package emacs ;; 已存在的插件都行
  :if(display-graphic-p) ; 仅在图形化界面使用
  :config
  ;; font settings
  (if *is-windows*
      (progn
	(set-face-attribute 'default nil :font "Microsoft Yahei Mono 9")
	(dolist (charset '(kana han symbol cjk-misc bopomofo))
	  (set-fontset-font (frame-parameter nil 'font)
			    charset (font-spec :family "Microsoft Yahei Mono" :size 12))))
    (set-face-attribute 'default nil :font "Source Code Pro")))



(provide 'init-ui)
