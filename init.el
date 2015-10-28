(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)


;; General Configuration

;; customize window title
(setq frame-title-format "You're Such a NERD")
;; highlights parenthesis
(global-hl-line-mode)
;; easier navigating through windows
(winner-mode t)
(show-paren-mode)
;;
(windmove-default-keybindings)
;; No startup message
(setq inhibit-startup-message t)
;; UTF-8 encoding for everything
(prefer-coding-system 'utf-8)
;; No tool bar
(tool-bar-mode -1)
;; No menu bar
;;(menu-bar-mode -1)
;; Show column number
(column-number-mode t)
;; No backups
(setq backup-inhibitied -1)
;; Mouse scroll one line at a time
(setq mouse-wheel-follow-mouse 't)
;; Keyboard scroll one line at a time
(setq scroll-step 1)
;; Line numbers
(global-linum-mode 1)
;; Global electric mode
(electric-pair-mode)
;; Clean white spaces on save
(add-hook 'before-save-hook 'whitespace-cleanup)
;; Tabs for makefiles
(add-hook 'makefile-mode 'indent-tabs-mode)
;; Stop curso from jumping into minibuffer by itself
(setq minibuffer-prompt-properties
      (quote (read-only t point-entered minibuffer-avoid-prompt
			face minibuffer-prompt)))

;; Transparent emacs
 ;;(set-frame-parameter (selected-frame) 'alpha '(<active> [<inactive>]))
 (set-frame-parameter (selected-frame) 'alpha '(85 50))
 (add-to-list 'default-frame-alist '(alpha 85 50))

 (eval-when-compile (require 'cl))
 (defun toggle-transparency ()
   (interactive)
   (if (/=
	(cadr (frame-parameter nil 'alpha))
	100)
       (set-frame-parameter nil 'alpha '(100 100))
     (set-frame-parameter nil 'alpha '(85 50))))
 (global-set-key (kbd "C-c t") 'toggle-transparency)

 ;; Set transparency of emacs
 (defun transparency (value)
   "Sets the transparency of the frame window. 0=transparent/100=opaque"
   (interactive "nTransparency Value 0 - 100 opaque:")
   (set-frame-parameter (selected-frame) 'alpha value))

;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)

;;; auto complete mod
;;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)
;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;;; tempo-c-cpp.el --- abbrevs for c/c++ programming
;;
;; Copyright (C) 2008  Sebastien Varrette
;;
;; Author: Sebastien Varrette <Sebastien.Varrette@uni.lu>
;; Maintainer: Sebastien Varrette <Sebastien.Varrette@uni.lu>
;; Created: 18 Jan 2008
;; Version: 0.1
;; Keywords: template, C, C++

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary
;;
;; This is a way to hook tempo into cc-mode. In fact, I merge here many ressources, including:
;; - http://www.lysator.liu.se/~davidk/elisp/tempo-examples.html
;; - http://svn.marc.abramowitz.info/homedir/dotfiles/emacs
;; - http://www.emacswiki.org/cgi-bin/wiki/TempoMode
;; etc...
;;
;; To use this file, just put a (require 'tempo-c-cpp) in your .emacs file
;;
;; Note on tempo (from EmacsWiki):
;; templates are defined through tempo-define-template. they uses (p ...) to prompt for variables
;; and (s ...) to insert them again. > indents, n inserts a newline, and r inserts the region, if active.
;;
;; To use the templates defined here:
;; - either run M-x tempo-template-c-<xx> where <xx> is the name of the template (use TAB to have the list)
;; - or start to type the corresponding abbreviation (list follows) and hit C-RET or F5
;;
;; Feel free to adapt the templates to your own programming style.
;;
;; List of abbreviations:
;;	<abbrev>		<correspondant sequence>
;; ---- Preprocessor statements ---
;;	include			#include
;;	define			#define
;;	ifdef			#ifdef
;;	ifndef			#ifndef
;; --- C statements
;;	if			if (...) { }
;;	else			else { ... }
;;	ifelse			if (...) { } else { }
;;	while			while (...) { }
;;	for			for (...) { }
;;	fori			for (i=0; i < limit; i++) { }
;;	switch			switch() {...}
;;	case			case: ... break;
;;	main			int main() { ... }
;;	malloc			type * var = (type *) malloc(...)
;; --- C++ statements
;;    class			class xxx { ... };
;;    getset			accessor/mutator

(require 'tempo)
(setq tempo-interactive t)

(defvar c-tempo-tags nil
  "Tempo tags for C mode")

(defvar c++-tempo-tags nil
  "Tempo tags for C++ mode")

(defvar c-tempo-keys-alist nil
  "")

(defun my-tempo-c-cpp-bindings ()
  ;;(local-set-key (read-kbd-macro "<f8>") 'tempo-forward-mark)
  (local-set-key (read-kbd-macro "C-<return>")   'tempo-complete-tag)
  (local-set-key (read-kbd-macro "<f5>")   'tempo-complete-tag)
  (tempo-use-tag-list 'c-tempo-tags)
  (tempo-use-tag-list 'c++-tempo-tags))

(add-hook 'c-mode-hook   '(lambda () (my-tempo-c-cpp-bindings)))
(add-hook 'c++-mode-hook '(lambda () (my-tempo-c-cpp-bindings)))

;; the following macros allow to set point using the ~ character in tempo templates

(defvar tempo-initial-pos nil
   "Initial position in template after expansion")
 (defadvice tempo-insert( around tempo-insert-pos act )
3   "Define initial position."
   (if (eq element '~)
	 (setq tempo-initial-pos (point-marker))
     ad-do-it))
 (defadvice tempo-insert-template( around tempo-insert-template-pos act )
   "Set initial position when defined. ChristophConrad"
   (setq tempo-initial-pos nil)
   ad-do-it
   (if tempo-initial-pos
       (progn
	 (put template 'no-self-insert t)
	 (goto-char tempo-initial-pos))
    (put template 'no-self-insert nil)))

;;; Preprocessor Templates (appended to c-tempo-tags)
(tempo-define-template "c-include"
		       '("#include <" r ".h>" > n
			 )
		       "include"
		       "Insert a #include <> statement"
		       'c-tempo-tags)

(tempo-define-template "c-define"
		       '("#define " r " " > n
			 )
		       "define"
		       "Insert a #define statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifdef"
		       '("#ifdef " (p "ifdef-condition: " clause) > n> p n
			 "#else /* !(" (s clause) ") */" n> p n
			 "#endif // " (s clause) n>
			 )
		       "ifdef"
		       "Insert a #ifdef #else #endif statement"
		       'c-tempo-tags)

(tempo-define-template "c-ifndef"
		       '("#ifndef " (p "ifndef-clause: " clause) > n
			 "#define " (s clause) n> p n
			 "#endif // " (s clause) n>
			 )
		       "ifndef"
		       "Insert a #ifndef #define #endif statement"
		       'c-tempo-tags)

;;; C-Mode Templates
(tempo-define-template "c-if"
		       '(> "if (" ~ " ) { "  n>
			 > n
			 "}" > n>
			 )
		       "if"
		       "Insert a C if statement"
		       'c-tempo-tags)

(tempo-define-template "c-else"
		       '(> "else {" n>
			 > ~ n
			 "}" > n>
			 )
		       "else"
		       "Insert a C else statement"
		       'c-tempo-tags)

(tempo-define-template "c-if-else"
		       '(> "if (" ~ " ) { "  n>
			 > n
			 "} else {" > n>
			 > n
			 "}" > n>
			 )
		       "ifelse"
		       "Insert a C if else statement"
		       'c-tempo-tags)

(tempo-define-template "c-while"
		       '(> "while (" ~ " ) { "  n>
			 > n
			 "}" > n>
			 )
		       "while"
		       "Insert a C while statement"
		       'c-tempo-tags)

(tempo-define-template "c-for"
		       '(> "for (" ~ " ) { "  n>
			 > n
			 "}" > n>
			 )
		       "for"
		       "Insert a C for statement"
		       'c-tempo-tags)

(tempo-define-template "c-for-i"
		       '(> "for (" (p "variable: " var) " = 0; " (s var)
			 " < "(p "upper bound: " ub)"; " (s var) "++) {" >  n>
			 > r n
			 "}" > n>
			 )
		       "fori"
		       "Insert a C for loop: for(x = 0; x < ..; x++)"
		       'c-tempo-tags)

(tempo-define-template "c-malloc"
		       '(>(p "type: " type) " * " (p "variable name: " var) " = (" (s type) " *) malloc(sizeof(" (s type) "));" n>
			  "if (" (s var) " == NULL) {" n>
			  > r n
			 "}" > n>
			 )
		       "malloc"
		       "Insert a C malloc statement to define and allocate a pointer"
		       'c-tempo-tags)

(tempo-define-template "c-main"
		       '(> "int main(int argc, char *argv[]) {" >  n>
			 > r n
			 "return 0;" > n
			 "}" > n>
			 )
		       "main"
		       "Insert a C main statement"
		       'c-tempo-tags)

(tempo-define-template "c-switch"
		       '(> "switch(" (p "variable to check: " clause) ") {" >  n>
			 "case " > (p "first value: ") ": " ~ > n>
			 " break;" > n>
			 >"default:" > n>
			 "}" > n>
			 )
		       "switch"
		       "Insert a C switch statement"
		       'c-tempo-tags)

(tempo-define-template "c-case"
		       '("case " (p "value: ") ":" ~ > n>
			   "break;" > n>
			)
		       "case"
		       "Insert a C case statement"
		       'c-tempo-tags)

;;;C++-Mode Templates
(setq max-lisp-eval-depth 500)

(tempo-define-template "c++-class"
			'("/**" > n>
			  "* Filename: "  n>
			  "* Author: Benito Sanchez " n>
			  "* Date: " n>
			  "* Description: " n>
			  > n>
			  "*/" > n>
			  "class " (p "classname: " class) " {" > n>




			  "public:" > n>
			  > n>
			  "// ****************************************************************" n>
			  (s class) "(); " n>
			  "// ****************************************************************" n>
			  "// SUMMARY: " n>
			  "// " n>
			  "// PRECONDITION: " n>
			  "// " n>
			  "// POSTCONDITION: " n>
			  "// " n>
			  "// ****************************************************************" n>
			  > n>

			  "// ****************************************************************" n>
			  (s class) "(const " (s class) " &c);" n>
			  "// ****************************************************************" n>
			  "// SUMMARY: " n>
			  "// " n>
			  "// PRECONDITION: " n>
			  "// " n>
			  "// POSTCONDITION: " n>
			  "// " n>
			  "// ****************************************************************" n>
			  > n>

			  "// ****************************************************************" n>
			  "~" (s class) "() {}" > n>
			  "// ****************************************************************" n>
			  "// SUMMARY: " n>
			  "// " n>
			  "// PRECONDITION: " n>
			  "// " n>
			  "// POSTCONDITION: " n>
			  "// " n>
			  "// ****************************************************************" n>
			  > n>
			  > n>

			  "/* Accessors */" > n>


			  "/* Mutators */" > n>


			  "private:" > n>


			 "};\t// end of class " (s class) > n>
			 )
		       "class"
		       "Insert a class skeleton"
		       'c++-tempo-tags)

(tempo-define-template "c++-getset"
		       '((p "type: "     type 'noinsert)
			 (p "variable: " var  'noinsert)
			 (tempo-save-named 'virtual (if (y-or-n-p  "virtual?") "virtual " ""))
			 (tempo-save-named 'm_var (concat "_" (tempo-lookup-named 'var)))
			 (tempo-save-named 'fnBase (upcase-initials (tempo-lookup-named 'var)))
			 (s type) " " (s m_var) ";" > n>
			 (s virtual) (s type) " get" (s fnBase) "() const { return "(s m_var) "; }" > n>
			 (s virtual) "void set" (s fnBase) "(" (s type) " " (s var) ") { " (s m_var) " = " (s var) "; }" > n>
			 )
		       "getset"
		       "Insert get set methods"
		       'c++-tempo-tags)

(provide 'tempo-c-cpp)
;;; tempo-c-cpp.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (wheatgrass)))
 '(custom-safe-themes (quote ("b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "7bde52fdac7ac54d00f3d4c559f2f7aa899311655e7eb20ec5491f3b5c533fe8" "90d329edc17c6f4e43dbc67709067ccd6c0a3caa355f305de2041755986548f2" default)))
 '(linum-format " %7i "))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
