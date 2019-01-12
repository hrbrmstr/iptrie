#include <Rcpp.h>
#include <iptree.h>
using namespace Rcpp;

#ifndef __IPTRIE_CORE__
#define __IPTRIE_CORE__

static inline void ptr_check(void *ptr){
  if (ptr == NULL){
    stop("invalid IP trie object; pointer is NULL");
  }
}

class ip_trie {

public:

  ip_trie() {
    Rcout << "CREATED TRIE" << std::endl;
    root = iptree_create();
  }

  ~ip_trie() {
    Rcout << "DESTROYING TRIE" << std::endl;
    iptree_destroy(root);
  }

  void insert(std::string key, std::string value) {
    Rcout << "INSERTING " << value << " at " << key << std::endl;
    iptree_insert_str(root, key.c_str(), (char *)value.c_str());
    Rcout << iptree_lookup_best_str(root,  key.c_str()) << std::endl;
  }

  void insert(uint32_t ip, uint32_t mask, std::string value) {
    iptree_insert(root, ip, mask, (char *)value.c_str());
  }

  std::string lookup_exact(std::string key) {
    return(std::string(iptree_lookup_best_str(root, key.c_str())));
    // uint32_t ip, mask;
    //
    // iptree_parse_cidr(key.c_str(), &ip, &mask);
    //
    // Rcout << "Looking for " << ip << " / " << mask << std::endl;
    //
    // iptree_node_t *res = iptree_lookup_exact(
    //   root, ip, mask
    // );
    //
    // return(std::string(res->data));
  }

private:

  iptree_node_t *root;

};
#endif
