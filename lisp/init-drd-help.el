

(defun my/help-window nil
  "These are your keybindings:

- Error checking: (flycheck)\\<flycheck-mode-map>
`\\[flycheck-next-error]' Next Error
`\\[flycheck-previous-error]' Previous Error
`\\[flycheck-list-errors]' Error List

- Snippet expansion: (yasnippet)\\<yas-minor-mode-map>
`\\[yas-expand]' Expand Snippet
`\\[yas-insert-snippet]' Search for Snippet

- Docs: (lsp-mode)\\<lsp-mode-map>
`\\[lsp-find-definition]' Follow link to definition
`\\[lsp-describe-thing-at-point]' Show documentation at point
Also, company-lsp, company-quickhelp and company-capf provide
tooltip description of possible completions

- Auto-completions: (company-mode)\\<company-mode-map>
`\\[company-complete]' Show Completion Candidates

- Git: (magit)\\<magit-mode-map>
`\\[magit-status]' Magit Status

- Projects navigation: (treemacs)
`\\[treemacs]' View Projects Tree

- Projects management: (projectile)\\<projectile-mode-map>
`\\[projectile-switch-project]' Open/Switch Project
`\\[projectile-find-file]' Find file in project
`\\[projectile-replace]' Replace string in Project
Notice how this is NOT used by lsp-mode if not for finding
a project root, the projects are actually handled by lsp
workspaces


"
  (interactive)
  (describe-function 'my/help-window))


;;
;;
;;
;;
;;
;;
;;
;;
;;
;;

(provide 'init-drd-help)
