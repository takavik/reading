Exercise 2-2. Write a loop equivalent to the ``for`` loop above without using ``&&`` or ``||``. &#9633;
```c
/*
for (i=0; i<lim-1 && (c=getchar()) != '\n' && c != EOF; ++i) {
    s[i] = c;
}
*/
for (i=0; i<lim-1; ++i) {
   if ((c = getchar()) == '\n') {
       break;
   } else if (c == EOF) {
       break;
   } else {
       s[i] = c;
   }
}
```

Exercise 2-3. Write the function ``htoi(s)``, which converts a string of hexidecimal digits (including an optional 0x or 0X) into its equivalent integer value. The allowable digits are 0 through, a through f, and A through F. &#9633;
```c
#include <ctype.h>
#include <stdlib.h>

int htoi(char s[]) {
  int i =  (s[0] == '0' && toupper(s[1]) == 'X')? 2 : 0;
  int c, sum;

  sum = 0;
  while ((c = toupper(s[i++])) != '\0') {
    int r;
    if (isdigit(c)) {
      r = c - '0';
    } else if (c >= 'A' && c <= 'F'){
      r = c - 'A' + 10;
    } else {
      exit(-1);
    }
    sum = sum*16 + r;
  }
  return sum;
}
```

Exercise 2-4. Write an alternate version of squeeze(s1, s2) that defines each character in s1 that matches any character in the string s2. &#9633;
```c
void sequeeze(char s[], char c[]) {
    int i, j;

    for (i = j = 0; s[i] != '\0'; i++) {
        int match = 0;

        for (int k = 0; c[k] != '\0'; k++) {
            if (s[i] == c[k]) {
                match = 1;
            }
        }
        if (!match) {
            s[j++] = s[i];
        }
    }
    s[j++] = '\0';
}
```

Exercise 2-5. Write the function any(s1, s2), which returns the first location in the string s1 where any character from the string s2 occurs, or -1 if s1 contains no characters from s2. (The standard library function strpbrk does the same job but returns a pointer to the location.) &#9633;
```c
int any(char s1[], char s2[]) {
    for (int i = 0; s1[i] != '\0'; i++) {
        for (int j = 0; s2[j] != '\0'; j++) {
            if (s1[i] == s2[j]) {
                return i;
            }
        }
    }

    return -1;
}
```

Exercise 2-6. Write a function ``setbits(x,p,n,y)`` that returns ``x`` with the ``n`` bits that begin at position ``p`` set to the rightmost ``n`` bits of ``y``, leaving the other bits unchanged. &#9633;
```c
unsigned long setbits(unsigned long x, int p, int n, unsigned long y) {
    unsigned long a, b;
    a = x>>(p+n)<<n;
    b = y & ~(~0 << n);
    b |= a;
    b <<= p;
    a = x & ~(~0 << p);
    return a | b;
}
```

Exercise 2-7. Write a function ``invert(x,p,n)`` that returns ``x`` with the ``n`` bits that begin at position ``p`` inverted (i.e., 1 changed into 0 and vice versa), leaving the others unchanged. &#9633;
```c
unsigned long invert(unsigned long x, int p, int n) {
    unsigned long a, b, c;
    a = (~(~0 << n)) << p;       
    a =  ~(x & a) & (~(~0<<n)) << p;
    b = x & ~(~0 << p);          
    c = x & (~0 << (p+n));       
    return a | b | c;
}
```

Exercise 2-8. Write a function ``rightrot(x,n)`` that returns the value of the integer ``x`` rotated to the right by ``n`` bit positions. &#9633;
```c
unsigned long rightrot(unsigned long x, size_t n) {
    unsigned long a, b, c;
    size_t size = 8*sizeof(x);

    a = x >> n;
    b = ~(~0 << (size - n)) & a;
    a = ~(~0 << n) & x;
    a <<= (size - n); 

    return a | b;
}
```