(module data-structures (lib "eopl")

  ;; data structures for LEXADDR language

  (require "lang.scm" racket)                  ; for expression?

  (provide (all-defined-out))               ; too many things to list

;;;;;;;;;;;;;;;; expressed values ;;;;;;;;;;;;;;;;

;;; an expressed value is either a number, a boolean or a procval.

  (define-datatype expval expval?
    (num-val
      (value number?))
    (bool-val
      (boolean boolean?))
    (proc-val 
      (proc proc?)))

;;; extractors:

  ;; expval->num : ExpVal -> Int
  (define expval->num
    (lambda (v)
      (cases expval v
	(num-val (num) num)
	(else (expval-extractor-error 'num v)))))

  ;; expval->bool : ExpVal -> Bool
  (define expval->bool
    (lambda (v)
      (cases expval v
	(bool-val (bool) bool)
	(else (expval-extractor-error 'bool v)))))

  ;; expval->proc : ExpVal -> Proc
  (define expval->proc
    (lambda (v)
      (cases expval v
	(proc-val (proc) proc)
	(else (expval-extractor-error 'proc v)))))

  (define expval-extractor-error
    (lambda (variant value)
      (eopl:error 'expval-extractors "Looking for a ~s, found ~s"
	variant value)))

;;;;;;;;;;;;;;;; procedures ;;;;;;;;;;;;;;;;


  ;; proc? : SchemeVal -> Bool
  ;; procedure : Exp * Nameless-env -> Proc
  (define-datatype proc proc?
    (procedure
      ;; in LEXADDR, bound variables are replaced by %nameless-vars, so
      ;; there is no need to declare bound variables.
      ;; (bvar symbol?)
      (body expression?)
      ;; and the closure contains a nameless environment
      (env nameless-environment?)))

;;;;;;;;;;;;;;;; environment constructors and observers ;;;;;;;;;;;;;;;;

  ;; nameless-environment? : SchemeVal -> Bool
  (define nameless-environment?
    (and/c hash? immutable?))

  ;; empty-nameless-env : () -> Nameless-env
  (define empty-nameless-env
    make-immutable-hash)

  ;; empty-nameless-env? : Nameless-env -> Bool
  (define empty-nameless-env? 
    hash-empty?)

  ;; extend-nameless-env : ExpVal * Nameless-env -> Nameless-env
  ;; Page: 99
  (define extend-nameless-env
    (lambda (val nameless-env)
      (let ((deeper (hash-map/copy 
                      nameless-env 
                      (lambda (key value) (values (add1 key) value)))))
        (hash-set deeper 1 val))))

  ;; Make nameless env which contains only the mappings the expression needs
  (define (trim-nameless-env exp nameless-env)
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
        (nameless-var-exp (var1)
          (eqv? var var1))
        (nameless-let-exp (exp1 body)         
          (occurs-in? var body))
        (nameless-proc-exp (body)
          (occurs-in? var body))
        (call-exp (rator rand)
          (or (occurs-in? var rator)
              (occurs-in? var rand)))
        (else (eopl:error 'occurs-in? 
	                        "Illegal expression in translated code: ~s" exp))))
      (make-immutable-hash
        (filter (lambda (p) 
                  (occurs-in? (car p) exp)) 
                (hash->list nameless-env))))
  
  ;; apply-senv : Senv * Var -> Lexaddr
  (define apply-nameless-env
    hash-ref)

)
