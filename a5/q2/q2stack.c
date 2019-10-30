#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct Element {
  char   name[200];
  struct Element *next;
};

struct Element *top = 0;

void push (char* aName) {
  struct Element* e = malloc (sizeof (*e));    // Not the bug: sizeof (*e) == sizeof(struct Element)
  strncpy (e->name, aName, sizeof (e->name));  // Not the bug: sizeof (e->name) == 200
  e->next  = top;
  top = e;
}

char* pop(char* w) {
  struct Element* e = top;
  top = e->next;
  strncpy(w, e->name, sizeof(e->name));
  free (e);
  return e->name;
}

int main (int argc, char** argv) {
  push ("A");
  push ("B");
  char w[200], x[200], y[200], z[200]; // give it a large enough size
  // only w[0], address of w array is passed in 
  pop(w); // lost B 
  push ("C");
  push ("D"); 
  pop(x);
  pop(y); // lost D
  pop(z);
  printf ("%s %s %s %s\n", w, x, y, z);
}
