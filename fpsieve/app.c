/* app.c -- (C) March 2009, Mark Rodenkirch, Geoffrey Reynolds.

   Factorial/primorial sieve application.


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
#include "main.h"
#include "sieve.h"
#include "util.h"
#include "app.h"


#define MODE_NONE 0
#define MODE_FACTORIAL 1
#define MODE_PRIMORIAL 2

static unsigned char *plus_list = NULL, *minus_list = NULL;
static unsigned int nmin = 0, nmax = 0;
static const char *input_filename = NULL, *output_filename = NULL;
static const char *factors_filename = NULL;
static unsigned int remaining_terms = 0, factor_count = 0;
static int mode = MODE_NONE, prime_base = 0, prime_count = 0;
#if __i386__ && !__SSE2__
static int sse2_opt = 0;
#endif


#if defined(__ppc__) || defined(__ppc64__)
#include <ppc_intrinsics.h>
// 2^52
static const double fround = 6755399441055744.0;
static double *primeDouble;

void convert(int64_t *rems,
            double rem1, double rem2, double rem3,
            double rem4, double rem5, double rem6);
#endif

#if defined(__x86_64__) && APP_BUFLEN==4
int factorial4_x86_64(int n0, int n1, const uint64_t *F, const uint64_t *P)
     __attribute__ ((pure));
int primorial4_x86_64(const uint32_t *N, const uint64_t *P, int n1)
     __attribute__ ((pure));
#elif defined(__i386__) && APP_BUFLEN==4
int factorial4_x86_sse2(int n0, int n1, const uint64_t *F, const uint64_t *P)
     __attribute__ ((pure));
int primorial4_x86_sse2(const uint32_t *N, const uint64_t *P, int n1)
     __attribute__ ((pure));
# if !__SSE2__ /* SSE2 not available at compile time, check at run time */
int factorial4_x86(int n0, int n1, const uint64_t *F, const uint64_t *P)
     __attribute__ ((pure));
int primorial4_x86(const uint32_t *N, const uint64_t *P, int n1)
     __attribute__ ((pure));
int have_sse2(void) __attribute__ ((const));
static int (*factorial4_fun)(int n0, int n1, const uint64_t *F, const uint64_t *P);
static int (*primorial4_fun)(const uint32_t *N, const uint64_t *P, int n1);
# endif
#endif

#ifdef _WIN32
static CRITICAL_SECTION factors_mutex;
#else
static pthread_mutex_t factors_mutex;
#endif

static void report_factor(unsigned int n, int c, uint64_t p)
{
  FILE *file;
  unsigned char *list;
  unsigned int bit;

  if (c < 0)
    list = minus_list;
  else
    list = plus_list;

  if (mode == MODE_FACTORIAL)
    bit = n-nmin;
  else
    bit = n-prime_base;

#ifdef _WIN32
  EnterCriticalSection(&factors_mutex);
#else
  pthread_mutex_lock(&factors_mutex);
#endif

  if (list[bit/8] & (1 << bit%8))
  {
    list[bit/8] &= ~(1 << bit%8);
    remaining_terms--;
    factor_count++;
    if ((file = fopen(factors_filename,"a")) != NULL)
    {
      if (mode == MODE_FACTORIAL)
        fprintf(file,"%"PRIu64" | %u!%+d\n",p,n,c);
      else
        fprintf(file,"%"PRIu64" | %u#%+d\n",p,sieve_primes[n],c);
      fclose(file);
    }
    if (mode == MODE_FACTORIAL)
      printf("%"PRIu64" | %u!%+d\n",p,n,c);
    else
      printf("%"PRIu64" | %u#%+d\n",p,sieve_primes[n],c);
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
  printf("fpsieve version " APP_VERSION " (testing)\n");
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
    case 'n':
      status = parse_uint(&nmin,arg,3,(1U<<31)-1);
      break;

    case 'N':
      status = parse_uint(&nmax,arg,3,(1U<<31)-1);
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

    case 'x':
      mode = MODE_FACTORIAL;
      break;

    case 'y':
      mode = MODE_PRIMORIAL;
      break;

#if __i386__ && !__SSE2__
    case SSE2_OPT:
      sse2_opt = 1;
      break;

    case NO_SSE2_OPT:
      sse2_opt = -1;
      break;
#endif
  }

  return status;
}

