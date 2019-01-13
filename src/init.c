#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
   Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP Rcreate();
extern SEXP Rdestroy(SEXP);
extern SEXP Rinsert(SEXP, SEXP, SEXP);
extern SEXP Rlookup(SEXP, SEXP);
extern SEXP Rexact(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"Rcreate",  (DL_FUNC) &Rcreate,  0},
    {"Rdestroy", (DL_FUNC) &Rdestroy, 1},
    {"Rinsert",  (DL_FUNC) &Rinsert,  3},
    {"Rlookup",  (DL_FUNC) &Rlookup,  2},
    {"Rexact",  (DL_FUNC) &Rexact,  2},
    {NULL, NULL, 0}
};

void R_init_iptrie(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}