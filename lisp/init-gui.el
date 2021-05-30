;;; package --- Summary
;;; Commentary:
;;; Gui related settings for Emacs.  Not necessarily related
;;; to only the "gui" way of spawning Emacs (gui is used in the
;;; true sense of the term), so it also applies for some terminal
;;; Emacs settings.
;;; Code:

;; To fully separate emacs' responsibilities from
;; X11's
(setq inhibit-x-resources t)

;; install custom theme (if missing)
(unless (package-installed-p 'zenburn-theme)
  (package-refresh-contents)
  (package-install 'zenburn-theme))

;; set default font
(add-to-list 'default-frame-alist
             '(font . "Inconsolata-20"))
(set-fontset-font "fontset-default" nil (font-spec :size 20 :name "DejaVu Sans Mono"))
(set-fontset-font "fontset-default" nil (font-spec :size 20 :name "Noto Color Emoji"))

(defvar my/light-theme 'doom-solarized-light)
(defvar my/dark-theme 'doom-vibrant)
(defvar my/current-theme my/light-theme)

(defadvice load-theme (before theme-dont-propagate activate)
  "Disable theme before loading new one."
  (mapc #'disable-theme custom-enabled-themes))

(defun my/switch-theme (theme)
  "Switch to selected THEME with some housekeeping."
  (if (eq theme 'default)
      (disable-theme my/current-theme)
    (progn
      (load-theme theme t)))
  (setq my/current-theme theme))

(defun my/toggle-theme ()
  "Switch between set light/dark THEME in init-gui.el."
  (interactive)
  (cond ((eq my/current-theme my/light-theme) (my/switch-theme my/dark-theme))
        ((eq my/current-theme my/dark-theme) (my/switch-theme my/light-theme))))
(global-set-key (kbd "M-t") 'my/toggle-theme)

;; Try to default to a sane default theme
(defun my/set-suitable-theme ()
  "Set the starting theme to the most suitable for the current time of day."
  (if (or (>= (string-to-number (shell-command-to-string "date +%H")) 21)
          (< (string-to-number (shell-command-to-string "date +%H")) 7))
      (my/switch-theme my/dark-theme)
    (my/switch-theme my/light-theme)))
(my/set-suitable-theme)

;; set default empty line fringe
(progn
  (define-fringe-bitmap 'tilde [0 0 0 113 219 142 0 0] nil nil 'center)
  (setcdr (assq 'empty-line fringe-indicator-alist) 'tilde))
(set-fringe-bitmap-face 'tilde 'font-lock-function-name-face)

;; enable only for programming major modes
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Start maximized
(add-to-list 'default-frame-alist
             '(fullscreen . maximized))

(diminish 'auto-revert-mode)
(diminish 'undo-tree-mode)
(diminish 'eldoc-mode)
(diminish 'overwrite-mode)

(add-hook 'server-after-make-frame-hook (lambda () (select-frame-set-input-focus (selected-frame))))


(provide 'init-gui)
;;; init-gui.el ends here
