#lang racket 

(require "data-structures.rkt" "store.rkt" eopl)

(provide init-env empty-env extend-env apply-env)

;;;;;;;;;;;;;;;; initial environment ;;;;;;;;;;;;;;;;

;; init-env : () -> Env
;; (init-env) builds an environment in which:
;; i is bound to a location containing the expressed value 1, 
;; v is bound to a location containing the expressed value 5, and 
;; x is bound to a location containing the expressed value 10.  
(define init-env 
  (lambda ()
    (extend-env 
     'i (newref (num-val 1))
     (extend-env
      'v (newref (num-val 5))
      (extend-env
       'x (newref (num-val 10))
       (empty-env))))))

;;;;;;;;;;;;;;;; environment constructors and observers ;;;;;;;;;;;;;;;;

(define apply-env
  (lambda (env search-var)
    (cases environment env
      (empty-env
       ()
       (eopl:error 'apply-env "No binding for ~s" search-var))
      (extend-env
       (bvar bval saved-env)
       (if (eqv? search-var bvar)
           bval
           (apply-env saved-env search-var)))
      (extend-env-rec*
       (p-names b-vars p-bodies saved-env cache)
       (cond ((index-of p-names search-var)
              =>
              (lambda (n)
                (unless (vector-ref cache n)
                  (vector-set!
                   cache n (newref
                            (proc-val
                             (procedure 
                              (list-ref b-vars n)
                              (list-ref p-bodies n)
                              env)))))
                (vector-ref cache n)))
             (else (apply-env saved-env search-var)))))))
