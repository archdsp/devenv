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

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-variables '("PATH" "CONDA_PREFIX" "CONDA_DEFAULT_ENV"))
  :config
  (exec-path-from-shell-initialize))

(use-package lsp-mode
  :ensure t
  ;:hook ((python-mode . lsp)) 
  :commands lsp
  :config
  (setq lsp-headerline-breadcrumb-enable t
        lsp-enable-symbol-highlighting t
        lsp-signature-auto-activate t
        lsp-signature-render-documentation t
        lsp-completion-provider :capf))

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
  :custom
  (lsp-pyright-python-executable-cmd "python"))

(use-package conda
  :after lsp-pyright
  :ensure t
  :config
  (setq conda-anaconda-home (expand-file-name "~/anaconda3")) ;; or your path
  (setq conda-env-home-directory (expand-file-name "~/anaconda3"))
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  (conda-env-autoactivate-mode t))

(defun my/update-pyright-python-path-based-on-conda ()
  (let* ((conda-env (getenv "CONDA_DEFAULT_ENV"))
         (conda-prefix (getenv "CONDA_PREFIX"))
         (python-path (when conda-prefix
                        (expand-file-name "bin/python" conda-prefix))))
    (when (and conda-env python-path (file-exists-p python-path))
      (setq lsp-pyright-python-executable-cmd python-path)
      (message "[Pyright] Python path set to: %s" python-path)
      (when (bound-and-true-p lsp-mode)
        (lsp-restart-workspace)))))

(add-hook 'conda-postactivate-hook #'my/update-pyright-python-path-based-on-conda)

(use-package lsp-ui
  :after lsp-mode
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-show-with-cursor t
        lsp-ui-doc-delay 0.1
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover t
        lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-show-diagnostics t))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)) ;;


;Company Mode for Auto-Completion
(use-package company
;;   :init
;;   (global-company-mode)
;;   :ensure t
;;   ;:hook (python-mode . company-mode)
  :config
  (setq company-backends '(company-capf)))
;;   (setq company-idle-delay 0.0)
;;   (setq company-tooltip-align-annotations t)
;;   (setq company-minimum-prefix-length 1)
;;   (setq company-selection-wrap-around t))


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
 '(package-selected-packages
   '(company-box conda exec-path-from-shell flycheck lsp-pyright lsp-ui))
 '(safe-local-variable-values '((git-commit-major-mode . git-commit-elisp-text-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(setq lsp-log-io nil)
