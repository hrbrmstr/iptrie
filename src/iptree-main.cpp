#include <Rcpp.h>
#include "typedef.h"
using namespace Rcpp;

//[[Rcpp::export]]
SEXP create() {
  ip_trie *t = new ip_trie();
  return XPtrIPTree(t);
}

//[[Rcpp::export]]
void insert(SEXP t, CharacterVector keys, CharacterVector values){

  ip_trie *t_ptr = (ip_trie *)R_ExternalPtrAddr(t);

  ptr_check(t_ptr);

  uint32_t in_size = keys.size();

  for (uint32_t i=0; i<in_size; i++) {

    if ((i % 10000) == 0) Rcpp::checkUserInterrupt();

    if (keys[i] != NA_STRING && values[i] != NA_STRING) {

      t_ptr->insert(
          Rcpp::as<std::string>(keys[i]),
          Rcpp::as<std::string>(values[i])
      );

    }

  }

}

// [[Rcpp::export]]
std::string exact_match_str(SEXP t, std::string k) {

  ip_trie *t_ptr = (ip_trie *)R_ExternalPtrAddr(t);

  ptr_check(t_ptr);

  return(std::string(t_ptr->lookup_exact(k.c_str())));

}


// Rscript -e 'library(iptree); x <- iptree:::create(); iptree:::insert(x, "10.1.10.1/32", "test"); (iptree:::exact_match_str(x, "10.1.10.1/32"))'
