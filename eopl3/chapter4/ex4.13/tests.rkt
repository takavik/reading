#lang eopl

(provide run-tests)
;;;;;;;;;;;;;;;; tests ;;;;;;;;;;;;;;;;


(require "data-structures.rkt" "top.rkt"
         rackunit rackunit/text-ui
         (only-in racket/base exn:fail?))

(define sloppy->expval 
  (lambda (sloppy-val)
    (cond
      ((number? sloppy-val) (num-val sloppy-val))
      ((boolean? sloppy-val) (bool-val sloppy-val))
      (else
       (eopl:error 'sloppy->expval 
                   "Can't convert sloppy value to expval: ~s"
                   sloppy-val)))))

(define equal-answer?
  (lambda (ans correct-ans)
    (equal? ans (sloppy->expval correct-ans))))


(define-binary-check (check-val=? exp sloppy-val)
  (equal-answer? (run exp) sloppy-val))

(define-simple-check (check-eval-fail? exp)
  (check-exn exn:fail? (lambda () (run exp))))

(define-test-suite simple-arithmetic
  (test-case
   "Postive constant"
   (check-val=? "11" 11))
  (test-case
   "Negative constant"
   (check-val=? "-33" -33))
  (test-case
   "Simple arithmetic"
   (check-val=? "-(44,33)" 11)))

(define-test-suite nested-arithmetic
  (test-case
   "Left"
   (check-val=? "-(-(44,33),22)" -11))
  (test-case
   "Right"
   (check-val=? "-(55, -(22,11))" 44)))

(define-test-suite simple-variables
  (check-val=? "x" 10)
  (check-val=? "-(x,1)" 9)
  (check-val=? "-(1,x)" -9))

(define-test-suite simple-unbound-variables
  (check-eval-fail? "foo")
  (check-eval-fail? "-(x,foo)"))


(define-test-suite simple-conditionals
  (check-val=? "if zero?(0) then 3 else 4" 3)
  (check-val=? "if zero?(1) then 3 else 4" 4))

(define-test-suite dynamic-type-checking
  (test-case
   "No bool to diff"
   (check-eval-fail? "-(zero?(0),1)")
   (check-eval-fail? "-(1,zero?(0))"))
  (test-case
   "No int to if"
   (check-eval-fail? "if 1 then 2 else 3")))

(define-test-suite if-eval-test
  (test-case
   "if true"
   (check-val=? "if zero?(-(11,11)) then 3 else 4" 3))
  (test-case
   "if false"
   (check-val=? "if zero?(-(11, 12)) then 3 else 4" 4)))

(define-test-suite let-test
  (check-val=? "let x = 3 in x" 3)
  (test-case
   "eval let body"
   (check-val=? "let x = 3 in -(x,1)" 2))
  (test-case
   "eval let rhs"
   (check-val=? "let x = -(4,1) in -(x,1)" 2)))

(define-test-suite nested-let
  (check-val=? "let x = 3 in let y = 4 in -(x,y)" -1)
  (test-case
   "check shadowing in body"
   (check-val=? "let x = 3 in let y = 4 in -(x,y)" -1))
  (test-case
   "check shadowing in rhs"
   (check-val=? "let x = 3 in let x = -(x,1) in x" 2)))

(define-test-suite applications
  (check-val=? "(proc(x) -(x,1)  30)" 29)
  (check-val=? "let f = proc (x) -(x,1) in (f 30)" 29)
  (test-case
   "procedure as value"
   (check-val=? "(proc(f)(f 30)  proc(x)-(x,1))" 29)
   (test-case
    "nested procs"
    (check-val=? "((proc (x) proc (y) -(x,y)  5) 6)" -1)
    (check-val=? "let f = proc(x) proc (y) -(x,y) in ((f -(10,5)) 6)" -1))
   (test-case
    "Y combinator"
    (check-val=?
     "let fix =  proc (f)
               let d = proc (x) proc (z) ((f (x x)) z)
               in proc (n) ((f (d d)) n)
   in let t4m = proc (f) proc(x) if zero?(x) then 0 else -((f -(x,1)),-4)
     in let times4 = (fix t4m)
        in (times4 3)" 12))))

(define-test-suite letrecs
  (test-case
   "simple letrec"
   (check-val=? "letrec f(x) = -(x,1) in (f 33)"
                32)
   (check-val=? "letrec f(x) = if zero?(x)  then 0 else -((f -(x,1)), -2) in (f 4)"
                8)
   (check-val=?  "let m = -5 
                  in letrec f(x) = if zero?(x) then 0 else -((f -(x,1)), m) in (f 4)"
                 20))
  (test-case
   "HO nested letrecs"
   (check-val=? "letrec even(odd)  = proc(x) if zero?(x) then 1 else (odd -(x,1))
                 in letrec  odd(x)  = if zero?(x) then 0 else ((even odd) -(x,1))
                 in (odd 13)"
                1)))

(define-test-suite references
  (test-case
   "begin"
   (check-val=? "begin 1; 2; 3 end" 3))
  (test-case
   "gensym"
   (check-val=? "let g = let counter = newref(0) 
                      in proc (dummy) let d = setref(counter, -(deref(counter),-1))
                                      in deref(counter)
                 in -((g 11),(g 22))"
                -1))
  (test-case
   "simple store"
   (check-val=? "let x = newref(17) in deref(x)"
                17))
  (test-case
   "assignment"
   (check-val=? "let x = newref(17) 
                 in begin setref(x,27); deref(x) end"
                27))
  (test-case
   "even odd via set"
   (check-val=? "let x = newref(0)
                 in letrec even(d) = if zero?(deref(x))
                                     then 1
                                     else let d = setref(x, -(deref(x),1))
                                          in (odd d)
                           odd(d)  = if zero?(deref(x)) 
                                     then 0
                                     else let d = setref(x, -(deref(x),1))
                                          in (even d)
                     in let d = setref(x,13) in (odd -100)" 1
    ))
  (test-case
   "show allocation"
   (check-val=? "let x = newref(22)
                 in let f = proc (z)
                              let zz = newref(-(z,deref(x))) in deref(zz)
                    in -((f 66), (f 55))"
                11))
  (test-case
   "chains"
   (check-val=? "let x = newref(newref(0))
in begin 
setref(deref(x), 11);
deref(deref(x))
 end"
                11)))

(run-tests
 (test-suite
  "All tests"
  simple-arithmetic
  nested-arithmetic
  simple-variables
  simple-unbound-variables
  simple-conditionals
  dynamic-type-checking
  if-eval-test
  let-test
  nested-let
  applications
  letrecs
  references))
