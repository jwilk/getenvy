# Copyright © 2017 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

INSTALL = install
CC = gcc
CFLAGS ?= -O2 -g
CFLAGS += -Wall -Wextra

PREFIX = /usr/local
DESTDIR =

libdir = $(PREFIX)/lib

.PHONY: all
all: libgetenvy.so

.PHONY: install
install: libgetenvy.so
	install -D -m 644 $(<) $(DESTDIR)$(libdir)/$(<)

.PHONY: clean
clean:
	rm -f *.so

lib%.so: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -shared -fPIC -ldl $(<) -o $(@)

# vim:ts=4 sts=4 sw=4 noet
