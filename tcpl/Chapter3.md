Exercise 3-4. In a two's complement number system representation, our version of ``itoa`` does not handle the largest negative number, that is, the value of n equal to -(2<sup>wordsize - 1</sup>). Explain why not. Modify it to print that value correctly, regardless of the machine on which it runs.
A: The reason is that the absolute value of the largest negative is not representable in two's complement system. We can use ``unsigned int`` to store the value of ``-n``, which would not cause overflow like ``signed int`` did.
```c
#include <stdio.h>
#include <string.h>
#include <limits.h>

void itoa(int n, char s[]);
void reverse(char s[]);

int main(void) {
    char buffer[20];
    
    printf("INT_MIN: %d\n", INT_MIN);   
    itoa(INT_MIN, buffer);
    printf("Buffer : %s\n", buffer);
    
    return 0;
}

void itoa(int n, char s[]) {
    unsigned m = (n<0) ? -n : n;
    int i = 0;

    do {
        s[i++] = m % 10 + '0';
    } while ( m /= 10 );
    if (n < 0)
        s[i++] = '-';
    
    s[i] = '\0';
    reverse(s);
}

void reverse(char s[]) {
    int c, i, j;
    for ( i = 0, j = strlen(s)-1; i < j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}
```

Exercise 3-5. Write the function ``itob(n, s, b)`` that converts the integer ``n`` into a base ``b`` character representation in the string ``s``. In particular, ``itob(n, s, 16)`` formats ``n`` as a hexadecimal integer in ``s``.
```c
void itob(int n, char s[], int base) {
    if (base > 1 && base < 17) {
        char num[]  = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
                    'A', 'B', 'C', 'D', 'E', 'F'};
        unsigned m = (n<0) ? -n : n;
        int i = 0;

        do {
            s[i++] = num[m % base];
        } while ( m /= base );
        if (n < 0)
            s[i++] = '-';
        
        s[i] = '\0';
        reverse(s);
    }
}
```

Exercise 3-6. Write a version of ``itoa`` that accepts three arguments instead of two. The third argument is a minimum field width, the converted number must be padded with blanks on the left if necessary to make it wide enough.
```c
void itoa(int n, char s[], int width) {
    int i;
    
    unsigned m = (n<0) ? -n : n;
    
    i = 0;
    do {
        s[i++] = m % 10 + '0';
    } while ( m /= 10 );
    if (n < 0)
        s[i++] = '-';
    while (i < width) {
        s[i++] = ' ';
    }
    s[i] = '\0';
    reverse(s);
}
```
