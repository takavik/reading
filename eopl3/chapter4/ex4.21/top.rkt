#lang eopl

;; top level module.  Loads all required pieces.
;; Run the test suite with (run-all).

(require "lang.rkt")             ; for scan&parse
(require "interp.rkt")           ; for value-of-program

(provide (all-defined-out))
(provide run)

;; run : String -> ExpVal

(define run
  (lambda (string)
    (value-of-program (scan&parse string))))