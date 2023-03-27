Exercise 7-1. Write a program that converts upper case to lower or lower case to upper, depending on the name it is invoked with, as found in ``argv[0]``. &#9633;
```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int main(int argc, char* argv[]) {
    int c;

    /* The binary should only be installed as toupper and tolower */
    int (*f)(int) = strcmp("toupper", argv[0]) == 0 ? toupper : tolower; 

    while ((c = getchar()) != EOF) {
        putchar(f(c));
    }

    return 0;
}
```

Exercise 7-2. Write a program that will print arbitrary input in a sensable way. As a minimum, it should print non-graphic characters in octal or hexadecimal according to local custom, and break long text lines.
```c
#include <ctype.h>
#include <stdio.h>

#define MAX_LINE 100

int main() {
    int c, n;
    n = 0;
    while ((c = getchar()) != EOF) {
        char *fmt = isprint(c) || c == '\n' ? "%c" : "%X";
        printf(fmt, c);
        if (c == '\n') {
            n = 0;
            continue;
        } 
        if (++n > MAX_LINE) {
            printf("\n");
            n = 0;
        }
    }
}
```

Exercise 7-3. Revise ``miniprintf`` to handle more of the other facilities of ``printf``.
```c
void miniprintf(char *fmt, ...)
{
    va_list ap; /*  points  to  each  unnamed  arg  in  turn  */
    char *p, *sval;
    int ival;
    unsigned int uval;
    double dval;

    va_start(ap, fmt); /*  make  ap  point  to  1st  unnamed  arg  */
    for (p = fmt; *p; p++)
    {
        if (*p != '%')
        {
            putchar(*p);
            continue;
        }
        switch (*++p)
        {
        case 'd':
            ival = va_arg(ap, int);
            printf("%d", ival);
            break;
        case 'f':
            dval = va_arg(ap, double);
            printf("%f", dval);
            break;
        case 's':
            for (sval = va_arg(ap, char *); *sval; sval++)
                putchar(*sval);
            break;
        case 'x':
            uval = va_arg(ap, unsigned);
            printf("%x", uval);
            break;
        case 'X':
            uval = va_arg(ap, unsigned);
            printf("%X", uval);
            break;
        default:
            putchar(*p);
            break;
        }
    }
    va_end(ap); /*  clean  up  when  done  */
}
```
