#lang eopl

;; top level module.  Loads all required pieces.

(require "lang.rkt")            ; for scan&parse
(require "interp.rkt")          ; for value-of-program
(require "translator.rkt")      ; for translation-of-program

(provide run)

;; run : String -> ExpVal
;; Page: 98
(define run
  (lambda (string)
    (value-of-translation
     	(translation-of-program
         	  (scan&parse string)))))
