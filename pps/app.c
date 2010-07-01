/* ex: set softtabstop=2 shiftwidth=2 expandtab: */
/* app.c -- (C) Geoffrey Reynolds, April-August 2009.
 * With improvements by Ken Brazier August 2009-April 2010.

   Proth Prime Search sieve (for many K).

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
*/

#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <inttypes.h>
#include <getopt.h>
#include <ctype.h>
#ifdef _WIN32
#include <windows.h>
#else
#include <pthread.h>
#endif
//#ifndef __x86_64__  // Comment this to do benchmarking in 64-bit.
#ifdef __SSE2__
#define EMM
#include <emmintrin.h>
#ifdef __x86_64__
#include <time.h>
#endif
#endif
//#endif
#include "main.h"
#include "putil.h"
#include "app.h"
#ifdef __x86_64__
#include "app_thread_fun_x64.h"
#else
#include "app_thread_fun_nosse2.h"
#include "app_thread_fun_sse2.h"
#endif
#define INLINE static inline

#define FORMAT_NEWPGEN 1
#define FORMAT_ABCD 2

static uint64_t kmin = 0, kmax = 0;
//#ifdef EMM
static uint64_t xkmax[2] __attribute__((aligned(16)));
static int sse2_in_range = 0;
static int has_sse2 = 0;
//#endif
static uint64_t b0 = 0, b1 = 0;
static unsigned char **bitmap = NULL;
static const char *input_filename = NULL;
static const char *factors_filename = NULL;
static FILE *factors_file = NULL;
static unsigned int nmin = 0, nmax = 0;
static unsigned int nstart = 0, nstep = 0;
static unsigned int factor_count = 0;
static int file_format = FORMAT_ABCD;
static int print_factors = 1;
static int addsign = 1;

#ifdef __x86_64__
// Montgomery constants:
static uint64_t ld_r0;
static int ld_bbits;
#endif

// use_sse2: 
// 0: Use default algorithm
// 1: Use alternate SSE2 algorithm
// 2: (Default) Benchmark and find the best algorithm.
static int use_sse2 = 2;

#ifdef _WIN32
static CRITICAL_SECTION factors_mutex;
#else
static pthread_mutex_t factors_mutex;
#endif


#define cpuid(func,ax,bx,cx,dx)\
	__asm__ __volatile__ ("cpuid":\
	"=a" (ax), "=b" (bx), "=c" (cx), "=d" (dx) : "a" (func));

// True if CPU supports SSE2.
static int check_sse2(void) {
  int a,b,c,d;
  cpuid(1,a,b,c,d);
  return((d>>26)&1);
}

static void report_factor(uint64_t p, uint64_t k, unsigned int n, int c)
{
#ifdef _WIN32
  EnterCriticalSection(&factors_mutex);
#else
  pthread_mutex_lock(&factors_mutex);
#endif

  if (factors_file != NULL && fprintf(factors_file,"%"PRIu64" | %"PRIu64"*2^%u%+d\n",p,k,n,c) > 0)
  {
    if(print_factors) printf("%"PRIu64" | %"PRIu64"*2^%u%+d\n",p,k,n,c);
  }
  else fprintf(stderr, "%sUNSAVED: %"PRIu64" | %"PRIu64"*2^%u%+d\n",bmprefix(),p,k,n,c);
  factor_count++;

#ifdef _WIN32
  LeaveCriticalSection(&factors_mutex);
#else
  pthread_mutex_unlock(&factors_mutex);
#endif
}

// 1 if a number mod 15 is not divisible by 2 or 3.
//                             0  1  2  3  4  5  6  7  8  9 10 11 12 13 14
static const int prime15[] = { 0, 1, 1, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1 };

void test_factor(uint64_t p, uint64_t k, unsigned int n, int c)
{
  uint64_t b = k/2;

  if((k & 1) && n >= nmin && n < nmax && k >= kmin) { // k is odd.
    if (bitmap == NULL) {
      // Check that K*2^N+/-1 is not divisible by 3, 5, or 7, to minimize factors printed.
      // We do 3 and 5 at the same time (15 = 2^4-1), then 7 (=2^3-1).
      // (k*(1<<(n%2))+c)%3 == 0
      if(prime15[(unsigned int)(((k<<(n&3))+(uint64_t)c)%(uint64_t)15)] && 
          (unsigned int)(((k<<(n%3))+(uint64_t)c)%(uint64_t)7) != 0)
        report_factor(p,k,n,c);
    } else {
      if (bitmap[n-nmin][(unsigned int)((b-b0)/8)] & (1<<(b-b0)%8))
        report_factor(p,k,n,c);
    }
  }
}

