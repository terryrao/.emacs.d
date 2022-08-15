;; set utf8 init

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; set gc 
(setq gc-cons-threshold most-positive-fixnum)


;; close manual help page 
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; tab replace by 4 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq indent-tabs-mode nil)
(setq tab-width 4)


(provide 'init-startup)
;;; init-startup.el ends here
