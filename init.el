;; Setting up your own config documentation:
;;
;; https://sam217pa.github.io/2016/09/02/how-to-build-your-own-spacemacs/
;; https://dev.to/huytd/emacs-from-scratch-1cg6
;; https://sam217pa.github.io/2016/09/13/from-helm-to-ivy/#fnref:2
;; 

(server-start) ;; starts up the emacs daemon. From terminal use emacsclient, or just start the gui. Multiple gui windows will all connect to the same daemon.

;; `setq' quotes the first argument automatically so it isn't symbolically executed (i.e. no need to do (set 'delete-old-versions -1)). If the setting has a buffer local value by default, (describe-variable will tell you) use `setq-default' instead so it sets it default for all buffers instead of just the init buffer.
(setq delete-old-versions -1        ; delete excess backup versions silently
      version-control t             ; use version control
      vc-make-backup-files t        ; make backups file even when in version controlled dir
      backup-directory-alist `(("." . "~/.emacs.d/backups")) ; which directory to put backups file
      vc-follow-symlinks t          ; don't ask for confirmation when opening symlinked file
      auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)) ;transform backups file name
      inhibit-startup-screen t      ; inhibit useless and old-school startup screen
      ring-bell-function 'ignore    ; silent bell when you make a mistake
      coding-system-for-read 'utf-8 ; use utf-8 by default
      coding-system-for-write 'utf-8
      sentence-end-double-space nil  ; sentence SHOULD end with only a point.
      default-fill-column 80         ; toggle wrapping text at the 80th character
      initial-scratch-message "Welcome in Emacs" ; print a default message in the empty scratch buffer opened at startup
      lexical-binding t              ; enable lexical-binding for this buffer instead of dynamic binding (extremely slow)
      winner-mode 1                  ; restore previous window arrangements and buffer contents of those windows
      global-auto-revert-mode t      ; auto-sync files when modified on disk
      electric-pair-mode t           ; auto parentheses pairing
      show-paren-delay 0             ; no delay for highlighting paren in show-paren-mode
      show-paren-mode 1              ; highlight pairing parentheses with cursor
      )

(require 'package)

(setq package-enable-at-startup nil) ; tells emacs not to load any packages before starting up

;; the following lines tell emacs where on the internet to look up for new packages
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize) ; activates the package package

;; bootstrap `use-package'
(unless (package-installed-p 'use-package) ; unless use-package is already installed
  (package-refresh-contents)		   ; update packages archive
  (package-install 'use-package)) ; and install the most recent version of use-package

(require 'use-package)

;; Vim mode
(use-package evil :ensure t
  :config
  (evil-mode 1)
  (setq-default evil-escape-delay 0.2)
  ) ; evil config guide -- https://github.com/noctuid/evil-guide

;; Minimal UI
(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)

;; Theme
 (use-package doom-themes :ensure t :config (load-theme 'doom-city-lights t))

(use-package helpful :ensure t) ;; gives much more context/information/examples then the built in help

;; auto-complete/narrowing search frameworks
(use-package ivy :ensure t) ; narrow completion framework - comes up in a minibuffer by default
(use-package counsel :ensure t) ; auto-completion framework in buffers
(use-package swiper :ensure t) ; a use of ivy to narrow down searches in a buffer

;; key-bindings
(use-package general :ensure t
  :config
  (general-define-key
   "C-'" #'avy-goto-word-1
   "C-/" #'swiper
   )
  )

(use-package which-key :ensure t
  :config
  (which-key-mode 1)
  (setq which-key-idle-delay 0.05)	   ; delay before window popup
  (setq which-key-popup-type 'side-window)) ; default, like it the most

(use-package avy :ensure t
  :commands (avy-goto-word-1)) ; trigger loading of package when the command `avy-goto-word-1' is used

;; Multi-Term
(use-package multi-term
  :ensure t
  :init
(setq multi-term-program "/bin/bash"))

;; Ranger
(use-package ranger 
  :ensure t
  :init
  (setq ranger-show-hidden t))

;; Code commenting
(use-package evil-nerd-commenter :ensure t)

;; Project management
(use-package projectile
  :ensure t
  :init
  (setq projectile-completion-system 'ivy)
  :config
  (projectile-mode))
(use-package counsel-projectile 
  :ensure t
  :config
  (counsel-projectile-mode))

;; Workspaces
(use-package perspective
  :ensure t
  :config
  (persp-mode))
(use-package persp-projectile
  :ensure t)

;; Surround
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package ace-window :ensure t
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package elisp-slime-nav :ensure t
  :config
  (elisp-slime-nav-mode 1))

(use-package general :ensure t
  :config 
  (general-define-key
   "M-x" 'counsel-M-x
   "M-o" 'ace-window
   "C-h j" 'elisp-slime-nav-describe-elisp-thing-at-point
   "C-h f" #'helpful-callable
   "C-h F" #'helpful-function ;;
   "C-h v" #'helpful-variable ;; describe variable
   "C-h k" #'helpful-key
   "C-h p" #'helpful-at-point ;; figure out the type of symbol and find help for it
   "C-h C" #'helpful-command) ;; interactive commands
  (general-define-key
    :states '(normal)
   "0"  'evil-first-non-blank
   "^"  'evil-digit-argument-or-evil-beginning-of-line)
  (general-define-key
   :states '(normal visual emacs)
   "/" 'swiper
   "gcc" 'evilnc-comment-or-uncomment-lines)
  (general-define-key
   :states '(normal visual)
   "C-u" 'scroll-down-command
   "C-d" 'scroll-up-command)
  (general-define-key
   :states '(normal visual insert emacs)
   "C-c p" 'paste-from-os
   "C-c y" 'copy-to-os
   "C-c x" 'cut-to-os
   "C-]"   'elisp-slime-nav-find-elisp-thing-at-point)
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "C-SPC"
   "'"   'multi-term
   "/"   'counsel-rg
   ":"   'counsel-M-x
   "."   'edit-emacs-configuration
   "TAB" 'toggle-buffers

   "a" '(:ignore t :which-key "Applications")
   "ar" 'ranger
   "ad" 'deer

   "b" '(:ignore t :which-key "Buffers")
   "bb"  'ivy-switch-buffer
   "bd" 'kill-buffer

   "e" 'eval-exp-by-context
   
   "g" '(:ignore t :which-key "Code?")
   "gc" 'evilnc-comment-or-uncomment-lines

   "p" 'projectile-command-map
   "pp" 'projectile-persp-switch-project
   "pf" 'counsel-projectile

   "q" 'keyboard-quit

   "s" '(:ignore t :which-key "Search")
   "sc" 'evil-ex-nohighlight
   "sl" 'ivy-resume

   "T" 'counsel-load-theme
   "t" '(:ignore t :which-key "Toggles")
   "tn" 'display-line-numbers-mode
   "tl" 'toggle-truncate-lines

   "u" 'undo-tree-visualize
   
   "x" '(:ignore t :which-key "Text")
   "xl" '(:ignore t :which-key "Lines")
   "xls" 'sort-lines

   "w" '(:ignore t :which-key "Window")
   "wl"  'windmove-right
   "wh"  'windmove-left
   "wk"  'windmove-up
   "wj"  'windmove-down
   "w/"  'split-window-right
   "w-"  'split-window-below
   "wd"  'delete-window
   "we"  'ace-delete-window
   "ws"  'ace-window
   "wr"  'ace-swap-window
   "wf"  'toggle-frame-fullscreen
   "wm"  'toggle-maximize-window
   ))

(defun toggle-maximize-window ()
    (interactive)
    (put 'toggle-maximize-window 'toggle (not (get 'toggle-maximize-window 'toggle)))
    (funcall (if (get 'toggle-maximize-window 'toggle) #'delete-other-windows #'winner-undo)))

;; Edit this config
(defun edit-emacs-configuration ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun toggle-buffers ()
  "Interactive version of (switch-to-buffer nil)"
  (interactive)
(switch-to-buffer nil))

;; make copy/cut/paste work with system clipboard
(cond ((equal system-type 'darwin)
       (progn
	 (defun paste-from-os ()
	   (interactive)
	   (call-process-region (point) (if mark-active (mark) (point)) "pbpaste" t t)
	   (setq deactive-mark t))

	 (defun copy-to-os ()
	   (interactive)
	   (call-process-region (point) (mark) "pbcopy"))

	 (defun cut-to-os ()
	   (interactive)
	   (copy-to-osx)
	   (delete-region (region-beginning) (region-end))))))

(defun eval-exp-by-context (p)
  "If point is on a right parent ) just the previous exp is evaluated. Otherwise it evaluates the outermost exp"
  (interactive "P")
  (if (string-equal (buffer-substring-no-properties (point) (+ (point) 1)) ")")
      (eval-last-sexp p)
      (eval-defun p)))

;; Emacs key notation to know what to type for a given key -- https://www.emacswiki.org/emacs/EmacsKeyNotation

;; keymap info -- https://www.masteringemacs.org/article/mastering-key-bindings-emacs
;; Keymap ordering preference lookup order from first to last:
;;   emulation-mode key map `emulation-mode-map-alists' (e.g. evil mode keybindings)
;;       > minor-mode-overrides key map `minor-mode-overriding-map-alist' (overrides any minor mode key-maps)
;;       > minor-mode key map `minor-mode-map-alist'
;;       > local buffer key map `current-local-map' (local buffer key map is generally populated by major-mode bindings)
;;       > global map `current-global-map'
;; In order to bind a function to a key, the function must be declared as a command, i.e. one that has the (interactive...) statement at the top of the function. The function also must take no parameters when used as a key binding, and if you want to pass arguments, it must be wrapped in a helper function, such as a lambda expression or a defun.

;; evaluations: lists and symbols are evaluated immediately, and therefore must generally be quoted if you want to pass the symbol or list into a function instead of its evaluation. If the symbol contains another symbol as a value, then you might not want to quote it to evaluate to the other symbol. Everything else delays evaluation.
;; To quote: 'x is to quote the symbol (variable) x. (quote x) is equivalent. A list is quoted e.g. '(1 2 3). If not quoted the list would evaluate trying to call the first argument 1 as a function. Every symbol has a "name" cell, a "value" cell, a "function" cell, and a "properties" cell. Use symbol-* functions to access the various cells for a given symbol.

;; comment styleguide (# of semicolons and placement) -- https://www.gnu.org/software/emacs/manual/html_node/elisp/Comment-Tips.html




;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;  Working on understanding setting up general correctly with spacemacs like bindings
;;;;;;;;;;;;;;;;;;




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helpful elisp-slime-nav ace-window multi-term doom-themes which-key counsel ivy evil general use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
