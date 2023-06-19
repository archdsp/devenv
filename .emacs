;; Basic Setting ;;

; Remove menu bar at top
(menu-bar-mode 0)

; Kill default buffer
;; Makes *scratch* empty.
(setq initial-scratch-message "")

;; Removes *scratch* from buffer after the mode has been set.
(defun remove-scratch-buffer ()
  (if (get-buffer "*scratch*")
  (kill-buffer "*scratch*")))
(add-hook 'after-change-major-mode-hook 'remove-scratch-buffer)

;; Removes *messages* from the buffer.
(setq-default message-log-max nil)
(kill-buffer "*Messages*")

;; Removes *Completions* from buffer after you've opened a file.
(add-hook 'minibuffer-exit-hook
    '(lambda ()
         (let ((buffer "*Completions*"))
            (and (get-buffer buffer)
                (kill-buffer buffer)))))

;; Don't show *Buffer list* when opening multiple files at the same time.
(setq inhibit-startup-buffer-menu t)

;; Show only one active window when opening multiple files at the same time.
(add-hook 'window-setup-hook 'delete-other-windows)

; Line Wrap mode on for all buffers
(global-visual-line-mode t)

; Line Number
(global-linum-mode t)
(setq linum-format "%4d ")

(whitespace-mode) dfdsfd

(setq whitespace-display-mappings
  '((space-mark   ?\     [?\ ]     [?.])
    (space-mark   ?\xA0  [?\ ]     [?_])
    (newline-mark ?\n    [?$ ?\n])
    (tab-mark     ?\t    [?\u00BB ?\t] [?\\ ?\t])))

; Column Number
(setq column-number-mode t)

; Save last cursor position
(require 'saveplace)
(setq-default save-place t)
(save-place-mode t)

; Match braket and braces
(show-paren-mode t)
(setq show-paren-delay 0)

;Tab width
(setq-default tab-width 4)
(setq-default tab-stop-list 4)

; C coding style
(setq c-default-style "bsd")
(setq c-default-style "bsd" c-basic-offset 4)

;Time Display
(display-time)

; Cursor
(blink-cursor-mode t)

;; Basic mode ;;
(cua-mode t)

(global-set-key [f12] 'describe-key)
(global-set-key [f10] 'describe-function)
(global-set-key [f1] 'shell)
(global-set-key [f3] 'execute-extended-command)

(global-set-key (kbd "M-i") 'previous-line)
(global-set-key (kbd "M-k") 'next-line)
(global-set-key (kbd "M-j") 'left-char)
(global-set-key (kbd "M-l") 'right-char)

;; Basic Shortcut Keys ;;
(global-set-key (kbd "C-a") 'mark-whole-bufer) 

; find word
(global-set-key (kbd "C-f") 'isearch-forward)
(define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
(define-key isearch-mode-map (kbd "C-d") 'isearch-repeat-backward)

; buffer arrow key
(global-set-key (kbd "C-x C-j") 'previous-buffer)
(global-set-key (kbd "C-x C-l") 'next-buffer)

; window key
(global-set-key (kbd "M-9") 'split-window-vertically)
(global-set-key (kbd "M-0") 'split-window-horizontally)
(global-set-key (kbd "M-p") 'delete-window)
(global-set-key (kbd "M-_") 'shrink-window-horizontally)  
(global-set-key (kbd "M-+") 'enlarge-window-horizontally)
(global-set-key (kbd "M--") 'shrink-window)  
(global-set-key (kbd "M-=") 'enlarge-window)  

(global-set-key (kbd "C-c C-j")  'windmove-left)
(global-set-key (kbd "C-c C-l") 'windmove-right)
(global-set-key (kbd "C-c C-i")    'windmove-up)
(global-set-key (kbd "C-c C-k")  'windmove-down)

(global-set-key (kbd "C-l")  'goto-line)
(global-set-key (kbd "TAB") 'self-insert-command)

(global-set-key "\M-q" 'beginning-of-line-text)
(global-set-key "\M-e" 'end-of-line)
;; (global-set-key "\M-x" (lambda () (interactive) (scroll-up 4)))
;; (global-set-key "\M-z" (lambda () (interactive) (scroll-down 4)))

; input method : set default input method as hangul
(set-input-method "korean-hangul")

; load themek
(load-theme 'wombat)

;; PACKAGE
(require 'package)
(setq package-enable-at-startup t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.kmilkbox.net/packages/") t)
(package-initialize)

;;; 커스텀 모듈 로드 ;;;
;(setq custom-file "~/.emacs.d/custom.el")
;(load cUSTOM-FILE)

;; 대괄호 매칭 
(show-paren-mode t)
(setq show-paren-delay 0)

;; 탭 넓이
(setq-default tab-width 4)

;; not use tab instead space
(setq-default indent-tabs-mode nil)

;; c코딩 스타일 지정(글로벌)
(setq c-default-style "bsd" c-basic-offset 4)
(setq c-defun-tactic "go-outward")

;backup files
;put autosave files (ie #foo#) and backup files (ie foo~) in ./.emacs_backup_src/".
(setq backup-directory-alist '(("" . "./.emacs_backup_src/")))
(setq delete-by-moving-to-trash t)
(setq version-control t)
