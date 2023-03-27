Exercise 1-2. Experiment to find out what happens when printf’s argument string contains \c, where c is some character not listed above.
```c
int main() {
    printf("hello\c, world\n");
}
```

Exercise 1-8. Write a program to count blanks, tabs, and newlines.
```c
#include <stdio.h>

int main() {
    int nb, nt, nl, nc, c;
    
    nb = nt = nl = nc = 0;
    while ((c = getchar()) != EOF) {
        nc++;
        if (c == ' ') {
            nb++;
        } 
        if (c == '\t') {
            nt++;
        } 
        if (c == '\n') {
            nl++;
        }
    }

    printf("spaces: \d\n", nb);
    printf("tabs: \d\n", nt);
    printf("newlines: \d\n", nl);
    printf("chars: \d\n", nc);    
}
```

Exercise 1-9. Write a program to copy its input to its output, replacing each string of one or more blanks by a single blank.
```c
#include <stdio.h>

int main() {
    int c, space;
    
    space = 0;
    while ((c = getchar()) != EOF) {
        if (c != ' ') {
            if (space != 0) {
                putchar(' ');
            }
            space = 0;
            putchar(c);
        } else {
            if (space == 0) {
                space = 1;
            } 
        }
    }
}
```

Exercise 1-10. Write a program to copy its input to its output, replacing each tab by \t, each backspace by \b, and each backslash by \\. This makes tabs and backspaces visible in an unambiguous way.
```c
#include <stdio.h>

int main() {
    int c;
    while ((c = getchar()) != EOF) {
        if ('\t' == c) {
            printf("\\t");
        } else if (' ' == c)  {
            printf("\\b");
        } else if ('\\' == c) {
            printf("\\\\");
        } else {
            putchar(c);
        }
    }
}
```

Exercise 1-12. Write a program that prints its input one word per line.
```c
#include <stdio.h>

#define WRD 0
#define SPC 1

int main() {
    int state, c;
    
    while ((c = getchar()) != EOF) {
        if (c != ' ' && c != '\t' && c != '\n') {
            state = WRD;
            putchar(c);
        } else {
            if (state == WRD) {
                putchar('\n');
            }
            state = SPC;
        }
    }
}
```

Exercise 1-13. Write a program to print a histogram of the lengths of words in its input. It is easy to draw the histogram with the bars horizontal; a vertical orientation is more challenging.
```c
#include <stdio.h>

#define MAXLEN 20

int main() {
    int c, len, wc, word[MAXLEN+1];

    for (int i = 1; i <= MAXLEN; i++) {
        word[i] = 0;
    }

    wc = 0;
    len = 0;
    while ((c = getchar()) != EOF) {
        if (c != ' ' && c != '\t' && c != '\n') { 
            len++;
        } else {
            if (len > 0) {
                word[len]++;
                len = 0;
                wc++;
            }
        }
    }

    // Since it's nonsense to talk about word of length zero, it can be used to represent total count
    word[0] = wc;

    for (int i = wc; i >= 0; i--) {
        if (i != 0) {
            printf("%3d ", i);            
        } else {
            putchar(' ');
            putchar(' ');
            putchar(' ');
            putchar(' ');
        }

        for (int j = 0; j <= MAXLEN; j++) {
            if (i != 0) {
                putchar(' ');
                putchar(' ');
                if (i > word[j]) {
                    putchar(' ');
                } else {
                    putchar('*');
                }
            } else {
                printf("%3d", j);
            }
            if (j == MAXLEN) {
                putchar('\n');
            }
             
        } 
    }
}
```

Exercise 1-16. Revise the main routine of the longest-line program so it will correctly print the length of arbitrarily long input lines, and as much as possible of the text.
```c
#include <stdio.h>
#define MAXLINE 1000

int get_line(char line[], int maxline);
void copy(char to[], char from[]);

/*print longest input line*/
int main() {
    int len;
    int max;
    char line[MAXLINE];
    char longest[MAXLINE];

    max = 0;
    while ((len = get_line(line, MAXLINE)) > 0) {
        if (len > max) {
            max = len;
            copy(longest, line);
        }
        if (len == MAXLINE - 1 && line[MAXLINE - 2] != '\n') {
            int c;
            while ((c = getchar()) != EOF) {
                len++;
            }
            if (len > max) {
                max = len;
            }
        }
    }
    if (max > 0) {
	    printf("Line length: %d:\t%s", max, longest);
    }
    return 0;
}

int get_line(char s[], int lim) {
    int c, i;

    for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
    	s[i] = c;
    }
    if (c == '\n') {
	    s[i] = c;
	    ++i;
    }
    s[i] = '\0';
    return i;
}

void copy(char to[], char from[]) {
    int i;

    i = 0;
    while ((to[i] = from[i]) != '\0') {
	    ++i;
    }
}

```

