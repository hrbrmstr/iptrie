#include <R.h>
#include <Rinternals.h>
#include <Rdefines.h>
#include <stdio.h>

#include "iptree.h"

// next 2 ƒ() via <https://github.com/randy3k/xptr/blob/master/src/xptr.c>

void check_is_xptr(SEXP s) {
  if (TYPEOF(s) != EXTPTRSXP) {
    error("expected an externalptr");
  }
}

SEXP is_null_xptr_(SEXP s) {
  check_is_xptr(s);
  return Rf_ScalarLogical(R_ExternalPtrAddr(s) == NULL);
}

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
    setAttrib(ptr, install("class"), mkString("iptrie"));
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

int find_mask(uint32_t mask) {
  int i;
  for (i=0; i<32; i++) {
    if (mask == masks[i]) break;
  }
  return(i);
}

SEXP Rlookup(SEXP trie, SEXP ip) {
  iptree_node_t *t = (iptree_node_t *)R_ExternalPtrAddr(trie);
  if (t) {
    iptree_node_t *res = iptree_lookup_best_str_2(t, CHAR(STRING_ELT(ip, 0)));
    if (res) {
      SEXP ans;
      PROTECT(ans = allocVector(STRSXP, 1));
      SET_STRING_ELT(ans, 0, mkChar(res->data));
      char buffer[17];
      uint32_t ipl = res->prefix & res->mask;
      sprintf(buffer, "%d.%d.%d.%d", (ipl>>24)&0xFF, (ipl>>16)&0xFF, (ipl>>8)&0xFF, (ipl)&0xFF);
      setAttrib(ans, install("ip"), mkString(buffer));
      setAttrib(ans, install("ipn"), ScalarReal(ipl));
      setAttrib(ans, install("mask"), ScalarInteger(find_mask(res->mask)));
      UNPROTECT(1);
      return(ans);
    }
  }
  return(R_NilValue);
}

//iptree_node_t *iptree_lookup_exact (iptree_node_t *root, uint32_t ip,
//                                    uint32_t mask);

SEXP Rexact(SEXP trie, SEXP ip) {
  iptree_node_t *t = (iptree_node_t *)R_ExternalPtrAddr(trie);
  if (t) {
    uint32_t ipn, mask;
    if (iptree_parse_cidr(CHAR(STRING_ELT(ip, 0)), &ipn, &mask)) {
      iptree_node_t * res = iptree_lookup_exact(t, ipn, mask);
      if (res) {
        SEXP ans;
        PROTECT(ans = allocVector(STRSXP, 1));
        char buffer[17];
        uint32_t ipl = res->prefix & res->mask;
        sprintf(buffer, "%d.%d.%d.%d", (ipl>>24)&0xFF, (ipl>>16)&0xFF, (ipl>>8)&0xFF, (ipl)&0xFF);
        setAttrib(ans, install("ip"), mkString(buffer));
        setAttrib(ans, install("ipn"), ScalarReal(ipl));
        setAttrib(ans, install("mask"), ScalarInteger(find_mask(res->mask)));
        UNPROTECT(1);
        return(ans);
      } else {
        return(R_NilValue);
      }
    }
  }
  return(R_NilValue);
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
