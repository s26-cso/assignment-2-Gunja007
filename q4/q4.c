#include <stdio.h>
#include <dlfcn.h>

int main() {
    char op[6];
    int num1, num2;

    while(scanf("%5s %d %d", op, &num1, &num2) == 3){
        char libname[20];
        snprintf(libname, sizeof(libname), "./lib%s.so", op);
        void *handle = dlopen(libname, RTLD_LAZY);
        typedef int (*op_func)(int, int);
        op_func func = (op_func)dlsym(handle, op);
        printf("%d\n", func(num1, num2));
        dlclose(handle);
    }
    return 0;
}