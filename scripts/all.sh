#!/usr/bin/env bash
set -e

dest=log

test -d "$dest" || mkdir "$dest"
rm -f "$dest"/*
resultfile="$PWD/results.log"
rm -f "$resultfile"
touch "$resultfile"

virtualenv /tmp/test-delocate > /dev/null
source /tmp/test-delocate/bin/activate
pip install -q wheel
pip install -q cython --install-option='--no-cython-compile'

for INSTALL_NAME in symlink dylib; do
  # use either the symlink filename (liblib.dylib, version independent)
  # or the actual dylib (liblib.1.0.0.dylib, version dependent)
  export INSTALL_NAME=$INSTALL_NAME
  if [[ "$INSTALL_NAME" = "symlink" ]]; then
    ins="name_match"
  else
    ins="name_differ"
  fi
  for COMPAT in "V" "1.2.3"; do
    # use either the lib version (will differ)
    # or explicit 1.2.3 (will match)
    export COMPAT=$COMPAT
    if [[ "$COMPAT" = "V" ]]; then
      com="compat_differ"
    else
      com="compat_match"
    fi
    for DELOCATE in no yes 1; do
      # try all of 
      # - no delocation, just install both libs
      # - delocate both versions
      # - only delocate the first lib
      export DELOCATE=$DELOCATE
      if [[ "$DELOCATE" = "yes" ]]; then
        de="delocate"
      elif [[ "$DELOCATE" = "1" ]]; then
        de="delocate+lib"
      else
        de="lib"
      fi
      key="$ins-$com-$de"
      echo "$key"
      echo "\n-----------------------------------------" >> "$resultfile"
      echo "$key\n" >> "$resultfile"
      sh scripts/one.sh "$resultfile" > "$dest/$key.log" 2>&1
    done
  done
done