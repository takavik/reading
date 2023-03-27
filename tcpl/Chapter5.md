Exercise 5-8. There is no error checking in ``day_of_year`` or ``month_day``. Remedy this defect.
```c
#include <stdio.h>
#include <stdlib.h>

static char daytab[2][13] = {
    {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
    {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
};

int day_of_year(int year, int month, int day) {
    if (month <= 0 || month > 12) {
        fprintf(stderr, "Invalid month: %d\n", month);
        exit(1);
    }
    
    int leap = year%4 == 0 && year%100 != 0 || year%400 == 0;
    
    if (day > daytab[leap][month]) {
        fprintf(stderr, "Invalid day %d for month %d of year %d\n", day, month, year);
        exit(1);
    }
    for (int i = 0; i < month; i++) {
        day += daytab[leap][i];
    }
    return day;
}

void month_day(int year, int yearday, int *pmonth, int *pday) {
    int leap = year%4 == 0 && year%100 != 0 || year%400 == 0;

    int i, day = yearday;
    for (i = 1; day > daytab[leap][i]; i++) {
        day -= daytab[leap][i];
        if (i == 11 && day > daytab[leap][12]) {
            fprintf(stderr, "Invalid year day %d of year %d\n", yearday, year);
            exit(1);
        }
    }
    *pmonth = i;
    *pday = day;
}
```

Exercise 5-9. Rewrite the routines ``day_of_year`` and ``month_day`` with pointers instead of indexing.
```c
#include <stdio.h>
#include <stdlib.h>

static char daytab[2][13] = {
    {0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
    {0, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31},
};

int day_of_year(int year, int month, int day) {
    if (month <= 0 || month > 12) {
        fprintf(stderr, "Invalid month: %d\n", month);
        exit(1);
    }
    
    int leap = year%4 == 0 && year%100 != 0 || year%400 == 0;
    
    if (day > daytab[leap][month]) {
        fprintf(stderr, "Invalid day %d for month %d of year %d\n", day, month, year);
        exit(1);
    }
    for (int i = 0; i < month; i++) {
        // day += daytab[leap][i];
        day += *(*(daytab+leap) + i);
    }
    return day;
}

void month_day(int year, int yearday, int *pmonth, int *pday) {
    int leap = year%4 == 0 && year%100 != 0 || year%400 == 0;

    int i, day = yearday;
    for (i = 1; day > *(*(daytab+leap) + i); i++) {
        day -= *(*(daytab+leap) + i);
        if (i == 11 && day > *(*(daytab+leap) + 12)) {
            fprintf(stderr, "Invalid year day %d of year %d\n", yearday, year);
            exit(1);
        }
    }
    *pmonth = i;
    *pday = day;
}
```