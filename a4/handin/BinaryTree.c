#include <stdlib.h>
#include <stdio.h>

/**
 * A node of the binary tree containing the node's integer value
 * and pointers to its right and left children (or null).
 */
struct Node {
  int value;
  struct Node *left;
  struct Node *right;
};

/**
 * Create a new node with no children.
 */
struct Node* create (int value) {
  struct Node* n = malloc (sizeof (struct Node));
  n->value = value;
  n->left = 0;
  n->right = 0;
  return n;
}

/**
 * Insert the node n into the binary tree rooted by toNode.
 */
void insert (struct Node* toNode, struct Node* n) {
  if (n->value <= toNode->value) {
    if(toNode->left == 0) {
      toNode->left = n;
    } else {insert(toNode->left,n);}  
  } else {
    if (toNode->right == 0) {
      toNode->right = n;
    } else {insert(toNode->right,n);}
  }
}

// Insert number
// void insertNum (struct Node *n, int i) {

// }

/**
 * Print the contents entire binary tree in order of ascending integer value.
 */
void printInOrder (struct Node* node) {
  if (node->left != 0) {
    printInOrder(node->left);
  }
  printf("%d\n", node->value);
  if (node->right != 0) {
    printInOrder(node->right);
  }
}

/**
 * Create a new tree populated with values provided on the command line and
 * print it in depth-first order.
 */
int main (int argc, char* argv[]) {
  // creates a new node of val = 100 and have a pointer root point to it
  struct Node* root = 0;
  // struct Node* n1 = create(50);
  // struct Node* n2 = create(150);
  // insert(root,n1);
  // insert(root,n2);
  // printInOrder(root);
  // read values from command line and add them to the tree
  //printf("%d\n", 71);
  for (int i=1; i<argc; i++) {
    int value = atoi (argv [i]);
    struct Node *n = create(value);
    if (root == 0) {
      root = n;
    } else {
      insert(root,n);
    }   
  }
    if (root != 0) {
      printInOrder(root);
  }
}