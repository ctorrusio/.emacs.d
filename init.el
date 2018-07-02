;; install melpa
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/auto-save/auto-save-files/" t))))
 '(auto-save-list-file-prefix "~/.emacs.d/auto-save/auto-save-list/.saves-")
 '(column-number-mode t)
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(global-undo-tree-mode t)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(undo-tree-mode-lighter "")
 '(undo-tree-visualizer-diff nil)
 '(undo-tree-visualizer-relative-timestamps nil)
 '(undo-tree-visualizer-timestamps t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )




;; enabled minor modes
(ido-mode t)
(add-hook 'prog-mode-hook #'hs-minor-mode)
(hide-ifdef-mode t)
(pending-delete-mode t)


;; own keybindings in a minor mode to override all other bindings globally.

(defvar my-keys-minor-mode-map
  (let ((map (make-sparse-keymap)))
    ;; ctrl+z undo
    (define-key map (kbd "C-z") 'undo)

    ;;hide/show blocks and ifdefs
    (define-key map (kbd "C--") 'hs-toggle-hiding)
    (define-key map (kbd "C-+") 'hs-show-block)
    (define-key map (kbd "C-_") 'hs-hide-all)
    (define-key map (kbd "C-?") 'hs-show-all)
    (define-key map (kbd "C-.") 'hide-ifdef-block)
    (define-key map (kbd "C-:") 'hide-ifdefs)
    (define-key map (kbd "C-0") 'show-ifdef-block)
    (define-key map (kbd "C-=") 'show-ifdefs)
    map)
  "my-keys-minor-mode keymap.")

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  :init-value t
  ;:lighter " my-keys"
  )
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(defun my-keys-have-priority (_file)
  "Try to ensure that my keybindings retain priority over other minor modes.
Called via the `after-load-functions' special hook."
  (unless (eq (caar minor-mode-map-alist) 'my-keys-minor-mode)
    (let ((mykeys (assq 'my-keys-minor-mode minor-mode-map-alist)))
      (assq-delete-all 'my-keys-minor-mode minor-mode-map-alist)
      (add-to-list 'minor-mode-map-alist mykeys))))

(my-keys-minor-mode 1)
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)
(add-hook 'after-load-functions 'my-keys-have-priority)




