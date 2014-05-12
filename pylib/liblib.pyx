cimport liblib

def version():
    return liblib.lib_version()

def static():
    return liblib.lib_static()

def reset():
    liblib.reset_static()