/* Scan the input file to determine format and values for kmin,kmax,nmin,nmax.
 */
static FILE* scan_input_file(const char *fn)
{
  FILE *file;
  uint64_t k0, k1, k, p0;
  unsigned int n0, n1, d, n;
  int fileaddsign;
  char ch;

  if ((file = bfopen(fn,"r")) == NULL)
  {
    perror(fn);
    bexit(EXIT_FAILURE);
  }


  if (fscanf(file,"ABCD %"SCNu64"*2^$a%c1 [%u]",
             &k,&ch,&n) == 3)
  {
    file_format = FORMAT_ABCD;
    addsign = (ch=='+')?1:-1;
  }
  else if (fscanf(file,"%"SCNu64":P:%*c:2:%d",&p0,&fileaddsign) == 2 && (fileaddsign == 1 || fileaddsign == -1 || fileaddsign == 255 || fileaddsign == 257))
  {
    addsign = (int)((char)fileaddsign);
    file_format = FORMAT_NEWPGEN;
    if (fscanf(file," %"SCNu64" %u",&k,&n) != 2)
    {
      fprintf(stderr,"%sInvalid line 2 in input file `%s'\n",bmprefix(),fn);
      bexit(EXIT_FAILURE);
    }
  }
  else
  {
    fprintf(stderr,"%sInvalid header in input file `%s'\n",bmprefix(),fn);
    bexit(EXIT_FAILURE);
  }

  k0 = k1 = k;
  n0 = n1 = n;

  if (file_format == FORMAT_ABCD)
  {
    //while(getc(file) != '\n');
    printf("Scanning ABCD file...\n");
    while (1)
    {
      while(getc(file) != '\n');
      while(1) {
        char c = getc(file);
        if(!isdigit(c)) {
          ungetc(c, file);
          break;
        }
        d = c-'0';
        while(isdigit(c=getc(file))) {
          d *= 10;
          d += c-'0';
        }
        n += d;
        while(c != '\n') c=getc(file);
      }
      //while (fscanf(file," %u",&d) == 1)

      if (n1 < n)
        n1 = n;

      if (fscanf(file, " ABCD %"SCNu64"*2^$a%c1 [%u]",
                 &k,&ch,&n) == 3)
      {
#ifndef USE_BOINC
        if((((int)k)&15) == 1) printf("\rFound K=%"SCNu64"\r", k);
#endif
        fflush(stdout);
        if (k0 > k)
          k0 = k;
        if (k1 < k)
          k1 = k;

        if (n0 > n)
          n0 = n;
        if (n1 < n)
          n1 = n;
      }
      else
        break;
    }
  }
  else /* if (file_format == FORMAT_NEWPGEN) */
  {
    while (fscanf(file," %"SCNu64" %u",&k,&n) == 2)
    {
      if (k0 > k)
        k0 = k;
      if (k1 < k)
        k1 = k;

      if (n0 > n)
        n0 = n;
      if (n1 < n)
        n1 = n;
    }
  }

  if (ferror(file))
  {
    fprintf(stderr,"%sError reading input file `%s'\n",bmprefix(),fn);
    bexit(EXIT_FAILURE);
  }

  rewind(file);
  printf("Found K's from %"SCNu64" to %"SCNu64".\n", k0, k1);
  printf("Found N's from %u to %u.\n", n0, n1);

  //if (file_format == FORMAT_ABCD)
  //{
    //k0 = 6*k0+3;
    //k1 = 6*k1+3;
  //}

  if (kmin < k0)
    kmin = k0;
  if (kmax == 0 || kmax > k1)
    kmax = k1;

  if (nmin < n0)
    nmin = n0;
  if (nmax == 0 || nmax > n1)
    nmax = n1;
  return file;
}

static void read_newpgen_file(const char *fn, FILE* file)
{
  //FILE *file;
  uint64_t k, p0;
  unsigned int n, line, count;
  int fileaddsign;

  if(file == NULL) {
    if ((file = bfopen(fn,"r")) == NULL)
    {
      perror(fn);
      bexit(EXIT_FAILURE);
    }
  }

  if (fscanf(file," %"SCNu64":P:%*c:2:%d",&p0,&fileaddsign) != 2)
  {
    fprintf(stderr,"%sInvalid header in input file `%s'\n",bmprefix(),fn);
    bexit(EXIT_FAILURE);
  }

  line = 0;
  count = 0;
  while (fscanf(file," %"SCNu64" %u",&k,&n) == 2)
  {
    line++;
    if ((k&1) != 1)
    {
      fprintf(stderr,"%sInvalid line %u in input file `%s'\n",bmprefix(),line,fn);
      bexit(EXIT_FAILURE);
    }
    if (k >= kmin && k <= kmax && n >= nmin && n <= nmax)
    {
      uint64_t bit = k/2-b0;
      bitmap[n-nmin][(unsigned int)(bit/8)] |= (1 << bit%8);
      count++; /* TODO: Don't count duplicates */
    }
  }

  if (ferror(file))
  {
    fprintf(stderr,"%sError reading input file `%s'\n",bmprefix(),fn);
    bexit(EXIT_FAILURE);
  }

  //rewind(file);
  fclose(file);

  printf("Read %u terms from NewPGen format input file `%s'\n",count,fn);
}

