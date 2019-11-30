#include <stdlib.h>
#include <stdio.h>
#include "uthread.h"
#include "uthread_mutex_cond.h"

#define NUM_THREADS 3
int n = NUM_THREADS;
uthread_t threads[NUM_THREADS];
uthread_mutex_t mLock;
uthread_cond_t cLock;

void randomStall() {
  int i, r = random() >> 16;
  while (i++<r);
}

void waitForAllOtherThreads() {
  uthread_mutex_lock(mLock);
  n--;
  if (n == 0) {
    uthread_cond_broadcast(cLock);
  } else {
    while (n !=0) {
      uthread_cond_wait(cLock);
    }
  }
  
  uthread_mutex_unlock(mLock);
}


void* p(void* v) {
  randomStall();
  printf("a\n");
  waitForAllOtherThreads();
  printf("b\n");
  return NULL;
}

int main(int arg, char** arv) {
  uthread_init(4);
  mLock = uthread_mutex_create();
  cLock = uthread_cond_create(mLock);
  for (int i=0; i<NUM_THREADS; i++)
    threads[i] = uthread_create(p, NULL);
  for (int i=0; i<NUM_THREADS; i++)
    uthread_join (threads[i], NULL);
  printf("------\n");
  uthread_mutex_destroy(mLock);
  uthread_cond_destroy(cLock);
}