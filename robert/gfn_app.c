/* gfn_app.c -- (C) Geoffrey Reynolds, May 2009.

   A sieve for Generalised Fermat numbers a^2^m + b^2^m, m fixed.


   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <inttypes.h>
#include <getopt.h>
#ifdef _WIN32
#include <windows.h>
#else
#include <pthread.h>
#endif
#include "gfn_main.h"
#include "sieve.h"
#include "util.h"
#include "gfn_app.h"


static uint64_t amin = 0, amax = 0, abmax = 0;
static unsigned int mmin = 0, mmax = 0;
static const char *input_filename = NULL, *output_filename = NULL;
static const char *factors_filename = NULL;

static uint64_t *A, *B, *C;
static unsigned int *S, *T, alen, clen;
static uint64_t *D[MAX_THREADS];

static unsigned int remaining_terms = 0, factor_count = 0;
static unsigned char *bitmap = NULL;


#ifdef _WIN32
static CRITICAL_SECTION factors_mutex;
#else
static pthread_mutex_t factors_mutex;
#endif

static void report_factor(uint64_t k, unsigned int n,
                          unsigned int i, unsigned int m)
{
  FILE *file;

#ifdef _WIN32
  EnterCriticalSection(&factors_mutex);
#else
  pthread_mutex_lock(&factors_mutex);
#endif

  if (bitmap[i/8] & (1 << i%8))
  {
    bitmap[i/8] &= ~(1 << i%8);
    remaining_terms--;
    factor_count++;
    if ((file = fopen(factors_filename,"a")) != NULL)
    {
      fprintf(file,"%"PRIu64"*2^%u+1 | %"PRIu64"^2^%u+%"PRIu64"^2^%u\n",
              k,n,A[i],m,B[i],m);
      fclose(file);
    }
    printf("%"PRIu64"*2^%u+1 | %"PRIu64"^2^%u+%"PRIu64"^2^%u\n",
           k,n,A[i],m,B[i],m);
  }

#ifdef _WIN32
  LeaveCriticalSection(&factors_mutex);
#else
  pthread_mutex_unlock(&factors_mutex);
#endif
}


/* This function is called once before anything is done. It should at least
   print the name of the application. It can also assign default option
   values which will be overridden in the configuration file or on the
   command line.
*/
void app_banner(void)
{
  printf("Sieve for a^2^m + b^2^m with m fixed, version " APP_VERSION "\n");
#ifdef __GNUC__
  printf("Compiled " __DATE__ " with GCC " __VERSION__ "\n");
#endif
}

/* This function is called for each configuration file or command line
   option matching an entry in APP_SHORT_OPTS or APP_LONG_OPTS.
   opt is the value that would be returned by getopt_long().
   arg the value that getopt_long() would place in optarg.
   source is the name of the configuration file the option was read from, or
   NULL if the option came from the command line.

   If source is not NULL then arg (if not NULL) points to temporary memory
   and must be copied if needed.

   If opt is zero then arg is a non-option argument.

   This function should not depend on the options being read in any
   particular order, and should just do the minimum to parse the option
   and/or argument and leave the rest to app_init().

   Return 0 if the option is OK, -1 if the argument is invalid, -2 if out of
   range.
*/
int app_parse_option(int opt, char *arg, const char *source)
{
  int status = 0;

  switch (opt)
  {
    case 'a':
      status = parse_uint64(&amin,arg,1,(UINT64_C(1)<<62)-2);
      break;

    case 'A':
      status = parse_uint64(&amax,arg,2,(UINT64_C(1)<<62)-1);
      break;

    case 'm':
      status = parse_uint(&mmin,arg,1,(1U<<31)-2);
      break;

    case 'M':
      status = parse_uint(&mmax,arg,2,(1U<<31)-1);
      break;

    case 'i':
      input_filename = (source == NULL)? arg : xstrdup(arg);
      break;

    case 'o':
      output_filename = (source == NULL)? arg : xstrdup(arg);
      break;

    case 'f':
      factors_filename = (source == NULL)? arg : xstrdup(arg);
      break;
  }

  return status;
}

