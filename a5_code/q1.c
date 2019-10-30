#include <stdlib.h>
#include <stdio.h>

////////////
/// definition of struct's accessed by q1.s
///

struct B {
  int    y[4];
  struct A* a;
};

struct A {
  int*     x;
  struct B b;
};

////////////
/// declaration of global variables found in q1.s
///

struct A* a;
int    i, v0, v1, v2, v3;


///////////
/// your implementatoin of code found in q1.s
///

/*
1) v0 = d1[i]
2) v1 = d0[1+i]
3) v2 = d3[i]
4) d0.[5] = d0 // d2 = d0
5) v3 = d0[1+i]
*/
void q1() {
  v0 = a->x[i]; // i, a, x, x[i], + v0
  v1 = a->b.y[i]; // i, a, b.y[i]
  v2 = a->b.a->x[i]; // i, a, a->b.a, a->b.a->x, a->b.a->x[i], 1
  a->b.a = a; // a + 1
  v3 = a->b.a->b.y[i]; // i, a, a->b.a, a->b.a->b.y[i] + 1
}

////////////
/// test harness (run with no args for default values; you code must work for arbitrary)
///

int main (int ac, char** av) {
  /* dynamic allocatoin and default values for variables and objects found in q1.s */
  a         = malloc (sizeof (struct A)); // d0 
  a->b.a    = malloc (sizeof (struct A)); // d2
  a->x      = malloc (4 * sizeof (int)); // d1
  a->b.a->x = malloc (4 * sizeof (int)); // d3
  i = 0;
  a->x[0]        = 10; a->x[1]        = 11; a->x[2]        = 12; a->x[3]        = 13;
  a->b.y[0]      = 20; a->b.y[1]      = 21; a->b.y[2]      = 22; a->b.y[3]      = 23;
  a->b.a->x[0]   = 30; a->b.a->x[1]   = 31; a->b.a->x[2]   = 32; a->b.a->x[3]   = 33;
  a->b.a->b.y[0] = 40; a->b.a->b.y[1] = 41; a->b.a->b.y[2] = 42; a->b.a->b.y[3] = 43;

  /* alternate initializatoin from command line (for marking) */
  if (ac == 18) {
    i = atoi(av[1]);
    a->x[0]        = atoi(av[2]);  a->x[1]        = atoi(av[3]);  a->x[2]        = atoi(av[4]);  a->x[3]        = atoi(av[5]);
    a->b.y[0]      = atoi(av[6]);  a->b.y[1]      = atoi(av[7]);  a->b.y[2]      = atoi(av[8]);  a->b.y[3]      = atoi(av[9]);
    a->b.a->x[0]   = atoi(av[10]); a->b.a->x[1]   = atoi(av[11]); a->b.a->x[2]   = atoi(av[12]); a->b.a->x[3]   = atoi(av[13]);
    a->b.a->b.y[0] = atoi(av[14]); a->b.a->b.y[1] = atoi(av[15]); a->b.a->b.y[2] = atoi(av[16]); a->b.a->b.y[3] = atoi(av[17]);
  }

  /* run your code for q1.s */
  q1();

  /* print some results for marking */
  printf ("%d %d %d %d\n", v0, v1, v2, v3);
}