void app_help(void)
{
  printf("-n --nmin=N0\n");
  printf("-N --nmax=N1       Sieve n!/n# in N0 <= n <= N1\n");
  printf("-i --input=FILE    Read initial sieve from FILE\n");
  printf("-o --output=FILE   Write final sieve to FILE\n");
  printf("-f --factors=FILE  Write factors to FILE (default `%s')\n",
         FACTORS_FILENAME_DEFAULT);
  printf("-x --factorial     Factorial mode\n");
  printf("-y --primorial     Primorial mode\n");
#if __i386__ && !__SSE2__
  printf("   --sse2          Use SSE2 instructions\n");
  printf("   --no-sse2       Don't use SSE2 instructions\n");
#endif
}

/* This function is called once after config file and command-line options
   have been processed but before any threads are started.
 */
void app_init(void)
{
  size_t bytes;

#if defined(__x86_64__)
  if (pmax >= (UINT64_C(1) << 51))
  {
    fprintf(stderr,"pmax < 2^51 required for x86_64 version.\n");
    exit(EXIT_FAILURE);
  }
#elif defined(__i386__)
  if (pmax >= (UINT64_C(1) << 62))
  {
    fprintf(stderr,"pmax < 2^62 required for x86 version.\n");
    exit(EXIT_FAILURE);
  }
#endif

  if (input_filename == NULL && nmax == 0)
  {
    fprintf(stderr,"Specify an input file, or a range N0 <= n <= N1 to begin a new sieve.\n");
    exit(EXIT_FAILURE);
  }

  if (input_filename == NULL)
  {
    if (nmin < 3)
      nmin = 3;
    if (nmax > (1U<<31)-1)
      nmax = (1U<<31)-1;
    if (nmax < nmin)
    {
      fprintf(stderr,"nmax must not be less than nmin\n");
      exit(EXIT_FAILURE);
    }
    if (mode == MODE_NONE)
    {
      fprintf(stderr,"No mode selected, using factorial\n");
      mode = MODE_FACTORIAL;
    }
  }
  else
  {
    FILE *file;
    unsigned int n;
    int c;
    char ch1, ch2;

    if ((file = fopen(input_filename,"r")) == NULL)
    {
      fprintf(stderr,"Cannot open input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    if (fscanf(file,"ABC $a%c+$%c%*[^\n]",&ch1,&ch2) != 2 || ch2 != 'b')
    {
      fprintf(stderr,"Invalid header in input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    if (ch1 == '!')
    {
      if (mode == MODE_PRIMORIAL)
      {
        fprintf(stderr,"Primorial mode selected but input file `%s' is factorial\n",input_filename);
        exit(EXIT_FAILURE);
      }
      mode = MODE_FACTORIAL;
    }
    else if (ch1 == '#')
    {
      if (mode == MODE_FACTORIAL)
      {
        fprintf(stderr,"Factorial mode selected but input file `%s' is primorial\n",input_filename);
        exit(EXIT_FAILURE);
      }
      mode = MODE_PRIMORIAL;
    }
    else
    {
      fprintf(stderr,"Invalid header in input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    nmin = 1U<<31;
    nmax = 0;
    while (fscanf(file," %u %d",&n,&c) == 2)
    {
      if (n < nmin)
        nmin = n;
      if (n > nmax)
        nmax = n;
    }

    fclose(file);
    if (nmax == 0) 
    {
      fprintf(stderr,"Invalid input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }
  }

  if (mode == MODE_FACTORIAL)
    bytes = (nmax-nmin+8)/8;
  else
  {
    init_sieve_primes(nmax);
    for (prime_base = 0; sieve_primes[prime_base] < nmin; prime_base++)
      ;
    for (prime_count = 0; sieve_primes[prime_count] <= nmax; prime_count++)
      ;
    bytes = (prime_count-prime_base+7)/8;
  }

  plus_list = xmalloc(bytes);
  minus_list = xmalloc(bytes);

  if (input_filename == NULL)
  {
    memset(plus_list,-1,bytes);
    memset(minus_list,-1,bytes);
    if (mode == MODE_FACTORIAL)
      remaining_terms = 2*(nmax-nmin+1);
    else
      remaining_terms = 2*(prime_count-prime_base);
  }
  else
  {
    FILE *file;
    unsigned int n, bit, count;
    int c;
    char ch1, ch2;

    if ((file = fopen(input_filename,"r")) == NULL)
    {
      fprintf(stderr,"Cannot open input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    if (fscanf(file,"ABC $a%c+$%c%*[^\n]",&ch1,&ch2) != 2 || ch2 != 'b')
    {
      fprintf(stderr,"Invalid header in input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    memset(plus_list,0,bytes);
    memset(minus_list,0,bytes);

    count = 0;
    bit = 0;
    while (fscanf(file," %u %d",&n,&c)==2)
    {
      if (n < nmin || n > nmax || (c != 1 && c != -1))
      {
        fprintf(stderr,"Invalid line `%u %d' in `%s'\n",n,c,input_filename);
        exit(EXIT_FAILURE);
      }
      if (mode == MODE_FACTORIAL)
        bit = n-nmin;
      else
      {
        /* This assumes that n is non-decreasing */
        for ( ; sieve_primes[prime_base+bit] < n; bit++)
          ;
        if (sieve_primes[prime_base+bit] != n)
        {
          fprintf(stderr,"non-prime %u in input file `%s'\n",n,input_filename);
          exit(EXIT_FAILURE);
        }
      }
      if (c > 0 && (plus_list[bit/8] & (1<<bit%8)) == 0)
        plus_list[bit/8] |= (1<<bit%8), count++;
      else if (c < 0 && (minus_list[bit/8] & (1<<bit%8)) == 0)
        minus_list[bit/8] |= (1<<bit%8), count++;
    }

    if (ferror(file))
    {
      fprintf(stderr,"Error reading input file `%s'\n",input_filename);
      exit(EXIT_FAILURE);
    }

    fclose(file);

    printf("Read %u term%s from input file `%s'\n",
           count, (count==1)? "":"s", input_filename);
    remaining_terms = count;
  }

#if defined(__ppc__) || defined(__ppc64__)
  int i;
  primeDouble = (double *)xmalloc(prime_count*sizeof(double));
  for (i = 0; i < prime_count; i++)
    primeDouble[i] = (double)sieve_primes[i];
#endif

#if defined(__i386__) && !defined(__SSE2__) && APP_BUFLEN==4
  if (sse2_opt == 1 || (sse2_opt == 0 && have_sse2()))
  {
    printf("Using SSE2 code path\n");
    factorial4_fun = factorial4_x86_sse2;
    primorial4_fun = primorial4_x86_sse2;
  }
  else
  {
    printf("Using non-SSE2 code path\n");
    factorial4_fun = factorial4_x86;
    primorial4_fun = primorial4_x86;
  }
#endif

  if (factors_filename == NULL)
    factors_filename = FACTORS_FILENAME_DEFAULT;
#ifdef _WIN32
  InitializeCriticalSection(&factors_mutex);
#else
  pthread_mutex_init(&factors_mutex,NULL);
#endif

  printf("%s sieve initialized: %u <= n <= %u\n",
         (mode == MODE_FACTORIAL)? "factorial":"primorial",nmin,nmax);
}

/* This function is called once in thread th, 0 <= th < num_threads, before
   the first call to app_thread_fun(th, ...).
 */
void app_thread_init(int th)
{
}

/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
   P is an array of APP_BUFLEN candidate primes.
*/
void app_thread_fun(int th, uint64_t *P)
{
#if defined(__ppc__) || defined(__ppc64__)
  int n;
  double p1d, p2d, p3d, p4d, p5d, p6d;
  double p1r, p2r, p3r, p4r, p5r, p6r;
  double rem1 = 2.0, rem2 = 2.0, rem3 = 2.0, rem4 = 2.0, rem5 = 2.0, rem6 = 2.0;
  double ab1, ab2, ab3, ab4, ab5, ab6;
  double hi1, hi2, hi3, hi4, hi5, hi6;
  double lo1, lo2, lo3, lo4, lo5, lo6;
  double q1, q2, q3, q4, q5, q6;
  int64_t rems[6];

  p1d = (double)P[0];
  p2d = (double)P[1];
  p3d = (double)P[2];
  p4d = (double)P[3];
  p5d = (double)P[4];
  p6d = (double)P[5];

  p1r = 1.0 / p1d;
  p2r = 1.0 / p2d;
  p3r = 1.0 / p3d;
  p4r = 1.0 / p4d;
  p5r = 1.0 / p5d;
  p6r = 1.0 / p6d;

  if (mode == MODE_FACTORIAL)
  {
    for (n=3; n<nmax; n++)
    {
      // ab = rem * prime
      ab1 = rem1 * n;
      ab2 = rem2 * n;
      ab3 = rem3 * n;
      ab4 = rem4 * n;
      ab5 = rem5 * n;
      ab6 = rem6 * n;

      // q = ab * 1/p + MAGIC
      q1 = __fmadd(ab1, p1r, fround);
      q2 = __fmadd(ab2, p2r, fround);
      q3 = __fmadd(ab3, p3r, fround);
      q4 = __fmadd(ab4, p4r, fround);
      q5 = __fmadd(ab5, p5r, fround);
      q6 = __fmadd(ab6, p6r, fround);

      // q = q - MAGIC
      q1 -= fround;
      q2 -= fround;
      q3 -= fround;
      q4 -= fround;
      q5 -= fround;
      q6 -= fround;

      // hi = p * q;
      hi1 = p1d * q1;
      hi2 = p2d * q2;
      hi3 = p3d * q3;
      hi4 = p4d * q4;
      hi5 = p5d * q5;
      hi6 = p6d * q6;

      // lo = p * q - hi
      lo1 = __fmsub(p1d, q1, hi1);
      lo2 = __fmsub(p2d, q2, hi2);
      lo3 = __fmsub(p3d, q3, hi3);
      lo4 = __fmsub(p4d, q4, hi4);
      lo5 = __fmsub(p5d, q5, hi5);
      lo6 = __fmsub(p6d, q6, hi6);

      // ab = rem * prime - hi
      ab1 = __fmsub(rem1, n, hi1);
      ab2 = __fmsub(rem2, n, hi2);
      ab3 = __fmsub(rem3, n, hi3);
      ab4 = __fmsub(rem4, n, hi4);
      ab5 = __fmsub(rem5, n, hi5);
      ab6 = __fmsub(rem6, n, hi6);

      // rem = ab - lo
      rem1 = ab1 - lo1;
      rem2 = ab2 - lo2;
      rem3 = ab3 - lo3;
      rem4 = ab4 - lo4;
      rem5 = ab5 - lo5;
      rem6 = ab6 - lo6;

      ab1 = rem1 + p1d;
      ab2 = rem2 + p2d;
      ab3 = rem3 + p3d;
      ab4 = rem4 + p4d;
      ab5 = rem5 + p5d;
      ab6 = rem6 + p6d;

      // The remainders must always be positive for the next iteration of the loop
      if (rem1 < 0.0) rem1 = ab1;
      if (rem2 < 0.0) rem2 = ab2;
      if (rem3 < 0.0) rem3 = ab3;
      if (rem4 < 0.0) rem4 = ab4;
      if (rem5 < 0.0) rem5 = ab5;
      if (rem6 < 0.0) rem6 = ab6;

      if (n >= nmin)
      {
        convert(rems, rem1, rem2, rem3, rem4, rem5, rem6);

        if (rems[0] ==      1) report_factor(n, -1, P[0]);
        if (rems[1] ==      1) report_factor(n, -1, P[1]);
        if (rems[2] ==      1) report_factor(n, -1, P[2]);
        if (rems[3] ==      1) report_factor(n, -1, P[3]);
        if (rems[4] ==      1) report_factor(n, -1, P[4]);
        if (rems[5] ==      1) report_factor(n, -1, P[5]);

        if (rems[0] == P[0]-1) report_factor(n,  1, P[0]);
        if (rems[1] == P[1]-1) report_factor(n,  1, P[1]);
        if (rems[2] == P[2]-1) report_factor(n,  1, P[2]);
        if (rems[3] == P[3]-1) report_factor(n,  1, P[3]);
        if (rems[4] == P[4]-1) report_factor(n,  1, P[4]);
        if (rems[5] == P[5]-1) report_factor(n,  1, P[5]);
      }
    }
  }
  else /* mode == MODE_PRIMORIAL */
  {
    for (n=0; n<prime_count; n++)
    {
#if defined(__GNUC__) && defined(PREFETCH)
      __builtin_prefetch(&primeDouble[n+PREFETCH],0,0);
#endif

      // ab = rem * prime
      ab1 = rem1 * primeDouble[n];
      ab2 = rem2 * primeDouble[n];
      ab3 = rem3 * primeDouble[n];
      ab4 = rem4 * primeDouble[n];
      ab5 = rem5 * primeDouble[n];
      ab6 = rem6 * primeDouble[n];

      // q = ab * 1/p + MAGIC
      q1 = __fmadd(ab1, p1r, fround);
      q2 = __fmadd(ab2, p2r, fround);
      q3 = __fmadd(ab3, p3r, fround);
      q4 = __fmadd(ab4, p4r, fround);
      q5 = __fmadd(ab5, p5r, fround);
      q6 = __fmadd(ab6, p6r, fround);

      // q = q - MAGIC
      q1 -= fround;
      q2 -= fround;
      q3 -= fround;
      q4 -= fround;
      q5 -= fround;
      q6 -= fround;

      // hi = p * q;
      hi1 = p1d * q1;
      hi2 = p2d * q2;
      hi3 = p3d * q3;
      hi4 = p4d * q4;
      hi5 = p5d * q5;
      hi6 = p6d * q6;

      // lo = p * q - hi
      lo1 = __fmsub(p1d, q1, hi1);
      lo2 = __fmsub(p2d, q2, hi2);
      lo3 = __fmsub(p3d, q3, hi3);
      lo4 = __fmsub(p4d, q4, hi4);
      lo5 = __fmsub(p5d, q5, hi5);
      lo6 = __fmsub(p6d, q6, hi6);

      // ab = rem * prime - hi
      ab1 = __fmsub(rem1, primeDouble[n], hi1);
      ab2 = __fmsub(rem2, primeDouble[n], hi2);
      ab3 = __fmsub(rem3, primeDouble[n], hi3);
      ab4 = __fmsub(rem4, primeDouble[n], hi4);
      ab5 = __fmsub(rem5, primeDouble[n], hi5);
      ab6 = __fmsub(rem6, primeDouble[n], hi6);

      // rem = ab - lo
      rem1 = ab1 - lo1;
      rem2 = ab2 - lo2;
      rem3 = ab3 - lo3;
      rem4 = ab4 - lo4;
      rem5 = ab5 - lo5;
      rem6 = ab6 - lo6;

      ab1 = rem1 + p1d;
      ab2 = rem2 + p2d;
      ab3 = rem3 + p3d;
      ab4 = rem4 + p4d;
      ab5 = rem5 + p5d;
      ab6 = rem6 + p6d;

      // The remainders must always be positive for the next iteration of the loop
      if (rem1 < 0.0) rem1 = ab1;
      if (rem2 < 0.0) rem2 = ab2;
      if (rem3 < 0.0) rem3 = ab3;
      if (rem4 < 0.0) rem4 = ab4;
      if (rem5 < 0.0) rem5 = ab5;
      if (rem6 < 0.0) rem6 = ab6;

      if (sieve_primes[n] >= nmin)
      {
        convert(rems, rem1, rem2, rem3, rem4, rem5, rem6);

        if (rems[0] ==      1) report_factor(n, -1, P[0]);
        if (rems[1] ==      1) report_factor(n, -1, P[1]);
        if (rems[2] ==      1) report_factor(n, -1, P[2]);
        if (rems[3] ==      1) report_factor(n, -1, P[3]);
        if (rems[4] ==      1) report_factor(n, -1, P[4]);
        if (rems[5] ==      1) report_factor(n, -1, P[5]);

        if (rems[0] == P[0]-1) report_factor(n,  1, P[0]);
        if (rems[1] == P[1]-1) report_factor(n,  1, P[1]);
        if (rems[2] == P[2]-1) report_factor(n,  1, P[2]);
        if (rems[3] == P[3]-1) report_factor(n,  1, P[3]);
        if (rems[4] == P[4]-1) report_factor(n,  1, P[4]);
        if (rems[5] == P[5]-1) report_factor(n,  1, P[5]);
      }
    }
  }
#else
  uint64_t REM[APP_BUFLEN] __attribute__ ((aligned(16)));
  unsigned int j, n;

  if (mode == MODE_FACTORIAL)
  {
    /* Set REM[j] = n! (mod P[j]) for some n < nmin. (Ideally n = nmin-1).
       There are faster ways to do this than iterating over each j < n, but
       for testing purposes it is sufficient to just set n = 2 and let the
       main sieve loop do the work.
    */
    n = 2;
    for (j = 0; j < APP_BUFLEN; j++)
      REM[j] = 2;

#if defined(__x86_64__) && APP_BUFLEN==4
    if (factorial4_x86_64(n,nmax,REM,P))
#elif defined(__i386__) && defined(__SSE2__) && APP_BUFLEN==4
    if (factorial4_x86_sse2(n,nmax,REM,P))
#elif defined(__i386__) && !defined(__SSE2__) && APP_BUFLEN==4
    if (factorial4_fun(n,nmax,REM,P))
#endif
    {
      double INV[APP_BUFLEN];

      for (j = 0; j < APP_BUFLEN; j++)
        INV[j] = 1.0/P[j];

      while (++n <= nmax)
      {
        for (j = 0; j < APP_BUFLEN; j++)
        {
          int64_t p = P[j], q, r = REM[j];

          q = (double)r * (double)n * INV[j];
          r = r*n - p*q;

          if (r < 0)
            r += p;
          else if (r >= p)
            r -= p;

          REM[j] = r;
        }

        if (n >= nmin)
        {
          for (j = 0; j < APP_BUFLEN; j++)
          {
            if (REM[j] ==      1) report_factor(n, -1, P[j]);
            if (REM[j] == P[j]-1) report_factor(n,  1, P[j]);
          }
        }
      }
    }
  }
  else /* mode == MODE_PRIMORIAL */
  {
#if defined(__x86_64__) && APP_BUFLEN==4
    if (primorial4_x86_64(sieve_primes,P,nmax))
#elif defined(__i386__) && defined(__SSE2__) && APP_BUFLEN==4
    if (primorial4_x86_sse2(sieve_primes,P,nmax))
#elif defined(__i386__) && !defined(__SSE2__) && APP_BUFLEN==4
    if (primorial4_fun(sieve_primes,P,nmax))
#endif
    {
      int i;
      double INV[APP_BUFLEN];

      for (j = 0; j < APP_BUFLEN; j++)
      {
        INV[j] = 1.0/P[j];
        REM[j] = 2;
      }

      for (i = 0; i < prime_count; i++)
      {
#if defined(__GNUC__) && defined(PREFETCH)
        __builtin_prefetch(&sieve_primes[i+PREFETCH],0,0);
#endif

        n = sieve_primes[i];

        for (j = 0; j < APP_BUFLEN; j++)
        {
          int64_t p = P[j], q, r = REM[j];

          q = (double)r * (double)n * INV[j];
          r = r*n - p*q;

          if (r < 0)
            r += p;
          else if (r >= p)
            r -= p;

          REM[j] = r;
        }

        if (n >= nmin)
        {
          for (j = 0; j < APP_BUFLEN; j++)
          {
            if (REM[j] ==      1) report_factor(i, -1, P[j]);
            if (REM[j] == P[j]-1) report_factor(i,  1, P[j]);
          }
        }
      }
    }
  }
#endif
}

/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
   P is an array of len candidate primes, 0 <= len < APP_BUFLEN.
   The application should be prepared to checkpoint after returning from
   this function.
*/
void app_thread_fun1(int th, uint64_t *P, unsigned int len)
{
  uint64_t pad[APP_BUFLEN] __attribute__ ((aligned(16)));
  unsigned int i;

  if (len > 0)
  {
    for (i = 0; i < len; i++)
      pad[i] = P[i];
    for ( ; i < APP_BUFLEN; i++)
      pad[i] = P[i-1];

    app_thread_fun(th,pad);
  }
}

/* This function is called once in thread th, 0 <= th < num_threads, after
   the final call to app_thread_fun1(th, ...).
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
  if (input_filename == NULL)
    return 0;

  if (fscanf(fin,"factor_count=%u",&factor_count) != 1)
    return 0;

  return 1;
}

/* This function is called periodically with fout open for writing. The
   application can assume that the following conditions apply:

   Threads are blocked for the duration of this call, or have already
   exited. (And so app_thread_fini(th) may have been called already).

   app_thread_fun(th, ...) has not been called since the last call to
   app_thread_fun1(th, ...).

   All candidates before, and no candidates after the checkpoint have been
   passed to one of the functions app_thread_fun() or app_thread_fun1().
*/
void app_write_checkpoint(FILE *fout)
{
  fprintf(fout,"factor_count=%u\n",factor_count);

  if (output_filename != NULL)
  {
    FILE *file;
    unsigned int i, bits, count;

    if ((file = fopen(output_filename, "w")) == NULL)
    {
      fprintf(stderr,"Cannot open output file `%s'\n",output_filename);
      return;
    }

    if (mode == MODE_FACTORIAL)
    {
      fprintf(file,"ABC $a!+$b\n");
      bits = nmax-nmin+1;
      for (i = 0, count = 0; i < bits; i++)
      {
        if (minus_list[i/8] & (1 << i%8))
          fprintf(file,"%u -1\n",i+nmin), count++;
        if (plus_list[i/8] & (1 << i%8))
          fprintf(file,"%u +1\n",i+nmin), count++;
      }
    }
    else
    {
      fprintf(file,"ABC $a#+$b\n");
      bits = prime_count - prime_base;
      for (i = 0, count = 0; i < bits; i++)
      {
        if (minus_list[i/8] & (1 << i%8))
          fprintf(file,"%u -1\n",sieve_primes[prime_base+i]), count++;
        if (plus_list[i/8] & (1 << i%8))
          fprintf(file,"%u +1\n",sieve_primes[prime_base+i]), count++;
      }
    }

    fclose(file);

    if (count != remaining_terms)
    {
      fprintf(stderr,"internal error or hardware fault detected\n");
      exit(EXIT_FAILURE);
    }

    printf("Wrote %u term%s to output file `%s'\n",
           remaining_terms, (remaining_terms==1)? "":"s", output_filename);
  }
}

/* This function is called once after all threads have exited.
 */
void app_fini(void)
{
  printf("Found factors for %u term%s, %u remain%s\n",
         factor_count, (factor_count==1)? "":"s",
         remaining_terms, (remaining_terms==1)? "s":"");

#ifdef _WIN32
  DeleteCriticalSection(&factors_mutex);
#else
  pthread_mutex_destroy(&factors_mutex);
#endif

  free(plus_list);
  free(minus_list);
#if defined(__ppc__) || defined(__ppc64__)
  free(primeDouble);
#endif
}