void app_help(void)
{
  printf("-a --amin=A0\n");
  printf("-A --amax=A1       Sieve a^2^m+(a+1)^2^m for A0 <= a < A1\n");
  printf("-m --mmin=M0\n");
  printf("-M --mmax=M1       Sieve a^2^m+(a+1)^2^m for M0 <= m < M1\n");
  printf("-i --input=FILE    Read initial sieve from FILE\n");
  printf("-o --output=FILE   Write final sieve to FILE\n");
  printf("-f --factors=FILE  Write factors to FILE (default `%s')\n",
         FACTORS_FILENAME_DEFAULT);
}

/* This function is called once before any threads are started.
 */
void app_init(void)
{
  FILE *file;
  uint64_t a, b;
  unsigned int i, j, m0, m1;

  if (input_filename == NULL && (amin == 0 || mmin == 0))
  {
    fprintf(stderr,"Specify an input file or parameters for a new sieve.\n");
    exit(EXIT_FAILURE);
  }

  if (input_filename == NULL)
  {
    if (amax == 0)
      amax = amin+1;
    if (mmax == 0)
      mmax = mmin+1;

    if (amax <= amin)
    {
      fprintf(stderr,"amax must be greater than amin\n");
      exit(EXIT_FAILURE);
    }
    if (mmax <= mmin)
    {
      fprintf(stderr,"mmax must be greater than mmin\n");
      exit(EXIT_FAILURE);
    }
#if 1
    if (mmax != mmin+1)
    {
      fprintf(stderr,"Multiple m not implemented\n");
      exit(EXIT_FAILURE);
    }
#endif

    if (amax-amin > ((1U<<31)-1)/sizeof(uint64_t))
    {
      fprintf(stderr,"amax-amin out of range\n");
      exit(EXIT_FAILURE);
    }

    alen = amax-amin;
    A = xmalloc(alen*sizeof(uint64_t));
    B = xmalloc(alen*sizeof(uint64_t));
    for (i = 0; i < alen; i++)
    {
      A[i] = amin+i;
      B[i] = amin+i+1;
    }
    abmax = amax+1;
  }
  else
  {
    if ((file = fopen(input_filename,"r")) == NULL)
    {
      fprintf(stderr,"Cannot open input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    if (fscanf(file," ABC $a^(2^%u)+$b^(2^%u)",&m0,&m1) != 2 || m0 != m1)
    {
      fprintf(stderr,"Invalid header in input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    for (i = 0; fscanf(file," %"SCNu64" %"SCNu64,&a,&b) == 2; i++)
      ;

    fclose(file);

    if (i == 0)
    {
      fprintf(stderr,"Empty input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    A = xmalloc(i*sizeof(uint64_t));
    B = xmalloc(i*sizeof(uint64_t));

    if ((file = fopen(input_filename,"r")) == NULL)
    {
      fprintf(stderr,"Cannot open input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    if (fscanf(file," ABC $a^(2^%u)+$b^(2^%u)",&m0,&m1) != 2 || m0 != m1)
    {
      fprintf(stderr,"Invalid header in input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    mmin = mmax = m0;
    abmax = 0;

    for (j = 0; fscanf(file," %"SCNu64" %"SCNu64,&a,&b) == 2; j++)
    {
      if (a == 0 || b == 0 || a == b)
      {
        fprintf(stderr,"Invalid line %u in input file `%s'\n",j+2,input_filename);
        exit(EXIT_FAILURE);
      }
      A[j] = a;
      B[j] = b;
      if (a > abmax)
        abmax = a;
      if (b > abmax)
        abmax = b;
    }

    fclose(file);

    if (i != j)
    {
      fprintf(stderr,"Error reading input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    alen = i;
  }

  C = xmalloc((alen*2+VEC_LEN-1)*sizeof(uint64_t));
  S = xmalloc(alen*sizeof(unsigned int));
  T = xmalloc(alen*sizeof(unsigned int));

  for (i = 0, clen = 0; i < alen; i++)
  {
    a = A[i];
    b = B[i];

    for (j = clen; j > 0; j--)
      if (a == C[j-1])
        break;
    if (j == 0)
      C[clen] = a, S[i] = clen++;
    else
      S[i] = j-1;

    for (j = clen; j > 0; j--)
      if (b == C[j-1])
        break;
    if (j == 0)
      C[clen] = b, T[i] = clen++;
    else
      T[i] = j-1;
  }

  C = xrealloc(C,(clen+VEC_LEN-1)*sizeof(uint64_t));
  for (i = 0; i < VEC_LEN-1; i++)
    C[clen+i] = 0;

  bitmap = xmalloc((alen+7)/8);
  memset(bitmap,-1,(alen+7)/8);

  remaining_terms = alen;
  factor_count = 0;

  if (input_filename == NULL)
  {
    printf("Starting a new sieve for %u terms a^2^%u+b^2^%u"
           " (with %u unique elements a,b)\n",alen,mmin,mmin,clen);
  }
  else
  {
    printf("Read %u terms a^2^%u+b^2^%u (with %u unique elements a,b)"
           " from input file `%s'\n",alen,mmin,mmin,clen,input_filename);
  }

  if (factors_filename == NULL)
    factors_filename = FACTORS_FILENAME_DEFAULT;
#ifdef _WIN32
  InitializeCriticalSection(&factors_mutex);
#else
  pthread_mutex_init(&factors_mutex,NULL);
#endif

  for (i = 0; i < num_threads; i++)
    D[i] = xmalloc((clen+VEC_LEN-1)*sizeof(uint64_t));
}

/* This function is called once in thread th, 0 <= th < num_threads, before
   the first call to app_thread_fun(th, ...).
 */
void app_thread_init(int th)
{
  uint16_t mode;

  /* Set FPU to use extended precision and round to zero. This has to be
     done here rather than in app_init() because _beginthreadex() doesn't
     preserve the FPU mode. */

  asm ("fnstcw %0" : "=m" (mode) );
  mode |= 0x0F00;
  asm volatile ("fldcw %0" : : "m" (mode) );
}

#if 0
/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
*/
void app_thread_fun(int th, uint64_t k)
{
  uint64_t p, U[VEC_LEN], *V;
  unsigned int i, j, n, m, u;

  n = nmin;
  m = mmin;
  p = (k << n)+1;
  V = D[th];

  /* V <-- C mod k*2^n+1 */
  if (abmax < p)
    for (j = 0; j < clen; j += VEC_LEN)
      for (u = 0; u < VEC_LEN; u++)
        V[j+u] = C[j+u];
  else
    for (j = 0; j < clen; j += VEC_LEN)
      for (u = 0; u < VEC_LEN; u++)
        V[j+u] = C[j+u]%p;

  asm volatile ("fildll %0\n\t"
                "fld1\n\t"
                "fdivp"
                : : "m" (p) );

  /* V <-- C^2^m mod k*2^n+1 */
  for (i = 0; i < m; i++)
    for (j = 0; j < clen; j += VEC_LEN)
    {
      for (u = 0; u < VEC_LEN; u++)
        asm ("fildll %1\n\t"
             "fmul %%st(0), %%st(0)\n\t"
             "fmul %%st(1)\n\t"
             "fistpll %0"
             : "=m" (U[u]) : "m" (V[j+u]) );

      for (u = 0; u < VEC_LEN; u++)
        if ((V[j+u] = V[j+u]*V[j+u] - U[u]*p) >= p)
          V[j+u] -= p;
    }

  asm volatile ("fstp %st(0)");

  for (i = 0; i < alen; i++)
    if (V[S[i]] + V[T[i]] == p)
      report_factor(k,n,i,m);
}
#endif

/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
   K is an array of APP_PRIMES_BUFLEN candidates.
*/
void app_thread_fun(int th, uint64_t *K)
{
  app_thread_fun1(th,K,APP_BUFLEN);
}

/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
   K is an array of len candidats, 0 <= len < APP_PRIMES_BUFLEN.
   The application should be prepared to checkpoint after returning from
   this function.
*/
void app_thread_fun1(int th, uint64_t *K, unsigned int len)
{
  uint64_t p, U[VEC_LEN] __attribute__((aligned(16))), *V;
  unsigned int h, i, j, u, n, m;

  n = nmin;
  m = mmin;
  V = D[th];

  for (h = 0; h < len; h++)
  {
    p = (K[h]<<n)|1;

    /* V <-- C mod k*2^n+1 */
    if (abmax < p)
      for (j = 0; j < clen; j += VEC_LEN)
        for (u = 0; u < VEC_LEN; u++)
          V[j+u] = C[j+u];
    else
      for (j = 0; j < clen; j += VEC_LEN)
        for (u = 0; u < VEC_LEN; u++)
          V[j+u] = C[j+u]%p;

    asm volatile ("fildll %0\n\t"
                  "fld1\n\t"
                  "fdivp"
                  : : "m" (p) );

    /* V <-- C^2^m mod k*2^n+1 */
    for (i = 0; i < m; i++)
      for (j = 0; j < clen; j += VEC_LEN)
      {
        for (u = 0; u < VEC_LEN; u++)
          asm ("fildll %1\n\t"
               "fmul %%st(0), %%st(0)\n\t"
               "fmul %%st(1)\n\t"
               "fistpll %0"
               : "=m" (U[u]) : "m" (V[j+u]) );

        for (u = 0; u < VEC_LEN; u++)
          if ((V[j+u] = V[j+u]*V[j+u] - U[u]*p) >= p)
            V[j+u] -= p;
      }

    asm volatile ("fstp %st(0)");

    for (i = 0; i < alen; i++)
      if (V[S[i]] + V[T[i]] == p)
        report_factor(K[h],n,i,m);
  }
}

/* This function is called once in thread th, 0 <= th < num_threads.
*/
void app_thread_fini(int th)
{
}

/* This function is called at most once, after app_init() but before any
   threads have started, with fin open for reading.
   Return 0 if the checkpoint data is invalid, which will cause this
   checkpoint to be ignored.
*/
int app_read_checkpoint(FILE *fin)
{
  unsigned int m0, m1;

  if (fscanf(fin,"mmin=%u,mmax=%u,factor_count=%u",&m0,&m1,&factor_count) != 3)
    return 0;

  if (m0 != mmin || m1 != mmax)
    return 0;

  return 1;
}

/* This function is called periodically with fout open for writing. The
   application can assume that the following conditions apply:

   Threads are blocked for the duration of this call, or have already
   exited. (And so app_thread_fini(th) may have been called already).

   All candidates before, and no candidates after the checkpoint have been
   passed to one of the functions app_thread_fun() or app_thread_fun1().
*/
void app_write_checkpoint(FILE *fout)
{
  fprintf(fout,"mmin=%u,mmax=%u,factor_count=%u\n",mmin,mmax,factor_count);

  if (output_filename != NULL)
  {
    FILE *file;
    unsigned int i;

    if ((file = fopen(output_filename, "w")) == NULL)
    {
      fprintf(stderr,"Cannot open output file `%s'\n",output_filename);
      return;
    }

    fprintf(file,"ABC $a^(2^%u)+$b^(2^%u)\n",mmin,mmin);

    for (i = 0; i < alen; i++)
      if (bitmap[i/8] & (1 << i%8))
        fprintf(file,"%"PRIu64" %"PRIu64"\n",A[i],B[i]);

    fclose(file);
  }
}

/* This function is called once after all threads have exited.
 */
void app_fini(void)
{
  unsigned int i;

  printf("Found factors for %u term%s, %u remain%s\n",
         factor_count, (factor_count==1)? "":"s",
         remaining_terms, (remaining_terms==1)? "s":"");

#ifdef _WIN32
  DeleteCriticalSection(&factors_mutex);
#else
  pthread_mutex_destroy(&factors_mutex);
#endif

  for (i = 0; i < num_threads; i++)
    free(D[i]);

  free(bitmap);
  free(T);
  free(S);
  free(C);
  free(B);
  free(A);
}
