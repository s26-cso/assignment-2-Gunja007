#include <stdio.h>
#include <dlfcn.h>

int main() {
    char op[6];
    int num1, num2;

    while(scanf("%5s %d %d", op, &num1, &num2) == 3){
        char libname[20];
        snprintf(libname, sizeof(libname), "./lib%s.so", op);//joins the strings and trims it safely to avoid buffer overflow
        void *libptr = dlopen(libname, RTLD_LAZY);//loads the shared library, RTLD_LAZY means that the symbols are processed as needed
        typedef int (*op_func)(int, int);
        op_func func = (op_func)dlsym(libptr, op);//gets the function from the shared file
        printf("%d\n", func(num1, num2));
        dlclose(libptr);
    }
    return 0;
}