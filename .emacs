;;; .emacs --- Bootstrap personal Emacs configuration -*- lexical-binding: t; -*-

;; Keep the existing ~/.emacs.d/init.el active, but install new packages into a
;; user-owned directory because the current ~/.emacs.d/elpa tree is root-owned.
(require 'package)

(setq package-user-dir (expand-file-name "elpa-user" user-emacs-directory))
(add-to-list 'package-directory-list (expand-file-name "elpa" user-emacs-directory))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)

(load (expand-file-name "init.el" user-emacs-directory) nil t)
(load (expand-file-name "cursor-like.el" user-emacs-directory) nil t)
