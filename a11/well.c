#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <fcntl.h>
#include <unistd.h>
#include "uthread.h"
#include "uthread_mutex_cond.h"

#ifdef VERBOSE
#define VERBOSE_PRINT(S, ...) printf (S, ##__VA_ARGS__);
#else
#define VERBOSE_PRINT(S, ...) ;
#endif

#define MAX_OCCUPANCY      3
#define NUM_ITERATIONS     100
#define NUM_PEOPLE         20
#define FAIR_WAITING_COUNT 4

/**
 * You might find these declarations useful.
 */
enum Endianness {LITTLE = 0, BIG = 1};
const static enum Endianness oppositeEnd [] = {BIG, LITTLE};
int bigCount = 0; // how many bigs are in 
int smallCount = 0; // how many smalls are in
int bigQ = 0; // how many bigs are in line
int smallQ = 0;

int avail = 0; // when 0, not avail, some one is in
int occupancyCount = 0; // count how many has entered

struct Well {
  // TODO
  uthread_mutex_t mx;
  uthread_cond_t empty, occupied, bigNext, smallNext;
};

struct Well* createWell() {
  struct Well* Well = malloc (sizeof (struct Well));

  // TODO
  Well->mx = uthread_mutex_create();
  // wait(empty) before entry
  // signal(empty) before leave 
  Well->empty = uthread_cond_create(Well->mx); 
  // wait(occupied) after leave
  // signal(occupied) after enter
  Well->occupied = uthread_cond_create(Well->mx); 
  // wait(bigNext) when small is in
  // signal(bignNext) when ?????
  Well->bigNext= uthread_cond_create(Well->mx);
  Well->smallNext= uthread_cond_create(Well->mx);
  return Well;
}

struct Well* Well;

#define WAITING_HISTOGRAM_SIZE (NUM_ITERATIONS * NUM_PEOPLE)
int             entryTicker;                                          // incremented with each entry
int             waitingHistogram         [WAITING_HISTOGRAM_SIZE];
int             waitingHistogramOverflow;
uthread_mutex_t waitingHistogrammutex;
int             occupancyHistogram       [2] [MAX_OCCUPANCY + 1];

void recordWaitingTime (int waitingTime) {
  uthread_mutex_lock (waitingHistogrammutex);
  if (waitingTime < WAITING_HISTOGRAM_SIZE)
    waitingHistogram [waitingTime] ++;
  else
    waitingHistogramOverflow ++;
  uthread_mutex_unlock (waitingHistogrammutex);
}

int max(int num1, int num2)
{
    return (num1 > num2 ) ? num1 : num2;
}

void enterWell (struct Well* well, enum Endianness g) {
  // TODO
  //uthread_mutex_lock(well->mx);
  if(g == BIG){
    int counter = entryTicker;
    bigQ++; // update how many bigs are waiting
    while((occupancyCount == MAX_OCCUPANCY) || (smallCount > 0)) {
      counter ++;
      uthread_cond_wait(well->bigNext);
    }
    bigQ--;
    assert(occupancyCount <=MAX_OCCUPANCY);
    assert(smallCount == 0);
    counter = entryTicker - counter;
    recordWaitingTime(counter);
    bigCount ++;
    occupancyCount ++;
    occupancyHistogram[BIG][bigCount]++;
  } 

  if(g == LITTLE) {
    int counter = entryTicker;
    smallQ++; // update how many bigs are waiting
    while((occupancyCount == MAX_OCCUPANCY) || (bigCount > 0)) {
      counter ++;
      uthread_cond_wait(well->smallNext);
    }
    smallQ--;
    assert(occupancyCount <= MAX_OCCUPANCY);
    assert(bigCount == 0);
    counter = entryTicker - counter;
    recordWaitingTime(counter);
    smallCount ++;
    occupancyCount ++;
    occupancyHistogram[LITTLE][smallCount]++;
  }
}

void leaveWell(struct Well* well) {
  if(bigCount > 0) {
    bigCount --;
    // if there is no big, signal 
    if(bigCount == 0 && smallQ > 0) {
      for (int i = 0; i < max(smallQ,3); i++)
        uthread_cond_signal(well->smallNext);
    } else {
      uthread_cond_signal(well->bigNext);
    }
    occupancyCount --;
  } 

  else  {
    smallCount --;
    if (smallCount == 0 && bigQ > 0) {
      for (int i = 0; i < max(bigQ,3); i++)
        uthread_cond_signal(well->bigNext);
    } else {
      uthread_cond_signal(well->smallNext);
    }
    occupancyCount --;
  }
}


//
// TODO
// You will probably need to create some additional produres etc.
//

void* person(void* wv) {
  struct Well* well = wv;
  // assign Endianess
  int end = random() % 2;

  // enter
  for(int i = 0; i< NUM_ITERATIONS; i++) {
    uthread_mutex_lock(well->mx);
    //printf("%d\n", end);
    // call enterWell
    enterWell(well,end);
    entryTicker ++; // do this in the function on the top keep track
    // wait for the well to be available
    // while(avail == 0) {
    //   uthread_cond_wait(well->empty);
    // }
    // someone is using the well
    //avail = 0;
    uthread_cond_signal(well->occupied);
    // uthread_mutex_unlock(well->mx);
    for(int i = 0; i< NUM_ITERATIONS; i++) {
      uthread_mutex_unlock(well->mx);
      uthread_yield();
      uthread_mutex_lock(well->mx);
    }

    // leave
    // uthread_mutex_lock(well->mx);
    leaveWell(well);
    // update availability
   // avail = 1;
    //uthread_cond_signal(well->empty);
    for(int i = 0; i< NUM_ITERATIONS; i++) {
      uthread_mutex_unlock(well->mx);
      uthread_yield();      
      uthread_mutex_lock(well->mx);
    }

    uthread_mutex_unlock(well->mx);
  }
  return NULL;
}

int main (int argc, char** argv) {
  uthread_init (3);
  Well = createWell();
  uthread_t pt [NUM_PEOPLE];
  waitingHistogrammutex = uthread_mutex_create ();

  // TODO
    for (int i = 0; i < NUM_PEOPLE; i++) {
    pt [i] = uthread_create(person, Well);
  }
      for (int i = 0; i < NUM_PEOPLE; i++) {
     uthread_join(pt[i], 0);
  }
  
  printf ("Times with 1 little endian %d\n", occupancyHistogram [LITTLE]   [1]);
  printf ("Times with 2 little endian %d\n", occupancyHistogram [LITTLE]   [2]);
  printf ("Times with 3 little endian %d\n", occupancyHistogram [LITTLE]   [3]);
  printf ("Times with 1 big endian    %d\n", occupancyHistogram [BIG] [1]);
  printf ("Times with 2 big endian    %d\n", occupancyHistogram [BIG] [2]);
  printf ("Times with 3 big endian    %d\n", occupancyHistogram [BIG] [3]);


  printf ("Waiting Histogram\n");
  for (int i=0; i<WAITING_HISTOGRAM_SIZE; i++)
    if (waitingHistogram [i])
      printf ("  Number of times people waited for %d %s to enter: %d\n", i, i==1?"person":"people", waitingHistogram [i]);
  if (waitingHistogramOverflow)
    printf ("  Number of times people waited more than %d entries: %d\n", WAITING_HISTOGRAM_SIZE, waitingHistogramOverflow);
}
