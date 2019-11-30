#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "list.h"


void print (element_t ev) {
  char* e = ev;
  printf ("%s\n", e);
}

void printNum (element_t ev) {
  int* e = ev;
  printf ("%d\n", *e);
}

void stringToNum(element_t* rv, element_t av){
	// cast av as a char pointer
	// long int strtol(const char *str, char **endptr, int base)
	char* a = av;
	int** r = (int**) rv;
	char * endptr; 
	if (*r == NULL)
		*r = malloc(sizeof(int));

	**r = strtol(a, &endptr, 10);
	// if input is a string
	if(endptr == a)
		**r = -1;
}
	// f(out,in0,in1)
void numToString(element_t* rv, element_t nv, element_t sv) {
	int* n = nv;
	char* s = sv;
	char** r = (char**) rv;

	if (*r == NULL)
		*r = malloc(sizeof(element_t));
	if (*n == -1) {
		*r = s;
		//printf("%s\n", *s);
	} else {
		*r = NULL;
	}
}

int deletNeg (element_t av) {
  int *a = av;
  return *a < 0?0:1;
}

int deletNull (element_t av) {
  char *a = av;
  return (a != NULL);
}

void truncate (element_t* rv, element_t sv, element_t nv) {
	int* n = nv;
	char* s = sv;
	char** r = (char**) rv;
	char* buffer;
	buffer = malloc(sizeof(strlen(s)));

    memcpy(buffer, s, strlen(s));

	// if (*r == NULL)
	// 	*r = malloc(sizeof(element_t));
	if(strlen(s) > *n) {
		buffer[*n] = 0;
	}
	 *r = buffer;
}

void append (element_t* rv, element_t av, element_t bv) {
  char *in0 = av; 
  char *in1 = bv;
  char **r = (char**) rv;
  in0 = *r;

  size_t len;
  if (in0 == NULL) {
  	len = strlen(in1);
  } else {
  	len = strlen(in0) + strlen(in1);
  }

    	*r = realloc(*r, len);

	strcat(*r,in1);
	strcat(*r, " ");

}

void max(element_t* rv, element_t av, element_t bv) {
	int *a = av, *b = bv, **r = (int**) rv;
	 if (*r == NULL)
	 	*r = malloc(sizeof(int));
	 // printf("%d\n", *a);
	 if (*a > *b) {
	 	**r = *a;
	 } else {
	 	**r = *b;
	 }
}


int main (int argc, char* argv[]) {
	// create an empty list
	struct list *l = list_create(); 

	//append the input 
	for(int i =1; i < argc; i++) {
		list_append(l, (element_t) argv[i]);
	}
	//list_foreach(print,l);

	// create a new list of NUMBERS from *l
	struct list *numberList = list_create();
	list_map1(stringToNum, numberList, l);
	//list_foreach(printNum, numberList);
	

	struct list *newL = list_create();
	list_map2(numToString, newL, numberList, l);
	//list_foreach(print, newL);

	// filter the numberList
	struct list *posNumList = list_create();
	list_filter(deletNeg, posNumList,numberList);
	//list_foreach(printNum, posNumList);
	//printf("%s\n", "haha");

	// printf ("l is:\n");
	// list_foreach(print, l);
	// printf ("numberList is:\n");
	// list_foreach(printNum, numberList);
	// printf ("newL is:\n");
	// list_foreach(print, newL);
	struct list *notNull = list_create();
	list_filter(deletNull, notNull,newL);
	//list_foreach(print, notNull);
	//printf("%s\n", "hehe");

    struct list *trucatedList = list_create();
    list_map2(truncate, trucatedList, notNull, posNumList);
    list_foreach(print,trucatedList);
    //list_foreach(free, trucatedList);


    char *s = NULL, **sp = &s;
    list_foldl (append, (element_t*) sp, trucatedList);
    printf("%s\n", s);


  	int maxValue = 0, *mp = &maxValue;
  	list_foldl (max, (element_t*) &mp, posNumList);
  	printf ("%d\n", maxValue);

    list_destroy (l);
    list_destroy (numberList);
    list_destroy (newL);
    list_destroy (posNumList);
    list_destroy (notNull);
    list_foreach(free, trucatedList);
    list_destroy (trucatedList);

   
	
}