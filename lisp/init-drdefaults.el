;;; package --- Summary
;;; Commentary:
;;; Init file for things already present in Emacs
;;; Code:

;; Move custom-set variables to separate file
;; this is allowed via setq as described by docs
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file)

;; remove unwanted buffers
(defun remove-scratch-buffer ()
  "Remove *scratch* from buffer after the mode has been set."
  (if (get-buffer "*scratch*")
      (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; delete trailing whitespace on save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
          #'(lambda ()
             (let ((buffer "*Completions*"))
               (and (get-buffer buffer)
                    (kill-buffer buffer)))))

;; Show only one active window when opening multiple files at the same time.
(add-hook 'window-setup-hook 'delete-other-windows)

(global-set-key (kbd "<mouse-6>") 'scroll-right)
(global-set-key (kbd "<mouse-7>") 'scroll-left)
(global-set-key (kbd "M-s-h") 'shrink-window-horizontally)
(global-set-key (kbd "M-s-j") 'shrink-window)
(global-set-key (kbd "M-s-k") 'enlarge-window)
(global-set-key (kbd "M-s-l") 'enlarge-window-horizontally)
(global-set-key (kbd "M-s-t") 'switch-theme)
(global-set-key (kbd "C-c j") 'xref-find-definitions)
(global-set-key (kbd "C-c r") 'xref-find-references)
(global-set-key (kbd "C-c k") 'xref-pop-marker-stack)
(global-set-key (kbd "C-c s") 'xref-find-apropos)

(defun my/disable-scroll-bars (frame)
  "Remove scrollbars from new FRAME."
  (modify-frame-parameters frame
                           '((vertical-scroll-bars . nil)
                             (horizontal-scroll-bars . nil))))
;; Remove scrollbar on each new FRAME.
(add-hook 'after-make-frame-functions 'my/disable-scroll-bars)
;;(add-hook 'after-make-frame-functions 'force-mode-line-update)

(provide 'init-drdefaults)
;;; init-drdefaults.el ends here
