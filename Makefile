# install liblib version 2:
#
#     V=2 make install
#
# use symlink (liblib.dylib) as install_name instead of full liblib.X.Y.Z.dylib:
#
#     INSTALL_NAME=symlink make
#
# specify explicit compatibility version:
#
#     COMPAT=1.2.3 make
#

ifndef CC
  CC=gcc
endif

D = liblib

ifndef PREFIX
  PREFIX = /usr/local
endif

ifndef V
  VS = 1.0.0
  V=1
else
  VS = $(V).0.0
endif

# seriously, no OR in make?!
ifndef COMPAT
  COMPAT = $(VS)
else ifeq ($(COMPAT), "")
  COMPAT = $(VS)
else ifeq ($(COMPAT), V)
  COMPAT = $(VS)
endif


ifeq ($(shell uname), Darwin)
  LIBEXT = dylib
  SHARED = -dynamiclib
else
  LIBEXT = so
  SHARED = -shared
endif

LINK = $(CC) $(SHARED)

DYLIB = liblib.$(VS).$(LIBEXT)
SYMLINK = liblib.$(LIBEXT)
LIBRARY = $(D)/$(DYLIB)
INSTALLED_LIBRARY = $(PREFIX)/lib/$(DYLIB)
INSTALLED_SYMLINK = $(PREFIX)/lib/$(SYMLINK)


ifndef INSTALL_NAME
  INSTALL_NAME = $(INSTALLED_LIBRARY)
else ifeq ($(INSTALL_NAME), dylib)
  INSTALL_NAME = $(INSTALLED_LIBRARY)
else ifeq ($(INSTALL_NAME), symlink)
  INSTALL_NAME = $(INSTALLED_SYMLINK)
endif


OBJECTS = $(D)/liblib.o

$(LIBRARY): $(OBJECTS)
	$(LINK) -install_name $(INSTALL_NAME) -current_version $(VS) -compatibility_version $(COMPAT) -o $(LIBRARY) $(OBJECTS)
	rm -f $(D)/$(SYMLINK)
	ln -s $(DYLIB) $(D)/$(SYMLINK)

.c.o:
	$(CC) -DV=$(V) -c $*.c -o $*.o

test: test.c $(LIBRARY)
	$(CC) -o test test.c -llib

check : test install
	./test

all: $(LIBRARY)

clean:
	@rm -fv $(D)/*.o *~ $(D)/*.$(LIBEXT) test
	@rm -rf build *.egg-info __pycache__

install: $(LIBRARY)
	cp $(LIBRARY) $(INSTALLED_LIBRARY)
	rm -f $(INSTALLED_SYMLINK)
	ln -s $(DYLIB) $(INSTALLED_SYMLINK)
	cp $(D)/liblib.h $(PREFIX)/include/liblib.h

uninstall:
	@rm -fv $(PREFIX)/lib/liblib*.dylib $(PREFIX)/include/liblib.h
