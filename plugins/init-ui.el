;;; init-ui.el --- Theme and modeline -*- lexical-binding: t -*-

;;; Commentary:
;;

;;; Code:

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode))

(use-package golden-ratio
  :ensure t
  :defer 5
  :custom
  (golden-ratio-auto-scale t)
  (golden-ratio-exclude-modes '(calc-mode
                                dired-mode
                                ediff-mode
                                gud-mode
                                gdb-locals-mode
                                gdb-registers-mode
                                gdb-breakpoints-mode
                                gdb-threads-mode
                                gdb-frames-mode
                                gdb-inferior-io-mode
                                gdb-disassembly-mode
                                gdb-memory-mode)))

;; make dired colorful
(use-package diredfl
  :ensure t
  :hook (dired-mode . diredfl-mode))

;; restore windows layout
(use-package winner-mode
  :ensure nil
  :hook (after-init . winner-mode))

(provide 'init-ui)

;;; init-ui.el ends here
