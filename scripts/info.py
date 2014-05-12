"""
summarize the state and relationship of pylib and pylib2

for use in one.sh
"""
from __future__ import print_function
import os
import sys
from subprocess import check_output

import distutils.sysconfig
site_packages = distutils.sysconfig.get_python_lib()

for pylib in ('pylib', 'pylib2'):
    liblib_ext = os.path.join(site_packages, pylib, 'liblib.so')
    otool_cmd = ['otool', '-L', liblib_ext]
    print(' '.join(otool_cmd))
    print(check_output(otool_cmd).decode('utf8').splitlines()[1])

print("import pylib", end='....')
import pylib
print('ok')

print("import pylib2", end='...')
try:
    import pylib2
except ImportError as e:
    print("failed")
    print(e)
    sys.exit(1)
print('ok')

print("pylib.version  %i" % pylib.version())
print("pylib2.version %i" % pylib2.version())

static1 = [ pylib.static() for i in range(5) ]
static2 = [ pylib2.static() for i in range(5) ]

if static1 == static2 == list(range(5)):
    print("static variables not shared")
elif static1 == list(range(5)) and static2 == list(range(5,10)):
    print("static variables shared")
else:
    print("unexpected static variables: %s, %s" % (static1, static2))


