
;; Magit git front-end
(use-package magit
  :ensure t
  :config
  (setq magit-refresh-status-buffer nil)
  (global-set-key (kbd "C-c g") 'magit-status))
;; == end of Magit ==

(provide 'init-magit)
