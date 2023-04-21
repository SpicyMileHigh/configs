(setq server-socket-dir (substitute-in-file-name "$HOME/.config/emacs/server-dir"))

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
'("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; Packages
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

; Evil mode with evil in every buffer
(setq evil-want-keybinding nil)
(use-package evil
	:init
	(evil-mode))
(use-package evil-collection
	:after evil
	:config
	(setq evil-collection-mode-list '(dashboard dired ibuffer))
	(evil-collection-init))

; General lets us use space for a prefix, very ergonomic
(use-package general
	:config
	(general-evil-setup t))

; Display some help for forgetting keybindings
(use-package which-key
	:ensure t
	:init
	(which-key-mode))

; Autocompletion
(use-package company
  :ensure t
  :config
  (progn
    (add-hook 'after-init-hook 'global-company-mode)))
(use-package lsp-mode)
(use-package lsp-haskell)
(use-package lsp-treemacs)
(use-package lsp-java)
(use-package lsp-ui)

; Dired
(use-package all-the-icons-dired)
(use-package dired-open)
(use-package peep-dired)

; Prettification
(use-package doom-themes)
(use-package smartparens)
(use-package rainbow-mode)
(use-package rainbow-delimiters)
(use-package rainbow-identifiers)
(use-package all-the-icons)
(use-package org-bullets)
(use-package doom-modeline :ensure t)
(use-package beacon)

; Misc
(use-package vterm)
(use-package treemacs)
(use-package sudo-edit)

;; Rainbows
(require 'rainbow-mode)
(require 'rainbow-delimiters)
(require 'rainbow-identifiers)

(add-hook 'prog-mode-hook 'rainbow-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'prog-mode-hook 'rainbow-identifiers-mode)

;; Ido mode
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)
(setq ido-everywhere t)
(ido-mode 1)

(use-package ido-vertical-mode
	:ensure t
	:init
	(ido-vertical-mode 1))

(use-package smex
	:ensure t
	:init (smex-initialize))

;; Smartparens
(require 'smartparens-config)
(smartparens-global-mode)

;; Misc
(defalias 'yes-or-no-p 'y-or-n-p)
(setq evil-emacs-state-modes (delq 'ibuffer-mode evil-emacs-state-modes))
(setq scroll-conservatively 10000)
(setq scroll-step 1)
(setq auto-window-vscroll nil)
(setq ring-bell-function 'ignore)
(setq visible-bell t)
(beacon-mode 1)

;; Keybindings

; Instead of typing ESC-ESC-ESC or C-g, just press ESC
(global-set-key (kbd "<escape>") 'abort-minibuffers)

; kill the current buffer with 'q'
(define-key evil-normal-state-map (kbd "<remap> <evil-record-macro>") #'(lambda ()
																		 (interactive)
																		 (when (buffer-modified-p)
																		   (when (y-or-n-p "Buffer modified. Save?")
																			 (save-buffer)))
																		 (kill-buffer (buffer-name))))

(global-set-key (kbd "DEL") 'backward-delete-char)
(setq c-backspace-function 'backward-delete-char)

(defun bugger/killBuffer ()
	(interactive)
  (when (buffer-modified-p)
    (when (y-or-n-p "Buffer modified. Save?")
	  (save-buffer)))
  (kill-buffer (buffer-name)))
(defun bugger/killBufferAndWindow ()
	(interactive)
  (when (buffer-modified-p)
    (when (y-or-n-p "Buffer modified. Save?")
	  (save-buffer)))
  (kill-buffer (buffer-name)))

; Doom-like bindings
(nvmap :prefix "SPC"
	   ; Buffers
	   "b i" '(ibuffer :which-key "Ibuffer")
	   "b c" '(bugger/killBuffer :which-key "Close the current buffer")
	   "b k" '(bugger/killBufferAndWindow :which-key "Close the current buffer and window")
	   "b b" '(pop-to-buffer :which-key "Open a buffer in a new window")

	   ; Windows
	   "w v" '(evil-window-vsplit :which-key "Open a vertical split")
	   "w w" '(evil-window-next :which-key "Switch to the next window")
	   "w n" '(evil-window-new :which-key "Open a horizontal split")
	   "w c" '(evil-window-delete :which-key "Close the current window")
	   "w k" '(bugger/killBufferAndWindow :which-key "Close the current buffer and window")

	   ; Dired
	   "d d" '(dired :which-key "Open dired")
	   "d j" '(dired-jump :which-key "Open dired in the current directory")
	   "d p" '(peep-dired :which-key "Activate peep-dired")

	   ; Files
	   "."   '(find-file :which-key "Open a file")
	   "f s" '(save-buffer :which-key "Save file")
	   "f r" '(recentf-open-files :which-key "List recent files to open")
	   "f u" '(sudo-edit-find-file :which-key "Find file as root")
	   "f U" '(sudo-edit :which-key "Edit as root")
	   )

; Nice to have pager-like scrolling
(global-set-key (kbd "C-j") #'(lambda ()
								(interactive)
								(evil-scroll-down 1)))
(global-set-key (kbd "C-k") #'(lambda ()
								(interactive)
								(evil-scroll-up 1)))

; Dired keybindings
(with-eval-after-load 'dired
  (evil-define-key 'normal dired-mode-map (kbd "h") 'dired-up-directory)
  (evil-define-key 'normal dired-mode-map (kbd "l") 'dired-open-file) ; use dired-find-file instead if not using dired-open package
  (evil-define-key 'normal peep-dired-mode-map (kbd "j") 'peep-dired-next-file)
  (evil-define-key 'normal peep-dired-mode-map (kbd "k") 'peep-dired-prev-file))

; Miscellaneous keybindings
(global-set-key (kbd "M-x") 'smex)

;; LSP
(setq lsp-keymap-prefix "c-l")
(add-hook 'c++-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'cc-mode-hook #'lsp)
(add-hook 'java-mode-hook #'lsp)
(add-hook 'sh-mode-hook #'lsp)
(add-hook 'haskell-mode-hook #'lsp)

; Performance improvement
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1 mb
(setq lsp-use-plists t)
(setq lsp-idle-delay 0.500)
(setq lsp-log-io nil)

;; Tabs
(setq-default c-default-style "stroustrup"
	      c-basic-offset 4
	      tab-width 4
	      indent-tabs-mode t)
(defvaralias 'c-basic-offset 'tab-width)
(add-hook 'haskell-indentation-mode-hook #'(lambda () (interactive) (setq-default indent-tabs-mode t)))
(global-set-key (kbd "TAB") 'tab-to-tab-stop)
(define-key evil-insert-state-map (kbd "<remap> <indent-for-tab-command>") 'tab-to-tab-stop)
(define-key evil-insert-state-map (kbd "<remap> <c-indent-line-or-region>") 'tab-to-tab-stop)

;; Movement
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(setq-default evil-cross-lines t)

;; Start page
(setq initial-buffer-choice "~/.config/emacs/start.org")
(define-minor-mode start-mode
  "Defines a custom mode for the start page"
  :lighter " start"
  :keymap (let ((map (make-sparse-keymap)))
          ;;(define-key map (kbd "M-z") 'eshell)
            (evil-define-key 'normal start-mode-map
              (kbd "e") #'(lambda () (interactive) (find-file "~/.config/emacs/init.el"))
              (kbd "z") #'(lambda () (interactive) (find-file "~/.config/zsh/.zshrc"))
              (kbd "p") #'(lambda () (interactive) (find-file "~/.config/polybar/config.ini"))
              (kbd "a") #'(lambda () (interactive) (find-file "~/.config/alacritty/alacritty.yml"))
              (kbd "x") #'(lambda () (interactive) (find-file "~/.config/xmonad/xmonad.hs"))
              (kbd "f") 'find-file
              (kbd "d") 'dired)
          map))

(add-hook 'start-mode-hook 'read-only-mode)
(provide 'start-mode)
(setq org-link-elisp-skip-confirm-regexp "\\`find-file*\\'")
;(define-key start-mode-map (kbd "e") '(lambda () (find-file (concat (getenv "HOME") "/.config/emacs/init.el"))))
;(define-key start-mode-map (kbd "f") 'find-file)

;; Org Mode

; Bullets
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-hide-leading-stars t)
(add-hook 'org-mode-hook #'(lambda ()
							(interactive)
							(local-unset-key (kbd "RET"))
							(local-set-key (kbd "RET") (org-open-at-point))))

; Some QOL for link handling
(setq-default org-link-elisp-confirm-function nil)
(add-hook 'org-mode-hook #'(lambda () (setq-default org-return-follows-link t)))

; Some stuff i straight up ripped from doom emacs
(defun org/return ()
  "Call `org-return' then indent (if `electric-indent-mode' is on)."
  (interactive)
  (org-return electric-indent-mode))

;;;###autoload
(defun org/dwim-at-point (&optional arg)
  "Do-what-I-mean at point.

If on a:
- checkbox list item or todo heading: toggle it.
- citation: follow it
- headline: cycle ARCHIVE subtrees, toggle latex fragments and inline images in
  subtree; update statistics cookies/checkboxes and ToCs.
- clock: update its time.
- footnote reference: jump to the footnote's definition
- footnote definition: jump to the first reference of this footnote
- timestamp: open an agenda view for the time-stamp date/range at point.
- table-row or a TBLFM: recalculate the table's formulas
- table-cell: clear it and go into insert mode. If this is a formula cell,
  recaluclate it instead.
- babel-call: execute the source block
- statistics-cookie: update it.
- src block: execute it
- latex fragment: toggle it.
- link: follow it
- otherwise, refresh all inline images in current tree."
  (interactive "P")
  (if (button-at (point))
      (call-interactively #'push-button)
    (let* ((context (org-element-context))
           (type (org-element-type context)))
      ;; skip over unimportant contexts
      (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
        (setq context (org-element-property :parent context)
              type (org-element-type context)))
      (pcase type
        ((or `citation `citation-reference)
         (org-cite-follow context arg))

        (`headline
         (cond ((memq (bound-and-true-p org-goto-map)
                      (current-active-maps))
                (org-goto-ret))
               ((and (fboundp 'toc-org-insert-toc)
                     (member "TOC" (org-get-tags)))
                (toc-org-insert-toc)
                (message "Updating table of contents"))
               ((string= "ARCHIVE" (car-safe (org-get-tags)))
                (org-force-cycle-archived))
               ((or (org-element-property :todo-type context)
                    (org-element-property :scheduled context))
                (org-todo
                 (if (eq (org-element-property :todo-type context) 'done)
                     (or (car (+org-get-todo-keywords-for (org-element-property :todo-keyword context)))
                         'todo)
                   'done))))
         ;; Update any metadata or inline previews in this subtree
         (org-update-checkbox-count)
         (org-update-parent-todo-statistics)
         (when (and (fboundp 'toc-org-insert-toc)
                    (member "TOC" (org-get-tags)))
           (toc-org-insert-toc)
           (message "Updating table of contents"))
         (let* ((beg (if (org-before-first-heading-p)
                         (line-beginning-position)
                       (save-excursion (org-back-to-heading) (point))))
                (end (if (org-before-first-heading-p)
                         (line-end-position)
                       (save-excursion (org-end-of-subtree) (point))))
                (overlays (ignore-errors (overlays-in beg end)))
                (latex-overlays
                 (cl-find-if (lambda (o) (eq (overlay-get o 'org-overlay-type) 'org-latex-overlay))
                             overlays))
                (image-overlays
                 (cl-find-if (lambda (o) (overlay-get o 'org-image-overlay))
                             overlays)))
           (+org--toggle-inline-images-in-subtree beg end)
           (if (or image-overlays latex-overlays)
               (org-clear-latex-preview beg end)
             (org--latex-preview-region beg end))))

        (`clock (org-clock-update-time-maybe))

        (`footnote-reference
         (org-footnote-goto-definition (org-element-property :label context)))

        (`footnote-definition
         (org-footnote-goto-previous-reference (org-element-property :label context)))

        ((or `planning `timestamp)
         (org-follow-timestamp-link))

        ((or `table `table-row)
         (if (org-at-TBLFM-p)
             (org-table-calc-current-TBLFM)
           (ignore-errors
             (save-excursion
               (goto-char (org-element-property :contents-begin context))
               (org-call-with-arg 'org-table-recalculate (or arg t))))))

        (`table-cell
         (org-table-blank-field)
         (org-table-recalculate arg)
         (when (and (string-empty-p (string-trim (org-table-get-field)))
                    (bound-and-true-p evil-local-mode))
           (evil-change-state 'insert)))

        (`babel-call
         (org-babel-lob-execute-maybe))

        (`statistics-cookie
         (save-excursion (org-update-statistics-cookies arg)))

        ((or `src-block `inline-src-block)
         (org-babel-execute-src-block arg))

        ((or `latex-fragment `latex-environment)
         (org-latex-preview arg))

        (`link
         (let* ((lineage (org-element-lineage context '(link) t))
                (path (org-element-property :path lineage)))
           (if (or (equal (org-element-property :type lineage) "img")
                   (and path (image-type-from-file-name path)))
               (+org--toggle-inline-images-in-subtree
                (org-element-property :begin lineage)
                (org-element-property :end lineage))
             (org-open-at-point arg))))

        (`paragraph
         (+org--toggle-inline-images-in-subtree))

        ((guard (org-element-property :checkbox (org-element-lineage context '(item) t)))
         (let ((match (and (org-at-item-checkbox-p) (match-string 1))))
           (org-toggle-checkbox (if (equal match "[ ]") '(16)))))

        (_
         (if (or (org-in-regexp org-ts-regexp-both nil t)
                 (org-in-regexp org-tsr-regexp-both nil  t)
                 (org-in-regexp org-link-any-re nil t))
             (call-interactively #'org-open-at-point)
           (+org--toggle-inline-images-in-subtree
            (org-element-property :begin context)
            (org-element-property :end context))))))))

(defun org/shift-return (&optional arg)
  "Insert a literal newline, or dwim in tables.
Executes `org-table-copy-down' if in table."
  (interactive "p")
  (if (org-at-table-p)
      (org-table-copy-down arg)
    (org-return nil arg)))

(add-hook 'org-mode-hook #'(lambda ()
							 (interactive)
							 (evil-local-set-key 'insert (kbd "<return>") 'org/return)
							 (evil-local-set-key 'insert (kbd "S-<return>") 'org/shift-return)
							 (evil-local-set-key 'normal (kbd "<return>") 'org/dwim-at-point)))

; Pretty colors and sizes for org mode
(defun bugger/org-colors-molokai ()
(dolist
	(face
	 '((org-level-1       1.7 "#fb2874" ultra-bold)
	   (org-level-2       1.6 "#fd971f" extra-bold)
	   (org-level-3       1.5 "#9c91e4" bold)
	   (org-level-4       1.4 "#268bd2" semi-bold)
	   (org-level-5       1.3 "#e74c3c" normal)
	   (org-level-6       1.2 "#b6e63e" normal)
	   (org-level-7       1.1 "#66d9ef" normal)
	   (org-level-8       1.0 "#e2c770" normal)
	   (org-table         1.0 "#d4d4d4" normal)
	   (org-table-header  1.0 "#d4d4d4" normal)
	   (org-link          1.3 "#9c91e4" normal)))
	(set-face-attribute (nth 0 face) nil :family 'JetBrainsMono :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
	(set-face-attribute 'org-table nil :family 'JetBrainsMono :weight 'normal :height 1.0 :foreground "#d4d4d4"))

; thanks dt for this one
(defun dt/org-colors-doom-one ()
  "Enable Doom One colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.7 "#51afef" ultra-bold)
         (org-level-2 1.6 "#c678dd" extra-bold)
         (org-level-3 1.5 "#98be65" bold)
         (org-level-4 1.4 "#da8548" semi-bold)
         (org-level-5 1.3 "#5699af" normal)
         (org-level-6 1.2 "#a9a1e1" normal)
         (org-level-7 1.1 "#46d9ff" normal)
         (org-level-8 1.0 "#ff6c6b" normal)))
    (set-face-attribute (nth 0 face) nil :family 'JetBrainsMono :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :family 'JetBrainsMono :weight 'normal :height 1.0 :foreground "#bfafdf"))
(dt/org-colors-doom-one)

;; Dired
; Previews
(add-hook 'peep-dired-hook 'evil-normalize-keymaps)
; Pretty icons
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
; Open things nicely
(setq dired-open-extensions '(("gif" . "mpv")
							  ("jpg" . "feh")
							  ("png" . "feh")
							  ("mkv" . "mpv")
							  ("mp4" . "mpv")
							  ("mp3" . "mpv")))

;; Pretty theme
(use-package doom-themes
	:ensure t)
(add-hook 'start-mode-hook #'(lambda () (load-theme 'doom-one)))
 ;'(default ((t (:inherit nil :extend nil :stipple nil :background "#1e1e1e" :foreground "#d4d4d4" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 135 :width normal :foundry "ADBO" :family "JetBrainsMono")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-dark+))
 '(custom-safe-themes
   '("2721b06afaf1769ef63f942bf3e977f208f517b187f2526f0e57c1bd4a000350" "89d9dc6f4e9a024737fb8840259c5dd0a140fd440f5ed17b596be43a05d62e67" "b99e334a4019a2caa71e1d6445fc346c6f074a05fcbb989800ecbe54474ae1b0" "02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" "be84a2e5c70f991051d4aaf0f049fa11c172e5d784727e0b525565bb1533ec78" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" default))
 '(evil-undo-system 'undo-redo)
 '(org-return-follows-link t)
 '(package-selected-packages
   '(spaceline-config which-key vterm use-package sudo-edit spaceline smex smartparens rainbow-mode rainbow-identifiers rainbow-delimiters peep-dired org-bullets key-chord ido-vertical-mode general evil-collection emojify-logos doom-themes dired-open company beacon all-the-icons-dired))
 '(warning-suppress-types '((use-package) (use-package) (lsp-mode) (lsp-mode) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :background "#1c1e1f" :foreground "#d6d6d4" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "JB" :family "JetBrains Mono")))))
