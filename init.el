;;; init.el --- settings for emacs
;;; Commentary:
;; Init for Emacs

;;; Code

;; load path
(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp")))

;; 使用custom 或者菜单改变的配置会多出 custom- 开头的配置，需要放到单独的文件中
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))





;; load config
(require 'init-elpa)
(require 'init-package)
(require 'init-startup)
(require 'init-consts)
(require 'init-ui)
(require 'init-benchmark)
(require 'init-lsp)
(when (file-exists-p custom-file)
  (load-file custom-file))



