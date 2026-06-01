;;; ===== 기본 UI / 인코딩 =====
(setq inhibit-splash-screen t
      inhibit-startup-screen t)
(setq-default tab-width 4 indent-tabs-mode nil)
(global-display-line-numbers-mode t)
(column-number-mode t)
(save-place-mode t)
(global-hl-line-mode t)
(set-face-background 'hl-line "#112211")

(set-language-environment "Korean")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq-default file-name-coding-system 'utf-8)

;;; ===== 키바인딩 =====
(global-set-key [f10] 'describe-function)
(global-set-key [f12] 'describe-key)
;; window key
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

;;; ===== 패키지 매니저 =====
(require 'package)
(setq package-enable-at-startup t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("elpa" . "https://elpa.gnu.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t
      use-package-always-defer t)   ; 지연 로딩 → 시작 빠름

;; 셸 환경/PATH (conda 포함) 가져오기
(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-variables
        '("PATH" "CONDA_PREFIX" "CONDA_DEFAULT_ENV"))
  :config
  (exec-path-from-shell-initialize))

;;; ===== LSP: eglot (Emacs 내장) =====
(use-package eglot
  :ensure nil
  :hook ((python-mode python-ts-mode
          c-mode c-ts-mode
          c++-mode c++-ts-mode) . eglot-ensure)
  :config
  (setq eglot-autoshutdown t          ; 마지막 버퍼 닫히면 서버 종료
        eglot-events-buffer-size 0    ; 이벤트 로그 끔 → 가벼움
        eglot-sync-connect 0)         ; 연결을 비동기로 → UI 안 멈춤
  ;; C/C++ : clangd
  (add-to-list 'eglot-server-programs
               '((c-mode c-ts-mode c++-mode c++-ts-mode)
                 . ("clangd" "--background-index" "--clang-tidy")))
  ;; Python : basedpyright
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 . ("basedpyright-langserver" "--stdio"))))

;;; ===== 자동완성: corfu + cape =====
(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-cycle t))
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-dabbrev))

;;; ===== 미니버퍼 (가볍고 모듈형) =====
(use-package vertico
  :init (vertico-mode))
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))
(use-package marginalia
  :init (marginalia-mode))
(use-package consult
  :bind (("C-s"   . consult-line)
         ("C-x b" . consult-buffer)
         ("M-g g" . consult-goto-line)))

;;; ===== conda =====
(use-package conda
  :config
  (setq conda-anaconda-home (expand-file-name "~/anaconda3")
        conda-env-home-directory (expand-file-name "~/anaconda3"))
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  (conda-env-autoactivate-mode t)
  ;; conda 환경이 바뀌면 eglot 에 해당 환경의 python 경로를 알려주고 재연결
  (add-hook 'conda-postactivate-hook
            (lambda ()
              (let ((prefix (getenv "CONDA_PREFIX")))
                (when prefix
                  (setq-default eglot-workspace-configuration
                                `(:python
                                  (:pythonPath
                                   ,(expand-file-name "bin/python" prefix))))
                  (message "[eglot] python path -> %s/bin/python" prefix)
                  (when (and (fboundp 'eglot-current-server)
                             (eglot-current-server))
                    (eglot-reconnect (eglot-current-server))))))))

;;; ===== CMake =====
(use-package cmake-mode)

;;; ===== AI 채팅: gptel =====
(use-package gptel
  :config
  (setq gptel-default-mode 'markdown-mode))

;;; ===== 에이전트: Claude Code =====
(use-package claude-code
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :config (claude-code-mode)
  :bind-keymap ("C-c c" . claude-code-command-map))

(put 'scroll-left 'disabled nil)
(put 'upcase-region 'disabled nil)

(custom-set-variables
 '(safe-local-variable-values
   '((git-commit-major-mode . git-commit-elisp-text-mode))))
(custom-set-faces)
