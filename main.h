/* main.h -- (C) Geoffrey Reynolds, March 2009.

   Multithreaded sieve application for algorithms of the form:

   For each prime p in 3 <= p0 <= p < p1 < 2^62
     Do something with p


   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
*/

#ifndef _MAIN_H
#define _MAIN_H 1

#include <stdint.h>

#ifdef USE_BOINC
#ifndef _WIN32
#define SINGLE_THREAD
#endif
#endif

#ifdef SINGLE_THREAD
#define MAX_THREADS 1  /* Excluding parent thread */
#else
#define MAX_THREADS 128  /* Excluding parent thread */
#endif

#define BLOCKSIZE_OPT_DEFAULT 524288  /* Bytes per sieve block */
#define BLOCKSIZE_OPT_MIN 1024
#define BLOCKSIZE_OPT_MAX (1<<27)  /* 128Mb = 2^30 bits */

#define CHUNKSIZE_OPT_DEFAULT 8192  /* Bytes per sieve chunk */
#define CHUNKSIZE_OPT_MIN 16
#define CHUNKSIZE_OPT_MAX (1<<17)  /* 128Kb = 2^20 bits */

#define BLOCKS_OPT_DEFAULT 2       /* Number of sieve blocks */
#define BLOCKS_OPT_MIN 2
#define BLOCKS_OPT_MAX 4


#define PMIN_MIN 3
#define PMAX_MAX (UINT64_C(1)<<62)
#define QMAX_MAX (1U<<31)

#ifdef USE_BOINC
#define REPORT_OPT_DEFAULT 1  /* seconds between status reports */
#else
#define REPORT_OPT_DEFAULT 60  /* seconds between status reports */
#endif
#define CHECKPOINT_OPT_DEFAULT 300  /* seconds between checkpoints */

/* BOINC-compatible functions */
FILE* bfopen(const char *filename, const char *mode);
void bmsg(const char *msg);
char* bmprefix();
void bexit(int status);

extern unsigned int num_threads; /* Excluding parent thread */
extern uint64_t pmin, pmax;
extern unsigned int quiet_opt;
//extern int single_thread;	/* Flag for non-threaded operation */

#endif /* _MAIN_H */
