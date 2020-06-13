;; company-mode autocompletion
(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook  'global-company-mode)
  (setq company-minimum-prefix-length 1
      company-idle-delay 0.0) ;; default is 0.2
  ;; keybindings
  (global-set-key (kbd "C-<SPC>" ) 'company-complete))
(use-package company-c-headers
  :ensure t
  :after (company)
  :config
  (add-to-list 'company-backends 'company-c-headers))

(use-package company-lsp :ensure t
  :config
  (push 'company-lsp company-backends))
(use-package company-quickhelp :ensure t
  :config
  (company-quickhelp-mode)
  (setq company-quickhelp-delay 0.2))


(provide 'init-company-mode)
