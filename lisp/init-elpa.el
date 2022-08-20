;; use package manager
(require 'package)

;; do not check ginature in china somethings return fail
(setq package-check-signature nil) 

(setq use-package-always-ensure t
      use-package-always-defer t
      use-package-always-demand nil
      use-package-expand-minimally t
      use-package-verbose t)


(setq package-archives '(("melpa" . "https://melpa.org/packages/")
              ("melpa-stable" . "https://stable.mepla.org/packages/")
              ("org" . "https://orgmode.org/elpa/")
              ("elpa" . "https://elpa.gnu.org/packages/")
              ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; initial package manager 
;(unless (bound-and-true-p package--initialized)
;  (package-initialize))

;(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(unless package-archive-contents
  (package-refresh-contents))

;; update package index
(unless (package-installed-p 'use-package)
  (package-refesh-contents)
  (package-install 'use-package))
(require 'use-package)


(provide 'init-elpa)
