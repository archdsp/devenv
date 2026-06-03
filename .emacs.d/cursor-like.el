;;; cursor-like.el --- Cursor-like workflow for Emacs -*- lexical-binding: t; -*-

;; This file is loaded after ~/.emacs.d/init.el by ~/.emacs.

(require 'project)

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode 1))

(use-package consult
  :ensure t
  :bind (("C-c s" . consult-ripgrep)
         ("C-c b" . consult-buffer)
         ("C-c f" . consult-find)))

(use-package projectile
  :ensure t
  :init
  (projectile-mode 1)
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package vterm
  :ensure t
  :commands vterm)

(use-package gptel
  :ensure t
  :commands (gptel gptel-send)
  :bind (("C-c a a" . gptel)
         ("C-c a s" . gptel-send))
  :config
  (setq gptel-model "gpt-5.5"))

;; Install copilot.el separately, then run M-x copilot-install-server and
;; M-x copilot-login. This block activates only when the package is present.
(use-package copilot
  :if (package-installed-p 'copilot)
  :ensure nil
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("TAB" . copilot-accept-completion)
              ("C-TAB" . copilot-accept-completion-by-word)))

(defun my/project-root-or-default ()
  "Return the current project root, falling back to `default-directory'."
  (if-let ((project (project-current nil)))
      (project-root project)
    default-directory))

(defun my/vterm-run-in-project (buffer-name command)
  "Open BUFFER-NAME in a project-root vterm and run COMMAND."
  (unless (require 'vterm nil t)
    (user-error "Install vterm first with M-x package-install RET vterm RET"))
  (let ((default-directory (my/project-root-or-default)))
    (vterm buffer-name)
    (vterm-send-string command)
    (vterm-send-return)))

(defun my/codex-vterm ()
  "Start Codex in a project-root vterm."
  (interactive)
  (my/vterm-run-in-project "*codex*" "codex"))

(defun my/aider-vterm ()
  "Start Aider in a project-root vterm."
  (interactive)
  (my/vterm-run-in-project "*aider*" "aider"))

(global-set-key (kbd "C-c a c") #'my/codex-vterm)
(global-set-key (kbd "C-c a i") #'my/aider-vterm)

(provide 'cursor-like)
;;; cursor-like.el ends here