static void read_abcd_file(const char *fn, FILE *file)
{
  //FILE *file;
  //char buf[80];
  uint64_t k;
  unsigned int n, count, d;

  if(file == NULL) {
    printf("Opening file %s\n", fn);
    if ((file = bfopen(fn,"r")) == NULL)
    {
      perror(fn);
      bexit(EXIT_FAILURE);
    }
  }
  if (fscanf(file, "ABCD %"SCNu64"*2^$a%*c1 [%u]",
        &k,&n) != 2)
  {
    fprintf(stderr,"%sInvalid header in input file `%s'\n",bmprefix(), fn);
    bexit(EXIT_FAILURE);
  }

  count = 0;
  while(getc(file) != '\n');
  printf("Reading ABCD file.\n");
  while (1)
  {
    uint64_t bit = (k-kmin)/2;
    unsigned int bo8 = (unsigned int)(bit/8);
    unsigned int bm8 = (unsigned int)(1 << bit%8);
    /*if(k < kmin || k > kmax || bit < 0 || bit > (kmax-kmin)/2) {
      printf("\n\nK error: K = %"SCNu64", which is outside %"SCNu64" - %"SCNu64"\n\n\n", k, kmin, kmax);
      bexit(EXIT_FAILURE);
    }*/
    if(n >= nmin) bitmap[n-nmin][bo8] |= bm8;
    count++;
    while(getc(file) != '\n');
    //while (fscanf(file," %u",&d) == 1)
    while(1)
    {
      char c = getc(file);
      if(!isdigit(c)) {
        ungetc(c, file);
        break;
      }
      d = c-'0';
      while(isdigit(c=getc(file))) {
        d *= 10;
        d += c-'0';
      }

      n += d;
      /*if(n > nmax) {
        printf("\n\nN error: N = %u, but nmax = %u\n\n\n", n, nmax);
        if(file == NULL) printf("\n\nError: File was closed!\n");
        bexit(EXIT_FAILURE);
      }*/
      if(n >= nmin && n <= nmax) bitmap[n-nmin][bo8] |= bm8;
      count++;
      while(c != '\n') c=getc(file);
    }
#ifndef USE_BOINC
    if((((int)k)&15) == 1) printf("\rRead K=%"SCNu64"\r", k);
#endif
    fflush(stdout);

    if (fscanf(file, "ABCD %"SCNu64"*2^$a%*c1 [%u]",
          &k,&n) != 2) {
      break;
    }
  }

  if (ferror(file))
  {
    printf("\nError reading input file `%s'\n",fn);
    bexit(EXIT_FAILURE);
  }
  //printf("\n\nDone reading ABCD file!\n");

  fclose(file);

  printf("Read %u terms from ABCD format input file `%s'\n",count,fn);
}

/* This function is called once before anything is done. It should at least
   print the name of the application. It can also assign default option
   values which will be overridden in the configuration file or on the
   command line.
*/
void app_banner(void)
{
  printf("ppsieve version " APP_VERSION " (testing)\n");
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
    case 'k':
      status = parse_uint64(&kmin,arg,1,(UINT64_C(1)<<62)-1);
      break;

    case 'K':
      status = parse_uint64(&kmax,arg,1,(UINT64_C(1)<<62)-1);
      break;

    case 'n':
      status = parse_uint(&nmin,arg,1,(1U<<31)-1);
      break;

    case 'N':
      status = parse_uint(&nmax,arg,1,(1U<<31)-1);
      break;

    case 'i':
      input_filename = (source == NULL)? arg : xstrdup(arg);
      break;

    case 'f':
      factors_filename = (source == NULL)? arg : xstrdup(arg);
      break;

    case 's':
    case 'a':
      if(arg[0] == 'y' || arg[0] == 'Y') use_sse2 = 1;
      else if(arg[0] == 'n' || arg[0] == 'N') use_sse2 = 0;
      break;
      
    case 'R':
      addsign = -1;
      break;
    //case 'q':
      //print_factors = 0;
      //break;
  }

  return status;
}

