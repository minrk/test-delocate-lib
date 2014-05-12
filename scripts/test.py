"""tests for separate pylib and pylib2

There are mutually exclusive tests here, so they will never all pass.
"""

def test_import():
    import pylib
    import pylib2

def test_version_separate():
    import pylib
    import pylib2
    assert pylib.version()  == 1
    assert pylib2.version() == 2

def test_version_shared():
    import pylib
    import pylib2
    assert pylib.version()  == pylib2.version()

def test_static_separate():
    import pylib
    import pylib2
    pylib.reset()
    pylib2.reset()
    assert pylib.static()  == 0
    assert pylib.static()  == 1
    assert pylib2.static() == 0
    assert pylib2.static() == 1

def test_static_shared():
    import pylib
    import pylib2
    pylib.reset()
    pylib2.reset()
    assert pylib.static()  == 0
    assert pylib2.static() == 1
    assert pylib.static()  == 2
    assert pylib2.static() == 3


