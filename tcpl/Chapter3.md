Exercise 3-1. Our binary search makes two test inside the loop, when one would suffice (at the price of more tests outside). Write a version with only one test inside the loop and measure the difference in run-time. &#9633;
```c
int binsearch(int x, int v[], int n) {
    int low, high, mid;
    
    low = 0;
    high = n - 1;
    
    while (low <= high && x != v[mid]) {
        mid = (low+high) / 2;
        if (x < v[mid]) {
            high = mid - 1;
        } else {
            low = mid + 1;
        } 
    }
    if (x == v[mid]) {
        return mid;
    } else {
        return -1;
    }
    
}
```

Exercise 3-2. Write a function ``escape(s,t)`` that converts characters like newline and tab into visible escape sequences like ``\n`` and ``\t`` as it copies the string ``t`` into ``s``. Use a ``switch``. Write a function for the other direction as well, converting escape sequences into the real characters. &#9633;
```c
void escape(char * s, char * t, int lim) {
    int i, j;
    for (i =0, j = 0; i < lim && s[i] != '\0'; i++) {
        switch(s[i]) {
            case '\a':
                t[j++] = '\\';
                t[j++] = 'a';
                break;
            case '\b':
                t[j++] = '\\';
                t[j++] = 'b';
                break;
            case '\t':
                t[j++] = '\\';
                t[j++] = 't';
                break;
            case '\n':
                t[j++] = '\\';
                t[j++] = 'n';
                break;
            case '\\':
                t[j++] = '\\';
                t[j++] = '\\';
                break;
            case '\r':
                t[j++] = '\\';
                t[j++] = '\r';
                break;
            default:
                t[j++] = s[i];
                break;
        }
    }
    t[j] = '\0';
}

void unescape(char * s, char * t, int lim) {
    int i, j;
    for (i=0, j=0; i<lim && s[i] != '\0'; i++) {
        if (s[i] == '\\') {
            if (i<lim-1 && s[i+1] != '\0') {
                switch(s[++i]) {
                case 'a':
                    t[j++] = '\a';
                    break;
                case 'b':
                    t[j++] = '\b';
                    break;
                case 't':
                    t[j++] = '\t';
                    break;
                case 'n':
                    t[j++] = '\n';
                    break;
                case '\\':
                    t[j++] = '\\';
                    break;
                case 'r':
                    t[j++] = '\r';
                    break;
                default:
                    t[j++] = '\\';
                    t[j++] = s[i];
                    break;
                }
            }
        } else {
            t[j++] = s[i];
        }
    }
    t[j] = '\0';
}
```

Exercise 3-4. In a two's complement number system representation, our version of ``itoa`` does not handle the largest negative number, that is, the value of n equal to -(2<sup>wordsize - 1</sup>). Explain why not. Modify it to print that value correctly, regardless of the machine on which it runs. &#9633;
```c
/*
The reason is that the absolute value of the largest negative is not representable in two's complement system. We can use ``unsigned int`` to store the value of ``-n``, which would not cause overflow like ``signed int`` did.
*/

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

Exercise 3-5. Write the function ``itob(n, s, b)`` that converts the integer ``n`` into a base ``b`` character representation in the string ``s``. In particular, ``itob(n, s, 16)`` formats ``n`` as a hexadecimal integer in ``s``. &#9633;
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

Exercise 3-6. Write a version of ``itoa`` that accepts three arguments instead of two. The third argument is a minimum field width, the converted number must be padded with blanks on the left if necessary to make it wide enough. &#9633;
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
