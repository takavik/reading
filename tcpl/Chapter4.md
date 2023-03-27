Exercise 4-1. Write the function ``strrindex(s, t)``, which returns the position of the *rightmost* occurrence of ``t`` in ``s``, or ``-1`` if there is none.
```c
/* strrindex:  return rightmost index of t in s, −1 if none */
int strrindex(char s[], char t[])
{
    int i, j, k;

    for (i = 0; s[i] != '\0'; i++) {
        for (j=i, k=0; t[k]!='\0' && s[j]==t[k]; j++, k++)
            ;
        if (k > 0 && t[k] == '\0')
            return j - 1;
    }
    return -1;
}
```

Exercise 4-2. Extend ``atof`` to handle scientifice notation of the form \\
``123.45e-6`` \\
where a floating-point number may be followed by ``e`` or ``E`` and an optionally signed exponent.
```c
double atof(char s[])
{
    double val, power;
    int i, sign;

    for (i = 0; isspace(s[i]); i++)  /* skip white space */
        ;
    sign = (s[i] == '-') ? -1 : 1;
    if (s[i] == '+' || s[i] == '-')
        i++;
    for (val = 0.0; isdigit(s[i]); i++)
        val = 10.0 * val + (s[i] - '0');
    if (s[i] == '.')
        i++;
    for (power = 1.0; isdigit(s[i]); i++) {
        val = 10.0 * val + (s[i] - '0');
        power *= 10.0;
    }
    
    int exp, expsign, p;

    expsign = 1;
    if (tolower(s[i]) == 'e') {
        i++;
    }
    if (s[i] == '-') {
        expsign = -1;
        i++;
    }
    for (exp = 0; isdigit(s[i]); i++) {
        exp = 10*exp + (s[i] - '0');
    }
    p = 1;
    for (int i = 1; i <= exp; i++) {
        p = p * 10;
    }
    if (expsign == 1) {
        return sign * val / power * p;
    } else {
        return sign * val / power / p;
    }  
}
```