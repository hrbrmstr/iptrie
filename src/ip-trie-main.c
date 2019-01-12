#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>
#include <stdio.h>
#include "iptree.h"

static void trie_finalizer(SEXP ptr) {
  if(!R_ExternalPtrAddr(ptr)) return;
  iptree_destroy((iptree_node_t *)R_ExternalPtrAddr(ptr));
  R_ClearExternalPtr(ptr); /* not really needed */
}

SEXP Rcreate() {
  SEXP ptr;
  iptree_node_t *t = iptree_create();
  if (t) {
    ptr = R_MakeExternalPtr(t, install("IP_trie"), R_NilValue);
    R_RegisterCFinalizerEx(ptr, trie_finalizer, TRUE);
    return(ptr);
  } else {
    return(R_NilValue);
  }
}

SEXP Rinsert(SEXP trie, SEXP ip, SEXP value) {
  iptree_node_t *t = (iptree_node_t *)R_ExternalPtrAddr(trie);
  if (t) {
    iptree_insert_str(t, CHAR(STRING_ELT(ip, 0)), (char *)CHAR(STRING_ELT(value, 0)));
  }
  return(R_NilValue);
}

SEXP Rlookup(SEXP trie, SEXP ip) {
  iptree_node_t *t = (iptree_node_t *)R_ExternalPtrAddr(trie);
  if (t) {
    char * res = iptree_lookup_best_str(t, CHAR(STRING_ELT(ip, 0)));
    if (res) {
      SEXP ans;
      PROTECT(ans = allocVector(STRSXP, 1));
      SET_STRING_ELT(ans, 0, mkChar(res));
      UNPROTECT(1);
      return(ans);
    } else {
      return(R_NilValue);
    }
  } else {
    return(R_NilValue);
  }
}

SEXP Rremove(SEXP trie, SEXP entry) {
  iptree_node_t *t = (iptree_node_t *)R_ExternalPtrAddr(trie);
  if (t) iptree_remove_str(t, CHAR(STRING_ELT(entry, 0)));
  return(R_NilValue);
}

SEXP Rdestroy(SEXP trie) {
  iptree_node_t *t = (iptree_node_t *)R_ExternalPtrAddr(trie);
  if (t) iptree_destroy(t);
  R_ClearExternalPtr(trie);
  return(R_NilValue);
}
