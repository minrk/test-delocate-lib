#ifndef V
    #define V 1
#endif

int lib_version(void) {
    return V;
}

static int static_counter;

int lib_static(void) {
    int current = static_counter;
    ++static_counter;
    return current;
};

void reset_static(void) {
    static_counter = 0;
};
