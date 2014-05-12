#!/usr/bin/env bash
#
# do a single run
# for use in all.sh
#

export PREFIX="$VIRTUAL_ENV"
export CFLAGS="-I$PREFIX/include -L$PREFIX/lib"
export DYLD_LIBRARY_PATH="$PREFIX/lib"

echo "PREFIX $PREFIX"

pip uninstall -yq pylib pylib2  > /dev/null

set -e

rm -rf dist
make uninstall  > /dev/null
make clean  > /dev/null
python setup.py clean  > /dev/null


unset V
echo "\nBuilding liblib v1\n"

make install

echo "\nBuilding pylib v1\n"
python setup.py build 2>/dev/null
python setup.py bdist_wheel > /dev/null

echo "\nlistdeps pylib v1\n"
delocate-listdeps dist/pylib-*.whl
if [[ "$DELOCATE" == "yes" || "$DELOCATE" == "1" ]]; then
  delocate-wheel dist/pylib-*.whl
  make uninstall > /dev/null
fi

make clean > /dev/null
python setup.py clean > /dev/null

echo "\nBuilding liblib v2\n"
export V=2

make install

echo "\nBuilding pylib v2\n"
python setup.py build 2>/dev/null
python setup.py bdist_wheel > /dev/null

echo "\nlistdeps pylib v2\n"
delocate-listdeps dist/pylib2-*.whl
if [[ "$DELOCATE" == "yes" ]]; then
  delocate-wheel dist/pylib2-*.whl
  make uninstall > /dev/null
fi

pip install dist/*.whl > /dev/null

# cleanup build dir, to double-check that delocated copies are loaded
rm -rf dist
make clean > /dev/null
python setup.py clean > /dev/null


here="$PWD"
cd /tmp

if [[ -z "$1" ]]; then
  ofile="$here/results.log"
else
  ofile="$1"
fi

ls $PREFIX/lib

set +e
python $here/scripts/info.py >> "$ofile" 2>&1
# py.test $here/scripts/test.py > "$here/$key.test" 2>&1
cd "$here"

