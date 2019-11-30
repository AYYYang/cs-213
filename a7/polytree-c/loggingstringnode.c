#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "node.h"
#include "stringnode.h"
#include "loggingstringnode.h"

struct LoggingStringNode_class LoggingStringNode_class_table = {
  StringNode_compareTo,
  StringNode_printNode,
  LoggingStringNode_insert,
  Node_print,
  Node_delete,
};

void LoggingStringNode_ctor(void* thisv, char* s) {
  struct LoggingStringNode* this = thisv;
  StringNode_ctor(this, s);
}
/**
 * Override Node's insert
 */

void LoggingStringNode_insert(void* thisv, void* nodev) {
  struct LoggingStringNode* this = thisv;
  struct LoggingStringNode* node = nodev;

  Node_insert(this, node);
 //  StringNode_printNode(node);
  printf("%s", "insert ");
  StringNode_printNode(node);
}

void* new_LoggingStringNode(char* s) {
  struct LoggingStringNode* obj = malloc(sizeof(struct StringNode));
  obj->class = &LoggingStringNode_class_table;
  StringNode_ctor(obj, s);
  return obj;
}