Exercise 1-17. Write a program to print all input lines that are longer than 80 characters.
```c
#include <stdio.h>
#define MAXLINE 1000

int get_line(char line[], int maxline);

int main() {
    int len;
    char line[MAXLINE];

    while ((len = get_line(line, MAXLINE)) > 0) {
        if (len == MAXLINE - 1 && line[MAXLINE - 2] != '\n') {
            int c;
            while ((c = getchar()) != EOF) {
                len++;
            }
        }
    	if (len > 80) {
	        printf("%s", line);
	    }
    }

    return 0;
}

int get_line(char s[], int lim) {
    int c, i;

    for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
    	s[i] = c;
    }
    if (c == '\n') {
	    s[i] = c;
	    ++i;
    }
    s[i] = '\0';
    return i;
}
```

Exercise 1-18. Write a program to remove trailing blanks and tabs from each line of input, and to delete entirely blank lines.
```c
#include <stdio.h>
#define MAXLINE 1000

int get_line(char line[], int maxline);
int trim(char line[], int len);

int main() {
    int len;
    char line[MAXLINE];

    while ((len = get_line(line, MAXLINE)) > 1) {
        len = trim(line, len);
    	printf("Line length: %d\n", len);
        printf("%s", line);
    }

    return 0;
}

int get_line(char s[], int lim) {
    int c, i;

    for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
    	s[i] = c;
    }
    if (c == '\n') {
	    s[i] = c;
	    ++i;
    }
    s[i] = '\0';
    return i;
}

int trim(char s[], int len) {
    int end, newline;

    if (s[len - 1] == '\n') {
        newline = 1;
        end = len - 2;
    } else {
        newline = 0;
        end = len - 1;
    }

    int i;
    for (i = end; s[i] == ' ' || s[i] == '\t'; i--) {
    }
    if (newline) {
        s[++i] = '\n';
    }
    s[++i] = '\0';
    
    return i;
}
```

Exercise 1-19. Write a function reverse(s) that reverses the character strings. Use it to write a program that reverses its input a line at a time.
```c
#include <stdio.h>
#define MAXLINE 1000

int get_line(char line[], int maxline);
void reverse(char s[], int len);

int main() {
    int len;
    char line[MAXLINE];

    while ((len = get_line(line, MAXLINE)) > 1) {
        reverse(line, len);
    	printf("Line length: %d\n", len);
        printf("%s", line);
    }

    return 0;
}

int get_line(char s[], int lim) {
    int c, i;

    for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
    	s[i] = c;
    }
    if (c == '\n') {
	    s[i] = c;
	    ++i;
    }
    s[i] = '\0';
    return i;
}

void reverse(char s[], int len) {
    for (int i = 0; i < len/2 - 1; i ++) {
        int j = len - 2 - i;
        int c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}
```

Exercise 1.20. Write a program that replaces tabs in the input with the proper number of blanks to space to the next tab stop. Assume a fixed set of tab stops, say every n columns. Should n be a variable or a symbolic parameter?
```c
#include <stdio.h>
#define MAXLINE 1000
#define TABSTP 11

int get_line(char line[], int maxline);
void detab(char s[], int len);

int main() {
    int len;
    char line[MAXLINE];

    while ((len = get_line(line, MAXLINE)) > 1) {
	    detab(line, len);
	    printf("%s", line);
    }

    return 0;
}

int get_line(char s[], int lim) {
    int c, i;

    for (i = 0; i < lim - 1 && (c = getchar()) != EOF && c != '\n'; ++i) {
	    s[i] = c;
    }
    if (c == '\n') {
	    s[i] = c;
	    ++i;
    }
    s[i] = '\0';
    return i;
}

void detab(char s[], int len) {
    int i = 0;
    int nspc, nchar;

    nspc = nchar = 0;
    while (i < len) {
    	if ((i+1) % TABSTP == 0) {
            nspc = nchar = 0;
    	}

        if (s[i] == '\t') {
            int n = TABSTP - nspc - nchar;
            int end = (s[len-1] == '\n') ? len-2 : len-1;
            for (int t = end; t >= i+n; t--) {
    	        s[t] = s[t-n+1];
            }
            for (int j = i; j < i+n && j < end; j++) {
    	        s[j] = ' ';
            }
            nspc = nchar = 0;
            i += n;
    	} else {
            if (s[i] == ' ') {
    	        nspc++;
            } else {
                nspc = 0;
            }
            nchar++;
            i++;
        }
    }
}
```
