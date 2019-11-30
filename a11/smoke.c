#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <fcntl.h>
#include <unistd.h>
#include "uthread.h"
#include "uthread_mutex_cond.h"

#define NUM_ITERATIONS 1000

#ifdef VERBOSE
#define VERBOSE_PRINT(S, ...) printf (S, ##__VA_ARGS__);
#else
#define VERBOSE_PRINT(S, ...) ;
#endif

enum Resource            {    MATCH = 1, PAPER = 2,   TOBACCO = 4};
char* resource_name [] = {"", "match",   "paper", "", "tobacco"};
int signal_count [5];  // # of times resource signalled
int smoke_count  [5];  // # of times smoker with resource smoked

struct Agent {
  uthread_mutex_t mutex;
  uthread_cond_t  match;
  uthread_cond_t  paper;
  uthread_cond_t  tobacco;
  uthread_cond_t  smoke;
};

struct Agent* createAgent() {
  struct Agent* agent = malloc (sizeof (struct Agent));
  agent->mutex   = uthread_mutex_create();
  agent->paper   = uthread_cond_create (agent->mutex);
  agent->match   = uthread_cond_create (agent->mutex);
  agent->tobacco = uthread_cond_create (agent->mutex);
  agent->smoke   = uthread_cond_create (agent->mutex);
  return agent;
}

//
// You will probably type to add some procedures and struct etc.
//
uthread_t typeM,typeP, typeT, match, paper, tobacco;
uthread_cond_t paperCheck, tobaccoCheck, matchCheck;

struct Smoker {
  struct Agent *agent;
  int type;

  int match;
  int paper;
  int tobacco; 
};


struct Smoker* createSmoker(struct Agent *agent) {
  struct Smoker * smoker = malloc(sizeof(struct Smoker));
  smoker->agent = agent;  

  smoker->match = 0;
  smoker->paper = 0;
  smoker->tobacco = 0;
  return smoker;
}

void* smokerHelper (void* sv) {
  struct Smoker* s = sv;
  struct Agent* a = s->agent;
    if (s->tobacco == 1 && s->match == 1) {
      uthread_cond_signal (paperCheck);
      s->tobacco --;
      s->match--;
    }
    if (s->tobacco == 1 && s->paper == 1) {
      uthread_cond_signal (matchCheck);
      s->tobacco --;
      s->paper--;
    }
    if (s->paper == 1 && s->match ==  1) {
      uthread_cond_signal (tobaccoCheck);
      s->paper --;
      s->match--;
    }
  return NULL;
}


void* updateMatch (void* sv) {
  struct Smoker* s = sv;
  uthread_mutex_lock(s->agent->mutex);
  while(1){
    uthread_cond_wait(s->agent->match);
    s->match = 1;
    smokerHelper(s);
  }
  uthread_mutex_unlock(s->agent->mutex);
  return NULL;
}

void* updateTobacco (void* sv) {
  struct Smoker* s = sv;
  uthread_mutex_lock(s->agent->mutex);
  while(1) {
  uthread_cond_wait(s->agent->tobacco);
  s->tobacco = 1;
  smokerHelper(s);
  }
  uthread_mutex_unlock(s->agent->mutex);
  return NULL;
}


void* updatePaper (void* sv) {
  struct Smoker* s = sv;
  uthread_mutex_lock(s->agent->mutex);
  while(1){
    uthread_cond_wait(s->agent->paper);
    s->paper = 1;
    smokerHelper(s);
  }
  uthread_mutex_unlock(s->agent->mutex);
  return NULL;
}


// smoker checks the tag
void* tobaccoSmoker(void* sv){
  struct Smoker* s = sv;
  uthread_mutex_lock(s->agent->mutex);
  while(1){
    uthread_cond_wait(tobaccoCheck);
    uthread_cond_signal(s->agent->smoke);
    smoke_count [TOBACCO]++;
  }
  uthread_mutex_unlock(s->agent->mutex);
}

void* matchSmoker(void* sv){
  struct Smoker* s = sv;
  uthread_mutex_lock(s->agent->mutex);
  while(1){
    uthread_cond_wait(matchCheck);
    uthread_cond_signal(s->agent->smoke);
    smoke_count [MATCH]++;
  }
  uthread_mutex_unlock(s->agent->mutex);

}

void* paperSmoker(void* sv){
  struct Smoker* s = sv;
  uthread_mutex_lock(s->agent->mutex);
  while(1){
    uthread_cond_wait(paperCheck);
    uthread_cond_signal(s->agent->smoke);
    smoke_count [PAPER]++;
  }
  uthread_mutex_unlock(s->agent->mutex);

}


/**
 * You might find these declarations helpful.
 *   Note that Resource enum had values 1, 2 and 4 so you can combine resources;
 *   e.g., having a MATCH and PAPER is the value MATCH | PAPER == 1 | 2 == 3
 */

/**
 * This is the agent procedure.  It is complete and you shouldn't change it in
 * any material way.  You can re-write it if you like, but be sure that all it does
 * is choose 2 random reasources, signal their condition variables, and then wait
 * wait for a smoker to smoke.
 */
void* agent (void* av) {
  struct Agent* a = av;
  static const int choices[]         = {MATCH|PAPER, MATCH|TOBACCO, PAPER|TOBACCO};
  static const int matching_smoker[] = {TOBACCO,     PAPER,         MATCH};
  
  uthread_mutex_lock (a->mutex);
    for (int i = 0; i < NUM_ITERATIONS; i++) {
      int r = random() % 3;
      signal_count [matching_smoker [r]] ++;
      int c = choices [r];
      if (c & MATCH) {
        VERBOSE_PRINT ("match available\n");
        uthread_cond_signal (a->match);
      }
      if (c & PAPER) {
        VERBOSE_PRINT ("paper available\n");
        uthread_cond_signal (a->paper);
      }
      if (c & TOBACCO) {
        VERBOSE_PRINT ("tobacco available\n");
        uthread_cond_signal (a->tobacco);
      }
      VERBOSE_PRINT ("agent is waiting for smoker to smoke\n");
      uthread_cond_wait (a->smoke);
       //printf("%s\n", "here");
    }
  uthread_mutex_unlock (a->mutex);
  return NULL;
}

int main (int argc, char** argv) {
  uthread_init (7);

  struct Agent*  a = createAgent();
  struct Smoker* s = createSmoker(a);

  tobaccoCheck = uthread_cond_create(a->mutex);
  paperCheck = uthread_cond_create(a->mutex);
  matchCheck = uthread_cond_create(a->mutex);

  match = uthread_create(updateMatch, s);
  paper = uthread_create(updatePaper, s);
  tobacco = uthread_create(updateTobacco, s);

  typeM = uthread_create(matchSmoker, s);
  typeP = uthread_create(paperSmoker, s);
  typeT = uthread_create(tobaccoSmoker, s);

  uthread_join (uthread_create (agent, a), 0);
  assert (signal_count [MATCH]   == smoke_count [MATCH]);
  assert (signal_count [PAPER]   == smoke_count [PAPER]);
  assert (signal_count [TOBACCO] == smoke_count [TOBACCO]);
  assert (smoke_count [MATCH] + smoke_count [PAPER] + smoke_count [TOBACCO] == NUM_ITERATIONS);
  printf ("Smoke counts: %d matches, %d paper, %d tobacco\n",
          smoke_count [MATCH], smoke_count [PAPER], smoke_count [TOBACCO]);
}