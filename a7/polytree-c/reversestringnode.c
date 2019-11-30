#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "node.h"
#include "stringnode.h"
#include "reversestringnode.h"

struct ReverseStringNode_class ReverseStringNode_class_table = {
  // TODO initialization of class table
  ReverseStringNode_compareTo, // overrides the StringNode_compareTo()
  StringNode_printNode,
  Node_insert,
  Node_print,
  Node_delete,
};

// TODO implementation of method(s) that ReverseStringNode overrides

void ReverseStringNode_ctor(void* thisv, char* s) {
  struct StringNode* this = thisv;
  StringNode_ctor(this, s);
}
int ReverseStringNode_compareTo(void* thisv, void* nodev) {
  struct ReverseStringNode* this = thisv;
  struct ReverseStringNode* node = nodev;
  return -strcmp (this->s, node->s);
}

void* new_ReverseStringNode(char* s) {
  struct ReverseStringNode* obj = malloc(sizeof(struct StringNode));
  obj->class = &ReverseStringNode_class_table;
  StringNode_ctor(obj, s);
  return obj;
}