/* Copyright © 2017 Jakub Wilk <jwilk@jwilk.net>
 * SPDX-License-Identifier: MIT
 */

#define _GNU_SOURCE

#include <dlfcn.h>
#include <stdio.h>

static int verbose = 0;
static char * (*orig_getenv)(const char *name);

char *getenv(const char *name)
{
    if (!orig_getenv) {
        orig_getenv = dlsym(RTLD_NEXT, "getenv");
        if (orig_getenv)
            verbose = !!orig_getenv("GETENVY");
        else {
            fprintf(stderr, "getenvy: cannot acquire original getenv()\n");
            return NULL;
        }
    }
    if (verbose) {
        const char *p;
        fprintf(stderr, "getenv(\"");
        for (p=name; *p; p++) {
            unsigned char c = *p;
            if (c == '\\' || c == '"')
                fprintf(stderr, "\\%c", c);
            else if (c < ' ' || c >= 0x7F)
                fprintf(stderr, "\\x%02x", c);
            else
                fprintf(stderr, "%c", c);
        }
        fprintf(stderr, "\")\n");
    }
    return orig_getenv(name);
}

/* vim:set ts=4 sts=4 sw=4 et:*/
