
;; benchmark
;; how to use it
;; M-x benchmark-init/show-durations-tree
;; M-x benchmark-init/show-durations-tabulated
(use-package benchmark-init
  :init (benchmark-init/activate)
  :hook (after-init . benchmark-init/deactivate))

(provide 'init-benchmark)
