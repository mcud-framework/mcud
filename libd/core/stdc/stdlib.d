/**
 * D header file for C99.
 *
 * $(C_HEADER_DESCRIPTION pubs.opengroup.org/onlinepubs/009695399/basedefs/_stdlib.h.html, _stdlib.h)
 *
 * Copyright: Copyright Sean Kelly 2005 - 2014.
 * License: Distributed under the
 *      $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0).
 *    (See accompanying file LICENSE)
 * Authors:   Sean Kelly
 * Standards: ISO/IEC 9899:1999 (E)
 * Source: $(DRUNTIMESRC src/core/stdc/_stdlib.d)
 */

module core.stdc.stdlib;

public import core.stdc.stddef; // for wchar_t

extern (C):
@system:

/* Placed outside `nothrow` and `@nogc` in order to not constrain what the callback does.
 */
///
alias _compare_fp_t = int function(const void*, const void*);

nothrow:
@nogc:

///
struct div_t
{
    int quot,
        rem;
}

///
struct ldiv_t
{
    int quot,
        rem;
}

///
struct lldiv_t
{
    long quot,
         rem;
}

///
enum EXIT_SUCCESS = 0;
///
enum EXIT_FAILURE = 1;
///
enum MB_CUR_MAX   = 1;

///
double  atof(scope const char* nptr);
///
int     atoi(scope const char* nptr);
///
c_long  atol(scope const char* nptr);
///
long    atoll(scope const char* nptr);

///
double  strtod(scope inout(char)* nptr, scope inout(char)** endptr);
///
float   strtof(scope inout(char)* nptr, scope inout(char)** endptr);
///
c_long  strtol(scope inout(char)* nptr, scope inout(char)** endptr, int base);
///
long    strtoll(scope inout(char)* nptr, scope inout(char)** endptr, int base);
///
c_ulong strtoul(scope inout(char)* nptr, scope inout(char)** endptr, int base);
///
ulong   strtoull(scope inout(char)* nptr, scope inout(char)** endptr, int base);
///
real strtold(scope inout(char)* nptr, scope inout(char)** endptr);

// These only operate on integer values.
@trusted
{
    ///
    pure int     abs(int j);
    ///
    pure c_long  labs(c_long j);
    ///
    pure long    llabs(long j);

    ///
    div_t   div(int numer, int denom);
    ///
    ldiv_t  ldiv(c_long numer, c_long denom);
    ///
    lldiv_t lldiv(long numer, long denom);
}

///
version (GNU)
{
    void* alloca(size_t size) pure; // compiler intrinsic
}
else version (LDC)
{
    pragma(LDC_alloca)
    void* alloca(size_t size) pure;
}
