(module translator (lib "eopl") 
  
  (require "lang.scm" racket)

  (provide translation-of-program)
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
          (nameless-var-exp
            (apply-senv senv var)))
        (let-exp (var exp1 body)
          (nameless-let-exp
            (translation-of exp1 senv)            
            (translation-of body
              (extend-senv var senv))))
        (proc-exp (var body)
          (nameless-proc-exp
            (translation-of body
              (trim-senv body (extend-senv var senv)))))
        (call-exp (rator rand)
          (call-exp
            (translation-of rator senv)
            (translation-of rand senv)))
        (else (report-invalid-source-expression exp))
        )))

  (define report-invalid-source-expression
    (lambda (exp)
      (eopl:error 'translation-of
        "Illegal expression in source code: ~s" exp)))
  
  (define (occurs-in? var exp)
    (cases expression exp
        (const-exp (_) #f)
        (diff-exp (exp1 exp2)
          (or (occurs-in? var exp1)
              (occurs-in? var exp2)))
        (zero?-exp (exp1)
          (occurs-in? var exp1))
        (if-exp (exp1 exp2 exp3)
          (or (occurs-in? var exp1)
              (occurs-in? var exp2))
              (occurs-in? var exp3))
        (var-exp (var1)
          (eqv? var var1))
        (let-exp (var1 exp1 body)
          (or (occurs-in? var exp1)
              (and (not (eqv? var var1))
                   (occurs-in? var body))))
        (proc-exp (var1 body)
          (and (not (eqv? var var1))
                (occurs-in? var body)))
        (call-exp (rator rand)
          (or (occurs-in? var rator)
              (occurs-in? var rand)))
        (else (report-invalid-source-expression exp))
    ))  
  
   ;;;;;;;;;;;;;;;; static environments ;;;;;;;;;;;;;;;;
  
  ;;; Senv = Listof(Sym)
  ;;; Lexaddr = N

  ;; empty-senv : () -> Senv
  (define empty-senv
    (lambda ()
      (make-immutable-hash)))

  ;; extend-senv : Var * Senv -> Senv
  (define extend-senv
    (lambda (var senv)
      (let ((deeper (hash-map/copy senv (lambda (key value) (values key (add1 value)))))) 
        (hash-set deeper var 1))))

  ;; Make an senv which contains only the mappings the expression needs
  (define trim-senv
    (lambda (exp senv)
      (make-immutable-hash 
        (filter (lambda (p) 
                  (occurs-in? (car p) exp)) 
                (hash->list senv)))))
  
  ;; apply-senv : Senv * Var -> Lexaddr
  (define apply-senv
    (lambda (senv var)
      (if (hash-has-key? senv var)
          (hash-ref senv var)
          (report-unbound-var var))))
          
  (define report-unbound-var
    (lambda (var)
      (eopl:error 'translation-of "unbound variable in code: ~s" var)))

  ;; init-senv : () -> Senv
  ;; Page: 96
  (define init-senv
    (lambda ()
      (extend-senv 'i
        (extend-senv 'v
          (extend-senv 'x
            (empty-senv))))))
  
  )
