# Copyright © 2017-2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

INSTALL = install
CFLAGS ?= -O2 -g
CFLAGS += -Wall -Wextra
ifneq "$(filter Linux GNU%,$(shell uname))" ""
LDLIBS += -ldl
endif

PREFIX = /usr/local
DESTDIR =

libdir = $(PREFIX)/lib

.PHONY: all
all: libgetenvy.so

.PHONY: install
install: libgetenvy.so
	install -d $(DESTDIR)$(libdir)
	install -m 644 $(<) $(DESTDIR)$(libdir)/$(<)

.PHONY: clean
clean:
	rm -f *.so

lib%.so: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -shared -fPIC $(<) $(LDLIBS) -o $(@)

.PHONY: test
test: libgetenvy.so
	LD_PRELOAD=./$(<) GETENVY=1 ls 2>&1 >/dev/null | grep -w getenv

.PHONY: test-installed
test-installed:
	LD_PRELOAD=libgetenvy.so GETENVY=1 ls 2>&1 >/dev/null | grep -w getenv

.error = GNU make is required

# vim:ts=4 sts=4 sw=4 noet
