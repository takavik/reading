#lang eopl

(require "data-structures.rkt"
         (only-in racket compose foldr)
         (only-in relation/function curry uncurry))

(provide init-nameless-env 
         empty-nameless-env 
         extend-nameless-env
         apply-nameless-env)

;;;;;;;;;;;;;;;; initial environment ;;;;;;;;;;;;;;;;

;; init-env : () -> Nameless-env

;; (init-env) builds an environment in which i is bound to the
;; expressed value 1, v is bound to the expressed value 5, and x is
;; bound to the expressed value 10.  

(define init-nameless-env
  (lambda ()
    (let ((f (uncurry 
              (compose (curry extend-nameless-env) list num-val))))
      (foldr f (empty-nameless-env) '( 1 5 10)))))
