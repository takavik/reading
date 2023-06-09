#lang eopl
   
(provide initial-store reference? newref deref setref!
         instrument-newref get-store-as-list)
  
(define instrument-newref (make-parameter #f))
  
;;;;;;;;;;;;;;;; references and the store ;;;;;;;;;;;;;;;;
  
;;; world's dumbest model of the store:  the store is a list and a
;;; reference is number which denotes a position in the list.

;; empty-store : () -> Sto
;; Page: 111
(define empty-store
  (lambda () '()))
  
;; initialize-store! : () -> Sto
;; usage: (initialize-store!) sets the-store to the empty-store
;; Page 111
(define initial-store
  (lambda ()
    (empty-store)))

;; reference? : SchemeVal -> Bool
;; Page: 111
(define reference?
  (lambda (v)
    (integer? v)))

;; newref : ExpVal -> Ref Store
;; Page: 111
(define newref
  (lambda (store val)
    (let ((next-ref (length store)))
      (when (instrument-newref)
        (eopl:printf 
         "newref: allocating location ~s with initial contents ~s~%"
         next-ref val))                     
      (values
       next-ref
       (append store (list val))))))                     

;; deref : Ref -> ExpVal
;; Page 111
(define deref 
  (lambda (store ref)
    (list-ref store ref)))

;; setref! : Ref * ExpVal -> Unspecified
;; Page: 112
(define setref!                       
  (lambda (store ref val)
    (letrec
              ((setref-inner
                ;; returns a list like store1, except that position ref1
                ;; contains val. 
                (lambda (store1 ref1)
                  (cond
                    ((null? store1)
                     (report-invalid-reference ref store))
                    ((zero? ref1)
                     (cons val (cdr store1)))
                    (else
                     (cons
                      (car store1)
                      (setref-inner
                       (cdr store1) (- ref1 1))))))))
            (setref-inner store ref))))

(define report-invalid-reference
  (lambda (ref store)
    (eopl:error 'setref
                "illegal reference ~s in store ~s"
                ref store)))

;; get-store-as-list : () -> Listof(List(Ref,Expval))
;; Exports the current state of the store as a scheme list.
;; (get-store-as-list '(foo bar baz)) = ((0 foo)(1 bar) (2 baz))
;;   where foo, bar, and baz are expvals.
;; If the store were represented in a different way, this would be
;; replaced by something cleverer.
;; Replaces get-store (p. 111)
(define get-store-as-list
  (lambda (store)
    (letrec
        ((inner-loop
          ;; convert sto to list as if its car was location n
          (lambda (sto n)
            (if (null? sto)
                '()
                (cons
                 (list n (car sto))
                 (inner-loop (cdr sto) (+ n 1)))))))
      (inner-loop store 0))))
