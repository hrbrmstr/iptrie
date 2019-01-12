#include "iptrie.h"

#ifndef __IPRIE_TYPES__
#define __IPRIE_TYPES__

// template <typename T>
//   void finaliseRadix(r_trie <T>* radix_inst){
//     delete radix_inst;
//   }
void finalise_ip_trie(ip_trie *t) {
  delete t;
}

typedef Rcpp::XPtr<ip_trie, Rcpp::PreserveStorage, finalise_ip_trie> XPtrIPTree;

#endif