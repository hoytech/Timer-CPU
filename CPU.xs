#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"



MODULE = Timer::CPU		PACKAGE = Timer::CPU

PROTOTYPES: ENABLE



void
measure_XS(callback, value)
        SV *callback
        SV *value
    CODE:
        size_t value_len;
        unsigned char *value_pointer;
        unsigned before_a, before_d, after_a, after_d;
        unsigned long long before, after;

        value_len = SvCUR(value);
        value_pointer = SvPV(value, value_len);

        __asm__ volatile("rdtsc" : "=a" (before_a), "=d" (before_d));

        PUSHMARK(sp);
        perl_call_sv(callback, G_DISCARD|G_NOARGS);

        __asm__ volatile("rdtsc" : "=a" (after_a), "=d" (after_d));

        before = ((unsigned long long) before_a) | (((unsigned long long) before_d) << 32);
        after = ((unsigned long long) after_a) | (((unsigned long long) after_d) << 32);

        *((unsigned long long *) value_pointer) = after - before;
