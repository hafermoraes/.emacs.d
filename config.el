;; Disable startup screen
(setq inhibit-splash-screen t)

;; https://github.com/danielmai/.emacs.d/blob/master/config.org

;; quebra de linha automática
(global-visual-line-mode t)

;; These functions are useful. Activate them.
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

;; Answering just 'y' or 'n' will do
(defalias 'yes-or-no-p 'y-or-n-p)

;; Keep all backup and auto-save files in one directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t)))

;; UTF-8 please
(setq locale-coding-system 'utf-8) ; pretty
(set-terminal-coding-system 'utf-8) ; pretty
(set-keyboard-coding-system 'utf-8) ; pretty
(set-selection-coding-system 'utf-8) ; please
(prefer-coding-system 'utf-8) ; with sugar on top

;; delete the region when typing, just like as we expect nowadays.
(delete-selection-mode t)

;; avisa se parênteses estão em número igual de abertura e fechamento
(show-paren-mode t)

(column-number-mode t)

;; Don't beep at me
(setq visible-bell t)

;; Tema escuro
(load-theme 'wombat t)

(setq user-full-name "Rafael Rodrigues de Moraes"
      user-mail-address "hafer.moraes@gmail.com")

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

(setq ispell-dictionary "brasileiro")

;; easy spell check (fonte: https://www.emacswiki.org/emacs/FlySpell)
(global-set-key (kbd "<f8>") 'ispell-word)
(global-set-key (kbd "<f9>") 'ispell-region)

;; LanguageTool
;(setq langtool-language-tool-jar "/home/claurafa/.emacs.d/languagetool/LanguageTool-4.4/languagetool-commandline.jar")
;(require 'langtool)
;(setq langtool-default-language "pt-BR")
;(setq langtool-mother-tongue "pt")

;(defun langtool-autoshow-detail-popup (overlays)
;  (when (require 'popup nil t)
;    ;; Do not interrupt current popup
;    (unless (or popup-instances
;                ;; suppress popup after type `C-g` .
;                (memq last-command '(keyboard-quit)))
;      (let ((msg (langtool-details-error-message overlays)))
;        (popup-tip msg)))))
;(setq langtool-autoshow-message-function
;      'langtool-autoshow-detail-popup)

;; Autocomplete
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(global-auto-complete-mode t)

;; ESS
(setq ess-use-auto-complete t)

;;; Outline-magic
;(add-hook 'outline-mode-hook 
;          (lambda () 
;            (require 'outline-cycle)))
(add-hook 'outline-minor-mode-hook 
          (lambda () 
            (require 'outline-magic)
            (define-key outline-minor-mode-map  (kbd "<C-tab>") 'outline-cycle)))
(add-hook 'ess-mode-hook
      '(lambda ()
         (outline-minor-mode)
         (setq outline-regexp "#\\{3,5\\} ")
         (defun outline-level ()
           (cond ((looking-at "^### "      ) 1)
		 ((looking-at "^#### "     ) 2)
		 ((looking-at "^##### "    ) 3)
		 ((looking-at "^###### "   ) 4)
		 ;((looking-at "^[a-zA-Z0-9_\.]+ ?<- ?function(.*{") 3)
		 (t 1000)))
         ))

;; R-Markdown
(require 'markdown-mode)
;;(require 'poly-R)
;;(require 'poly-markdown)
;;(add-to-list 'auto-mode-alist '("\\.Rmd\'" . poly-markdown+r-mode))
;;(setq load-path (append ’(“/home/claurafa/.emacs.d/polymode/” “/home/claurafa/.emacs.d/polymode/modes”) load-path))

(use-package org
  :ensure org-plus-contrib)
;(require 'org)


(setq org-image-actual-width 550)

(setq org-highlight-latex-and-related '(latex script entities))

(setq org-hide-emphasis-markers t)

(setq org-export-default-language "pt")

(setq org-support-shift-select (quote always))

(setq interleave-split-direction (quote vertical)
      interleave-split-lines 20
      interleave-disable-narrowing t
      )

;; Org-babel
  (org-babel-do-load-languages
   'org-babel-load-languages
   '( (R . t)
      (org . t)
      (ledger . t)
      (sql . t)
      (shell . t)
      (sqlite . t)
      ))

  (defun my-org-confirm-babel-evaluate (lang body)
    "Do not confirm evaluation for these languages."
    (not (or (string= lang "R")
	     (string= lang "shell")
	     (string= lang "python")
	     (string= lang "emacs-lisp")
	     (string= lang "sqlite"))))
  (setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)

(setq org-confirm-babel-evaluate nil
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-fontify-natively t
      org-src-tab-acts-natively t)

;; Org-Capture
(setq org-default-notes-file (concat org-directory "/inbox.org"))
(define-key global-map (kbd "<f7>") 'org-capture)
;; Templates do Org-Capture
(setq org-capture-templates
      '(("t" "Todo [Inbox]" entry
	 (file+headline "~/org/inbox.org" "Tasks")
        "* TODO %^{Título}\n %^{Breve descritivo da tarefa}\n  %U \n\n")
	("j" "Journal" entry
	 (file+olp+datetree "~/org/journal.org")
	 "* %?\nEntered on %U\n  %i\n  %a")
	))
(setq org-agenda-files '("~/org/inbox.org"
                         "~/org/notes.org"))
(setq org-refile-targets '(("~/org/inbox.org" :maxlevel . 3)
                           ("~/org/notes.org" :maxlevel . 2)))

(setq org-latex-default-packages-alist
      (quote
       (("AUTO" "inputenc" t)
	("T1" "fontenc" t)
	("hidelinks" "hyperref" nil)
	"\\tolerance=1000")))

(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	"bibtex %b"
	"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	"pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-minted-options
      '(
	("frame" "lines")
	("linenos=true")
	("fontsize=\\footnotesize")
	)
      )

;; pdflatex
(require 'ox-latex)
(unless (boundp 'org-latex-classes)
  (setq org-latex-classes nil))
(add-to-list 'org-latex-classes
             '("beamer"
               "\\documentclass\[presentation\]\{beamer\}"
               ("\\section\{%s\}" . "\\section*\{%s\}")
               ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
               ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}"))
             '("article"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
(setq org-latex-to-pdf-process '("texi2dvi --pdf --clean --verbose --batch %f"))

;; reveal.js
(require 'ox-reveal)

;; pdf-tools e midnight mode
(add-hook 'pdf-view-mode-hook (lambda ()
				(pdf-view-midnight-minor-mode))) ; automatically turns on midnight-mode for pdfs
(setq pdf-view-midnight-colors '("light gray" . "gray14" )) ; set the amber profile as default (see below)
(pdf-tools-install)
