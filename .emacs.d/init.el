(setq inhibit-splash-screen t)
(setq inhibit-startup-screen t)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(global-display-line-numbers-mode t)

(set-language-environment "Korean")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq-default file-name-coding-system 'utf-8)

(column-number-mode t)

(save-place-mode t)

(global-hl-line-mode t)
(set-face-background 'hl-line "#112211")

(whitespace-mode t)

(global-set-key [f10] 'describe-function)
(global-set-key [f12] 'describe-key)

; window key
(global-set-key (kbd "M-9") 'split-window-vertically)
(global-set-key (kbd "M-0") 'split-window-horizontally)
(global-set-key (kbd "M-p") 'delete-window)
(global-set-key (kbd "M-_") 'shrink-window-horizontally)  
(global-set-key (kbd "M-+") 'enlarge-window-horizontally)
(global-set-key (kbd "M--") 'shrink-window)
(global-set-key (kbd "M-=") 'enlarge-window)

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;; PACKAGE
(require 'package)
(setq package-enable-at-startup t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("elpa" ."https://elpa.gnu.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package lsp-mode
  :ensure t
  :hook ((python-mode . lsp-deferred)) 
  :commands lsp-deferred
  :config
  (setq lsp-prefer-flymake nil)) 

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))) 

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)) ;;

(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1) ;; 
  (setq pyvenv-workon ".venv"))

;; Company Mode for Auto-Completion
(use-package company
  :ensure t
  :hook (python-mode . company-mode)
  :config
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 1)
  (setq company-selection-wrap-around t))

;; Optional: Better UI for auto-completion
(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

(put 'scroll-left 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(lsp-pyright lsp-python-ms lsp-ui lsp-mode))
 '(safe-local-variable-values '((git-commit-major-mode . git-commit-elisp-text-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(setq lsp-log-io nil)

