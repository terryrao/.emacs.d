;; define consts 
(defconst *is-mac* (eq system-type 'darwin)
  "判断是否是mac")
(defconst *is-linux* (eq system-type 'gnu/linux))
(defconst *is-windows* (or (eq system-type 'ms-dos) (eq system-type 'windows-nt)))

(provide 'init-consts)
