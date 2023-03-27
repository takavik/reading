Exercise 3.43 The translator can do more than just keep track of the names of variables. For example, consider the program
```
let x = 3
in let f = proc(y) -(y,x)
   in (f 13)
```
Here we can tell statically that at the proceure call, ``f`` will be bound to a procedure whose body is ``-(y,x)``, where ``x`` has the same value that it had at the procedure creation site. Therefore we could avoid looking up ``f`` in the environment entirely. Extend the translator to keep track of "known procedures" and generate code that avoids an environment lookup at the call of such a procedure.

Exercise 3.44 In the preceding example, the only use of ``f`` is as a known procedure. Therefore the procedure built by the expression ``proc(y) -(y,x)`` is never used. Modify the translator so that such a procedure is never constructed.