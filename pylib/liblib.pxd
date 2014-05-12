cdef extern from "liblib.h":
    int lib_version()
    int lib_static()
    void reset_static()