void app_help(void)
{
  printf("-k --kmin=K0\n");
  printf("-K --kmax=K1       Sieve for primes k*2^n+/-1 with K0 <= k <= K1\n");
  printf("-n --nmin=N0\n");
  printf("-N --nmax=N1       Sieve for primes k*2^n+/-1 with N0 <= n <= N1\n");
  printf("-i --input=FILE    Read initial sieve from FILE\n");
  printf("-f --factors=FILE  Write factors to FILE (default `%s')\n",
         FACTORS_FILENAME_DEFAULT);
  printf("-R --riesel        Test Riesel numbers instead of Proth numbers.\n");
  printf("-a --alt=yes|no    Force setting of alt. algorithm (64-bit/SSE2)\n");
}

// find the log base 2 of a number.  Need not be fast; only done twice.
int lg2(uint64_t v) {
	int r = 0; // r will be lg(v)

	while (v >>= 1) r++;
	return r;
}

/* This function is called once before any threads are started.
 */
void app_init(void)
{
  FILE *file = NULL;
  unsigned int i;

  print_factors = (quiet_opt)?0:1;
  if (input_filename == NULL && (kmin == 0 || kmax == 0 || nmax == 0))
  {
    bmsg("Please specify an input file or all of kmin, kmax, and nmax\n");
    bexit(EXIT_FAILURE);
  }

  if (input_filename != NULL
      && (kmin == 0 || kmax == 0 || nmin == 0 || nmax == 0))
    file = scan_input_file(input_filename);

  if (kmin > kmax)
  {
    bmsg("kmin <= kmax is required\n");
    bexit(EXIT_FAILURE);
  }

  if (kmax >= pmin)
  {
    bmsg("kmax < pmin is required\n");
    bexit(EXIT_FAILURE);
  }

  if (kmax-kmin >= (UINT64_C(3)<<36))
  {
    bmsg("kmax-kmin < 3*2^36 is required\n");
    bexit(EXIT_FAILURE);
  }

  if (nmin == 0)
  {
    // k*2^n is prime if k*2^n < p^2
    // 2^n < p^2/k
    // We can calculate nmin = at least 2*log2(pmin)-log2(kmax),
    // because any number smaller than this, divisible by this prime,
    // would also have been divisible by a smaller prime.
    nmin = 2*lg2(pmin)-lg2(kmax)-1;

    //bmsg("Please specify a value for nmin\n");
    //bexit(EXIT_FAILURE);
  }

  if (nmax == 0)
    nmax = nmin;

  if (nmin > nmax)
  {
    bmsg("nmin <= nmax is required\n");
    bexit(EXIT_FAILURE);
  }

  b0 = kmin/2;
  b1 = kmax/2;
  kmin = b0*2+1;
  kmax = b1*2+1;
  has_sse2 = check_sse2();
  xkmax[0] = kmax+1;
  // The range-restricted SSE2 algorithm is limited to
  // kmax < P < 2^32*kmax, and kmax < 2^32
  // But we can increase xkmax if necessary.
  while(pmax >= xkmax[0]*(UINT64_C(1)<<32)) xkmax[0] *= 2;
  xkmax[1] = xkmax[0];
  if(has_sse2 && xkmax[0] < (UINT64_C(1)<<32) &&
      pmax < xkmax[0]*(UINT64_C(1)<<32) &&
      use_sse2 != 0) {
#ifdef __x86_64__
    if(use_sse2 < 2) sse2_in_range = 1;
    else {
      // There's a chance to use the alternate algorithm, so benchmark which is faster.
      clock_t start, multime, bsftime;
      uint64_t mulval0 = 7ul;//, mulval1 = 47ul; // Odd, so there are always low bits.
      uint64_t a = 7ul;//, b = 47ul;
      unsigned int c = 0;

      printf("Algorithm not specified, starting benchmark...\n");
      start = clock();

      for(i=0; i < 500000000; ++i) {
        a *= mulval0;
      }

      multime = clock();
      multime -= start;

      start = clock();

      // Increased 5% to favor alternate algorithm.
      for(i=0; i < 525000000; ++i) {
        c += __builtin_ctzll((uint64_t)i);
      }

      bsftime = clock();
      bsftime -= start;

      printf("bsf takes %lu; mul takes %lu; ", bsftime, multime);
      if(((unsigned int)a != c) && bsftime < multime) {
        sse2_in_range = 0;
      } else {
        sse2_in_range = 1;
      }
    }
#else
    sse2_in_range = 1;
#endif
  }
  if(sse2_in_range) {
    printf("using alternate algorithm.\n");
  } else {
    if(has_sse2) {
      printf("using standard algorithm.\n");
    } else {
      printf("using 32-bit only algorithm.\n");
    }
  }

  for (nstep = 1; (kmax << nstep) < pmin; nstep++)
    ;
  if (nstep > (nmax-nmin+1))
    nstep = (nmax-nmin+1);

  // Select starting point depending on which algorithm will be used.
  if (nstep <= MIN_MULMOD_NSTEP)
    nstart = nmin;
  else
    nstart = nmin + (((nmax-nmin)/nstep)*nstep);

  printf("nstart=%u, nstep=%u\n",nstart,nstep);

#ifdef __x86_64__
  // Prepare Montgomery constants:
  ld_r0 = 0;  // Default, turns off Montgomery math.
  ld_bbits = lg2(nstart);
  //assert(d_r0 <= 32);
  if(ld_bbits >= 6) {
    // r = 2^-i * 2^64 (mod N), something that can be done in a uint64_t!
    // If i is large (and it should be at least >= 32), there's a very good chance no mod is needed!
    ld_r0 = ((uint64_t)1) << (64-(nstart >> (ld_bbits-5)));
    ld_bbits = ld_bbits-6;

    // If P is too small, a mod would be needed, so abort Montgomery math.
    if(ld_r0 >= pmin) ld_r0 = 0;
  }
#endif

  // Allocate and fill bitmap.
  if (input_filename != NULL)
  {
    bitmap = xmalloc((nmax-nmin+1)*sizeof(unsigned char *));
    for (i = nmin; i <= nmax; i++)
    {
      bitmap[i-nmin] = xmalloc((unsigned int)((b1-b0+8)/8));
      memset(bitmap[i-nmin],0,(unsigned int)((b1-b0+8)/8));
    }
    if (file_format == FORMAT_ABCD)
      read_abcd_file(input_filename, file);
    else /* if (file_format == FORMAT_NEWPGEN) */
      read_newpgen_file(input_filename, file);
  }

  if (factors_filename == NULL)
    factors_filename = FACTORS_FILENAME_DEFAULT;
  if ((factors_file = bfopen(factors_filename,"a")) == NULL)
  {
    fprintf(stderr,"%sCannot open factors file `%s'\n",bmprefix(),factors_filename);
    bexit(EXIT_FAILURE);
  }

#ifdef _WIN32
  InitializeCriticalSection(&factors_mutex);
#else
  pthread_mutex_init(&factors_mutex,NULL);
#endif

  printf("ppsieve initialized: %"PRIu64" <= k <= %"PRIu64", %u <= n <= %u\n",
         kmin,kmax,nmin,nmax);
  fflush(stdout);
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

/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
   P is an array of APP_BUFLEN candidate primes.
*/
void app_thread_fun(int th, uint64_t *__attribute__((aligned(16))) P)
{
#ifdef __x86_64__
  app_thread_fun_x64(th, P, kmin, kmax, addsign, nmin, nmax, nstart, nstep, sse2_in_range, ld_r0, ld_bbits);
#else
  if(has_sse2)  app_thread_fun_sse2(th, P, kmin, kmax, addsign, nmin, nmax, nstart, nstep, sse2_in_range, xkmax);
  else app_thread_fun_nosse2(th, P, kmin, kmax, addsign, nmin, nmax, nstart, nstep);
#endif
}

/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
   P is an array of len candidate primes, 0 <= len < APP_PRIMES_BUFLEN.
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
  unsigned int n0, n1;

  if (fscanf(fin,"nmin=%u,nmax=%u,factor_count=%u",&n0,&n1,&factor_count) != 3)
    return 0;

  if (n0 != nmin || n1 != nmax)
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
  fflush(factors_file);
  fprintf(fout,"nmin=%u,nmax=%u,factor_count=%u\n",nmin,nmax,factor_count);
}

/* This function is called once after all threads have exited.
 */
void app_fini(void)
{
  unsigned int i;

  fclose(factors_file);
  printf("Found %u factor%s\n",factor_count,(factor_count==1)? "":"s");

#ifdef _WIN32
  DeleteCriticalSection(&factors_mutex);
#else
  pthread_mutex_destroy(&factors_mutex);
#endif

  if (bitmap != NULL)
  {
    for (i = nmin; i <= nmax; i++)
      free(bitmap[i-nmin]);
    free(bitmap);
    bitmap = NULL;
  }
}
