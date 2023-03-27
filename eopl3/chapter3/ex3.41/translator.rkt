#lang eopl

(require "lang.rkt" relation/function)

(provide translation-of-program apply-senv extend-senv empty-senv)
;;;;;;;;;;;;;;;; lexical address calculator ;;;;;;;;;;;;;;;;

;; translation-of-program : Program -> Nameless-program
;; Page: 96
(define translation-of-program
  (lambda (pgm)
    (cases program pgm
      (a-program (exp1)
        (a-program                    
          (translation-of exp1 (init-senv)))))))

;; translation-of : Exp * Senv -> Nameless-exp
;; Page 97
(define translation-of
  (lambda (exp senv)
    (cases expression exp
      (const-exp (num) (const-exp num))
      (diff-exp (exp1 exp2)
        (diff-exp
          (translation-of exp1 senv)
          (translation-of exp2 senv)))
      (zero?-exp (exp1)
        (zero?-exp
          (translation-of exp1 senv)))
      (if-exp (exp1 exp2 exp3)
        (if-exp
          (translation-of exp1 senv)
          (translation-of exp2 senv)
          (translation-of exp3 senv)))
      (var-exp (var)
        (let ((p (apply-senv senv var)))
          (nameless-var-exp (var-position p) (var-depth p))))      
      (let-exp (vars exps body)
        (nameless-let-exp
          (map (partialr translation-of senv) exps)
          (translation-of body
            (extend-senv vars senv))))
      (proc-exp (vars body)
        (nameless-proc-exp
          (translation-of body
            (extend-senv vars senv))))            
      (call-exp (rator rands)
        (call-exp
          (translation-of rator senv)
          (map (partialr translation-of senv) rands)))
      (else (report-invalid-source-expression exp))
      )))

(define report-invalid-source-expression
  (lambda (exp)
    (eopl:error 'translation-of 
      "Illegal expression in source code: ~s" exp)))

 ;;;;;;;;;;;;;;;; static environments ;;;;;;;;;;;;;;;;

(define-datatype static-env static-env?
  (empty-senv)
  (extend-senv 
   (vars (list-of symbol?))
   (saved-senv static-env?)))

(define apply-senv
  (lambda (senv var)
    (cases static-env senv
     (empty-senv ()
      (report-unbound-var var))
     (extend-senv (vars saved-env)
      (let loop ((vars vars)
                 (addr (cons 0 0)))     ;; '(position depth)
        (cond ((null? vars) 
               (let ((a (apply-senv saved-env var)))
                 (cons (car a) (+ 1 (cdr a)))))
              ((eqv? var (car vars)) addr)
              (else (loop (cdr vars) (cons (+ 1 (car addr))
                                           (cdr addr))))))))))

(define var-position car)
(define var-depth cdr)


(define report-unbound-var
  (lambda (var)
    (eopl:error 'translation-of "unbound variable in code: ~s" var)))

;; init-senv : () -> Senv
;; Page: 96
(define init-senv
  (lambda ()
    (extend-senv '(i)
      (extend-senv '(v)
        (extend-senv '(x)
          (empty-senv))))))
