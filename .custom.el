(setq-default evil-escape-key-sequence "jk")

;; straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; theme and font
(load-theme 'gruvbox t)
(set-face-attribute 'default nil :font "JetBrains Mono" :height 150)

;; shell
(setq my-term-program "/usr/bin/zsh")

;; org-mode
(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

;; org-roam and dependencies
(require-package 'use-package)
(require-package 'dash)
(require-package 'emacsql)
(require-package 'f)
(require-package 's)
(require-package 'org-roam)

;; org-roam
(use-package org-roam
      :hook
      (after-init . org-roam-mode)
      :custom
      (org-roam-directory "~/Dropbox/org/roam")
      :bind (:map org-roam-mode-map
              (("C-c n l" . org-roam)
               ("C-c n f" . org-roam-find-file)
               ("C-c n j" . org-roam-jump-to-index)
               ("C-c n b" . org-roam-switch-to-buffer)
               ("C-c n t" . org-roam-dailies-today)
               ("C-c n y" . org-roam-dailies-yesterday)
               ("C-c n g" . org-roam-graph))
              :map org-mode-map
              (("C-c n i" . org-roam-insert))))

;; org-fc
(use-package hydra)
(use-package org-fc
  :straight
  (org-fc
   :type git :host github :repo "l3kn/org-fc"
   :files (:defaults "contrib/*.el" "awk" "demo.org"))
  :custom
  (org-fc-directories '("~/Dropbox/org/"))
  :config
  (require 'org-fc-hydra)
  (require 'org-fc-keymap-hint))
(evil-define-minor-mode-key '(normal insert emacs) 'org-fc-review-flip-mode
  (kbd "RET") 'org-fc-review-flip
  (kbd "n") 'org-fc-review-flip
  (kbd "s") 'org-fc-review-suspend-card
  (kbd "q") 'org-fc-review-quit)
(evil-define-minor-mode-key '(normal insert emacs) 'org-fc-review-rate-mode
  (kbd "a") 'org-fc-review-rate-again
  (kbd "h") 'org-fc-review-rate-hard
  (kbd "g") 'org-fc-review-rate-good
  (kbd "e") 'org-fc-review-rate-easy
  (kbd "s") 'org-fc-review-suspend-card
  (kbd "q") 'org-fc-review-quit)

;; org mode
(require-package 'org-superstar)
(add-hook 'org-mode-hook (lambda () (org-superstar-mode 1)))
(setq org-hide-leading-stars t)
(setq org-image-actual-width nil)

;; evil-org
(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; screenshot in org mode
(setq doom-localleader-key ",")
(add-hook 'org-mode-hook
	  (lambda ()
	  (defun ros ()
	    (interactive)
	    (if buffer-file-name
		(progn
		  (message "Waiting for region selection with mouse...")
		  (let ((filename
			 (concat "./images/"
				 (file-name-nondirectory buffer-file-name)
				 "_"
				 (format-time-string "%Y%m%d_%H%M%S")
				 ".png")))
		    (if (executable-find "scrot")
			(call-process "scrot" nil nil nil "-s" filename)
		      (call-process "screencapture" nil nil nil "-s" filename))
		    (insert (concat "[[" filename "]]"))
		    (org-display-inline-images t t)
		    )
		  (message "File created and linked...")
		  )
	      (message "You're in a not saved buffer! Save it first!")
	      )
	    )
	  )
	  )