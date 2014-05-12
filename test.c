#include <stdio.h>
#include <stdarg.h>
#include "liblib.h"

int main (int argc, char const *argv[])
{
    int major, minor, version;
    int f, b, i;
    int v = lib_version();
    printf("liblib version: %d\n", v);
    for(i = 0; i < 5; ++i) {
        printf("counter: %d\n", lib_static());
    }
    return 0;
}