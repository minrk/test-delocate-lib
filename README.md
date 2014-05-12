# tests for delocate and library versions

This repo contains some tools for testing what happens with various combinations
of versions of a single dynamic library, for use with [delocate][]  (and results thereof).

Results of one run through can be found in [results.log](results.log).

## What does it do?

This project builds and installs two versions of a library `liblib`, as:

- `PREFIX/liblib.X.0.0.dylib`
- `PREFIX/liblib.dylib` symlink to `PREFIX/liblib.X.0.0.dylib`

`liblib` is a tiny library that provides two functions:

- `lib_version()` reports its own version
- `lib_static()` increments and returns a counter on a static variable,
  to indicate whether static variables are shared between two versions.

It also builds Python bindings `pylib` and `pylib2`,
each linked against a different version of `liblib`.

With parameterization to switch:

- install_name of liblib:
  - `PREFIX/liblib.dylib` so all versions will have the same install_name
  - `PREFIX/liblib.X.0.0.dylib` so different versions will have different values for install_name.
- compatibility_version of liblib:
  - allowing each version to differ
  - force all versions to claim compatibility
- whether `delocate` is called on one, both, or neither of `pylib` and `pylib2`.

It all comes together with a [script](scripts/all.sh) that runs through the parameters,
and [summarizes](scripts/info.py) the results of each combination.

## Summary of results

**WARNING: This is not authoritative, I do not claim to know what I am doing.**

The output of one run through can be found in [results.log](results.log).

- `install_name` is just the filename of the library - typically the ABI-specific `/usr/local/lib/libfoo.X.Y.Z.dylib`.
- There cannot be two versions of a library with the same `install_name` loaded.
  - if two *compatible* (according to `compatibility_version`) copies attempt to be loaded,
    only the first-loaded will be used.
  - if two *incompatible* copies attempt to be loaded, the second will fail in `dlopen`.
- Two copies of the same library can be loaded if they have different `install_name`.

## Running the tests

To run the tests and generate your own test data, simply run:

    sh scripts/all.sh

from the repo root.


[delocate]: https://github.com/matthew-brett/delocate

