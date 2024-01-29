;;; init.el --- Load the full configuration -*- lexical-binding: t -*-
;;; Commentary:

;; This file bootstraps the configuration, which is divided into
;; a number of other files.

;; Load early-init.el
(load (expand-file-name "early-init.el" user-emacs-directory) t)

;; Package Management
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure 't)

;; Location of our custom emacs file
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; Adjust garbage collection thresholds during startup, and thereafter
(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
            (lambda () (setq gc-cons-threshold normal-gc-cons-threshold))))

;; Add transparency before applying themes
(set-frame-parameter nil 'alpha-background 90)
(add-to-list 'default-frame-alist '(alpha-background . 90))

(require 'init-themes)
(require 'init-ui)
(require 'init-dired)
(require 'init-evil)
(require 'init-key-chord)
(require 'init-helm)
(require 'init-terraform)

;; For some reasons, my org mode file isn't highlighted anymore, quick fix ahead
(add-hook 'find-file-hook 'my-org-mode-file-hook)
(defun my-org-mode-file-hook ()
  (when (string= (file-name-extension buffer-file-name) "org")
    (org-mode)))

;; TODO Put in its corresponding file
(define-key global-map (kbd "RET") 'newline-and-indent)

(setq backup-directory-alist '(("." . "~/.emacs-backup")))

;; Suppress those annoying Warning buffer popping on while I'm working on stuff
(setq native-comp-async-report-warnings-errors 'silent)

;;(define-key global-map (kbd "C-c ;") 'iedit-mode)
(global-set-key (kbd "M-x") 'helm-M-x)

(set-default 'tab-always-indent 't)
(setq backward-delete-char-untabify-method 'hungry)
(add-hook 'sh-mode-hook (lambda() (setq sh-basic-offset 2)))
