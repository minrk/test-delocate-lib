"""
setup for pylib (or pylib[N])

run with:

    V=2 python setup.py bdist_wheel

to build pylib2
"""
import glob
import os
import sys
pjoin = os.path.join


if 'bdist_wheel' in sys.argv:
    import setuptools

from distutils.core import setup
from distutils.extension import Extension

from Cython.Distutils import build_ext

cmdclass = {
    'build_ext' : build_ext,
}

V = os.environ.get('V', '')

pkg_name = 'pylib%s' % V

# initially, the Extensions
extensions = [
    Extension(
        '%s.liblib' % pkg_name,
        sources = [
            pjoin('pylib', 'liblib.pyx'),
            pjoin('pylib', 'liblib.pxd'),
        ],
        libraries = [
            'lib'
        ]
    )
]

package_data = {
    pkg_name : [
        '*.pyx',
        '*.pxd',
    ]
}

setup_args = dict(
    name = pkg_name,
    version = "0.0.1",
    packages = [pkg_name],
    package_dir = {pkg_name : 'pylib'},
    ext_modules = extensions,
    author = "Min Ragan-Kelley",
    url = 'http://github.com/minrk/test-delocate-libs',
    description = "Tess for delocate",
    license = "Public Domain",
    cmdclass = cmdclass,
)

setup(**setup_args)
