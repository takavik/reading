#lang eopl

;; interpreter for the EXPLICIT-REFS language

(require "lang.rkt")
(require "data-structures.rkt")
(require "environments.rkt")
(require "store.rkt")
(require racket/pretty)

(provide value-of-program value-of instrument-let instrument-newref)

;;;;;;;;;;;;;;;; switches for instrument-let ;;;;;;;;;;;;;;;;

(define instrument-let (make-parameter #f))

;; say (instrument-let #t) to turn instrumentation on.
;;     (instrument-let #f) to turn it off again.

;;;;;;;;;;;;;;;; the interpreter ;;;;;;;;;;;;;;;;

;; value-of-program : Program -> ExpVal
;; Page: 110
(define value-of-program 
  (lambda (pgm)
    (cases program pgm
      (a-program
       (exp1)
       (call-with-values
        (lambda () (value-of exp1 (init-env) (initial-store)))
        (lambda (val store) val))))))

;; value-of : Exp * Env -> ExpVal
;; Page: 113
(define value-of
  (lambda (exp env store)
    (cases expression exp

      ;\commentbox{ (value-of (const-exp \n{}) \r) = \n{}}
      (const-exp (num) (values (num-val num)
                               store))

      ;\commentbox{ (value-of (var-exp \x{}) \r) = (apply-env \r \x{})}
      (var-exp (var) (values (apply-env env var)
                             store))

      ;\commentbox{\diffspec}
      (diff-exp
       (exp1 exp2)
       (call-with-values
        (lambda () (value-of exp1 env store))
        (lambda (val1 store1)
          (call-with-values
           (lambda () (value-of exp2 env store1))
           (lambda (val2 store2)
             (values (num-val (- (expval->num val1)
                                 (expval->num val2)))
                     store2))))))

      ;\commentbox{\zerotestspec}
      (zero?-exp
       (exp1)
       (call-with-values
        (lambda ()
          (value-of exp1 env store))
        (lambda (val1 store1)
          (values (bool-val (zero? (expval->num val1)))
                  store1))))
        
      ;\commentbox{\ma{\theifspec}}
      (if-exp
       (exp1 exp2 exp3)
       (call-with-values
        (lambda () (value-of exp1 env store))
        (lambda (val1 store1)
          (if (expval->bool val1)
              (value-of exp2 env store1)
              (value-of exp3 env store1)))))

      ;\commentbox{\ma{\theletspecsplit}}
      (let-exp
       (var exp1 body)
       (call-with-values
        (lambda () (value-of exp1 env store))
        (lambda (val1 store1)
          (value-of body
                    (extend-env var val1 env)
                    store1))))
  
      (proc-exp
       (vars body)
       (values
        (proc-val (procedure vars body env))
        store))

      (call-exp
       (rator rands)
       (call-with-values
        (lambda () (value-of rator env store))
        (lambda (rator store1)
          (let loop ((store store1)
                     (rands rands)
                     (args '()))
            (if (null? rands)
                (apply-procedure (expval->proc rator) (reverse args) store)                
                (call-with-values
                 (lambda () (value-of (car rands) env store))
                 (lambda (arg store2)
                   (loop store2 (cdr rands) (cons arg args)))))))))

      (letrec-exp
       (p-names b-vars p-bodies letrec-body)
       (value-of letrec-body
                 (extend-env-rec* p-names b-vars p-bodies env)
                 store))

      (begin-exp
        (exp1 exps)
        (letrec 
            ((value-of-begins
              (lambda (e1 es store)
                (call-with-values
                 (lambda () (value-of e1 env store))
                 (lambda (val1 store1)
                   (if (null? es)
                       (values val1 store1)
                       (value-of-begins (car es) (cdr es) store1)))))))
          (value-of-begins exp1 exps store)))
      
      (newref-exp
       (exp1)
       (call-with-values
        (lambda () (value-of exp1 env store))
        (lambda (v1 store1)
          (call-with-values
           (lambda () (newref store1 v1))
           (lambda (ref store2)
             (values (ref-val ref)
                     store2))))))

      (deref-exp
       (exp1)
       (call-with-values
        (lambda () (value-of exp1 env store))
        (lambda (v1 store1)
          (values (deref store1 (expval->ref v1))
                  store1))))

      (setref-exp
       (exp1 exp2)
       (call-with-values
        (lambda () (value-of exp1 env store))
        (lambda (v1 store1)
          (let ((ref (expval->ref v1)))
            (call-with-values
             (lambda () (value-of exp2 env store1))
             (lambda (v2 store2)
               (let ((store3 (setref! store2 ref v2)))
                 (values (num-val 23) store3)))))))))))

;; apply-procedure : Proc * ExpVal -> ExpVal
;; 
;; uninstrumented version
;;   (define apply-procedure
;;    (lambda (proc1 arg)
;;      (cases proc proc1
;;        (procedure (bvar body saved-env)
;;          (value-of body (extend-env bvar arg saved-env))))))

;; instrumented version
(define apply-procedure
  (lambda (proc1 args store)
    (cases proc proc1
      (procedure (vars body saved-env)
                 (let ((r args))
                   (let ((new-env (extend-env* vars r saved-env)))
                     (when (instrument-let)
                       (begin
                         (eopl:printf
                          "entering body of proc ~s with env =~%"
                          vars)
                         (pretty-print (env->list new-env))
                         (eopl:printf "store =~%")
                         (pretty-print (store->readable (get-store-as-list store)))
                         (eopl:printf "~%")))
                     (value-of body new-env store)))))))

;; store->readable : Listof(List(Ref,Expval)) 
;;                    -> Listof(List(Ref,Something-Readable))
(define store->readable
  (lambda (l)
    (map
     (lambda (p)
       (cons
        (car p)
        (and (cadr p)
             (expval->printable (cadr p)))))
     l)))