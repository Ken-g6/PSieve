/* ex: set softtabstop=2 shiftwidth=2 expandtab: */
/* app.c -- (C) Geoffrey Reynolds, April 2009.

   Twin Prime Search sieve.


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
#ifdef _WIN32
#include <windows.h>
#else
#include <pthread.h>
#endif
/*#ifdef __SSE2__
#define USEDOUBLE // Use Double SSE math, instead of long double.
#include <emmintrin.h>
#endif*/
#ifndef __x86_64__
#ifdef __SSE2__
#define EMM
#include <emmintrin.h>
#endif
#endif
#include "main.h"
#include "util.h"
#include "app.h"
#define INLINE static inline

static uint64_t kmin = 0, kmax = 0;
#ifdef EMM
static uint64_t xkmax[2] __attribute__((aligned(16)));
#endif
static uint64_t b0 = 0, b1 = 0;
static unsigned char **bitmap = NULL;
static const char *input_filename = NULL;
static const char *factors_filename = NULL;
static FILE *factors_file = NULL;
static unsigned int nmin = 0, nmax = 0;
static unsigned int nstart = 0, nstep = 0;
static unsigned int factor_count = 0;
static int file_format = 0;

#ifdef _WIN32
static CRITICAL_SECTION factors_mutex;
#else
static pthread_mutex_t factors_mutex;
#endif

#define FORMAT_NEWPGEN 1
#define FORMAT_ABCD 2

static void report_factor(uint64_t p, uint64_t k, unsigned int n, int c)
{
  assert(factors_file != NULL);

#ifdef _WIN32
  EnterCriticalSection(&factors_mutex);
#else
  pthread_mutex_lock(&factors_mutex);
#endif

  fprintf(factors_file,"%"PRIu64" | %"PRIu64"*2^%u%+d\n",p,k,n,c);
  printf("%"PRIu64" | %"PRIu64"*2^%u%+d\n",p,k,n,c);
  factor_count++;

#ifdef _WIN32
  LeaveCriticalSection(&factors_mutex);
#else
  pthread_mutex_unlock(&factors_mutex);
#endif
}

static void __attribute__((noinline))
test_factor(uint64_t p, uint64_t k, unsigned int n, int c)
{
  uint64_t b = k/6;

  if (k == 6*b+3) /* k = 3 (mod 6) */
    if (bitmap == NULL
        || (bitmap[n-nmin][(unsigned int)((b-b0)/8)] & (1<<(b-b0)%8)))
      report_factor(p,k,n,c);
}

/* Scan the input file to determine format and values for kmin,kmax,nmin,nmax.
 */
static void scan_input_file(const char *fn)
{
  FILE *file;
  uint64_t k0, k1, k, d, p0;
  unsigned int n0, n1, n, m;
  char ch;

  if ((file = fopen(fn,"r")) == NULL)
  {
    perror(fn);
    exit(EXIT_FAILURE);
  }


  if (fscanf(file,"ABCD (6*$a+3)*2^%u+1 & (6*$a+3)*2^%u-1 [%"SCNu64"]",
             &m,&n,&k) == 3 && m == n)
    file_format = FORMAT_ABCD;
  else if (fscanf(file,"%"SCNu64":T:%*c:2:%c",&p0,&ch) == 2 && ch == '3')
  {
    file_format = FORMAT_NEWPGEN;
    if (fscanf(file," %"SCNu64" %u",&k,&n) != 2)
    {
      fprintf(stderr,"Invalid line 2 in input file `%s'\n",fn);
      exit(EXIT_FAILURE);
    }
  }
  else
  {
    fprintf(stderr,"Invalid header in input file `%s'\n",fn);
    exit(EXIT_FAILURE);
  }

  k0 = k1 = k;
  n0 = n1 = n;

  if (file_format == FORMAT_ABCD)
  {
    while (1)
    {
      while (fscanf(file," %"SCNu64,&d) == 1)
        k += d;

      if (k1 < k)
        k1 = k;

      if (fscanf(file," ABCD (6*$a+3)*2^%u+1 & (6*$a+3)*2^%u-1 [%"SCNu64"]",
                 &m,&n,&k) == 3 && m == n)
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
    fprintf(stderr,"Error reading input file `%s'\n",fn);
    exit(EXIT_FAILURE);
  }

  fclose(file);

  if (file_format == FORMAT_ABCD)
  {
    k0 = 6*k0+3;
    k1 = 6*k1+3;
  }

  if (kmin < k0)
    kmin = k0;
  if (kmax == 0 || kmax > k1)
    kmax = k1;

  if (nmin < n0)
    nmin = n0;
  if (nmax == 0 || nmax > n1)
    nmax = n1;
}

static void read_newpgen_file(const char *fn)
{
  FILE *file;
  uint64_t k, p0;
  unsigned int n, line, count;
  char ch;

  if ((file = fopen(fn,"r")) == NULL)
  {
    perror(fn);
    exit(EXIT_FAILURE);
  }

  if (fscanf(file," %"SCNu64":T:%*c:2:%c",&p0,&ch) != 2 || ch != '3')
  {
    fprintf(stderr,"Invalid header in input file `%s'\n",fn);
    exit(EXIT_FAILURE);
  }

  line = 0;
  count = 0;
  while (fscanf(file," %"SCNu64" %u",&k,&n) == 2)
  {
    line++;
    if (k%6 != 3)
    {
      fprintf(stderr,"Invalid line %u in input file `%s'\n",line,fn);
      exit(EXIT_FAILURE);
    }
    if (k >= kmin && k <= kmax && n >= nmin && n <= nmax)
    {
      uint64_t bit = k/6-b0;
      bitmap[n-nmin][(unsigned int)(bit/8)] |= (1 << bit%8);
      count++; /* TODO: Don't count duplicates */
    }
  }

  if (ferror(file))
  {
    fprintf(stderr,"Error reading input file `%s'\n",fn);
    exit(EXIT_FAILURE);
  }

  fclose(file);

  printf("Read %u terms from NewPGen format input file `%s'\n",count,fn);
}

static void read_abcd_file(const char *fn)
{
  FILE *file;
  uint64_t k, d;
  unsigned int n, m, count;

  if ((file = fopen(fn,"r")) == NULL)
  {
    perror(fn);
    exit(EXIT_FAILURE);
  }

  if (fscanf(file,"ABCD (6*$a+3)*2^%u+1 & (6*$a+3)*2^%u-1 [%"SCNu64"]",
             &m,&n,&k) != 3 || m != n)
  {
    fprintf(stderr,"Invalid header in input file `%s'\n",fn);
    exit(EXIT_FAILURE);
  }

  count = 0;
  while (1)
  {
    uint64_t bit = k-b0;
    bitmap[n-nmin][(unsigned int)(bit/8)] |= (1 << bit%8);
    count++;

    while (fscanf(file," %"SCNu64,&d) == 1)
    {
      k += d;
      {
        bit = k-b0;
        bitmap[n-nmin][(unsigned int)(bit/8)] |= (1 << bit%8);
        count++;
      }
    }

    if (fscanf(file," ABCD (6*$a+3)*2^%u+1 & (6*$a+3)*2^%u-1 [%"SCNu64"]",
               &m,&n,&k) != 3 || m != n)
      break;
  }

  if (ferror(file))
  {
    fprintf(stderr,"Error reading input file `%s'\n",fn);
    exit(EXIT_FAILURE);
  }

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
  printf("tpsieve version " APP_VERSION " (testing)\n");
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
}

/* This function is called once before any threads are started.
 */
void app_init(void)
{
  unsigned int i;

  if (input_filename == NULL && (kmin == 0 || kmax == 0))
  {
    fprintf(stderr,"Please specify an input file or both of kmin,kmax\n");
    exit(EXIT_FAILURE);
  }

  if (input_filename != NULL
      && (kmin == 0 || kmax == 0 || nmin == 0 || nmax == 0))
    scan_input_file(input_filename);

  if (kmin > kmax)
  {
    fprintf(stderr,"kmin <= kmax is required\n");
    exit(EXIT_FAILURE);
  }

  if (kmax >= pmin)
  {
    fprintf(stderr,"kmax < pmin is required\n");
    exit(EXIT_FAILURE);
  }

  if (kmax-kmin >= (UINT64_C(3)<<36))
  {
    fprintf(stderr,"kmax-kmin < 3*2^36 is required\n");
    exit(EXIT_FAILURE);
  }

  if (nmin == 0)
  {
    fprintf(stderr,"Please specify a value for nmin\n");
    exit(EXIT_FAILURE);
  }

  if (nmax == 0)
    nmax = nmin;

  if (nmin > nmax)
  {
    fprintf(stderr,"nmin <= nmax is required\n");
    exit(EXIT_FAILURE);
  }

  b0 = kmin/6;
  b1 = kmax/6;
  kmin = b0*6+3;
  kmax = b1*6+3;
#ifdef EMM
  xkmax[0] = kmax+1;
  xkmax[1] = kmax+1;
#endif

  for (nstep = 1; (kmax << nstep) < pmin; nstep++)
    ;
  if (nstep > (nmax-nmin+1))
    nstep = (nmax-nmin+1);

  if (nstep <= 1)
    nstart = nmin;
  else
    nstart = nmin + (((nmax-nmin)/nstep)*nstep);

  printf("nstart=%u, nstep=%u\n",nstart,nstep);

  if (input_filename != NULL)
  {
    bitmap = xmalloc((nmax-nmin+1)*sizeof(unsigned char *));
    for (i = nmin; i <= nmax; i++)
    {
      bitmap[i-nmin] = xmalloc((unsigned int)((b1-b0+8)/8));
      memset(bitmap[i-nmin],0,(unsigned int)((b1-b0+8)/8));
    }
    if (file_format == FORMAT_ABCD)
      read_abcd_file(input_filename);
    else /* if (file_format == FORMAT_NEWPGEN) */
      read_newpgen_file(input_filename);
  }

  if (factors_filename == NULL)
    factors_filename = FACTORS_FILENAME_DEFAULT;
  if ((factors_file = fopen(factors_filename,"a")) == NULL)
  {
    fprintf(stderr,"Cannot open factors file `%s'\n",factors_filename);
    exit(EXIT_FAILURE);
  }

#ifdef _WIN32
  InitializeCriticalSection(&factors_mutex);
#else
  pthread_mutex_init(&factors_mutex,NULL);
#endif

  printf("tpsieve initialized: %"PRIu64" <= k <= %"PRIu64", %u <= n <= %u\n",
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

// REDC Montgomery math section.

#ifdef __x86_64__
#ifndef NDEBUG
INLINE uint64_t 
longmod (uint64_t a, uint64_t b, const uint64_t m)
{
  //ASSERT (a < m);
  __asm__
  ( "divq %2"
    : "+d" (a), /* Put "a" in %rdx, will also get result of mod */
      "+a" (b)  /* Put "b" in %rax, will also be written to 
                   (quotient, which we don't need) */
    : "rm" (m)  /* Modulus can be in a register or memory location */
    : "cc"      /* Flags are clobbered */
  );
  return a;
}
#endif

// Same as mod_REDC, but a == 1, skips another multiply.
INLINE uint64_t
onemod_REDC (const uint64_t N, const uint64_t Ns)
{
  uint64_t r;
  /* Compute T=a*b; m = (T*Ns)%2^64; T += m*N; if (T>N) T-= N; */
  __asm__
    ( /*"mulq %%rax\n\t"*/           // T = 1*a       
      /*"imulq %[Ns], %%rax\n\t"*/  // imul is done in mod_REDC if necessary.
      "xorq %%rcx,%%rcx\n\t"  // rcx = Th = 0      Cycle 1
      "cmpq $1,%%rax \n\t"      // if rax != 0, increase rcx   Cycle 1
      "sbbq $-1,%%rcx\n\t"    //        Cycle 2-3
      "mulq %[N]\n\t"           // rdx:rax = m * N       Cycle 1?-7
      "lea (%%rcx,%%rdx,1), %[r]\n\t" // compute (rdx + rcx) mod N  Cycle 8
      "subq %[N], %%rcx\n\t"  //        Cycle 4?
      "addq %%rdx, %%rcx\n\t"  //        Cycle 8?
      "cmovcq %%rcx, %[r]\n\t"  //        Cycle 9?
      : [r] "=r" (r)
      : "a" (Ns), [N] "rm" (N)
      : "cc", "%rcx", "%rdx"
    );

  /*
  // Debug doesn't work when mod_REDC calls this function with Ns = the real Ns * a.
#ifndef NDEBUG
  if (longmod (r, 0, N) != mulmod(1, 1, N))
  {
    fprintf (stderr, "Error, onemod_redc(%lu,%lu) = %lu\n", 1ul, N, r);
    abort();
  }
#endif
  */

  return r;
}

// Same as mulmod_REDC, but b == 1, skips a 64x64=128 bit multiply.
INLINE uint64_t
mod_REDC (const uint64_t a,
             const uint64_t N, const uint64_t Ns)
{
  const uint64_t r = onemod_REDC(N, Ns*a);

#ifndef NDEBUG
  if (longmod (r, 0, N) != a%N)
  {
    fprintf (stderr, "Error, redc(%lu,%lu,%lu) = %lu\n", a, N, Ns, r);
    abort();
  }
#endif

  return r;
}
#endif

/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
   P is an array of APP_BUFLEN candidate primes.
*/
void app_thread_fun(int th, uint64_t *__attribute__((aligned(16))) P)
{
  uint64_t K[APP_BUFLEN] __attribute__((aligned(16)));
  uint64_t T[APP_BUFLEN] __attribute__((aligned(16)));
#if (APP_BUFLEN >= 7)
  long double INV[APP_BUFLEN-6];
#endif
#ifdef EMM
  static const uint64_t xones[2] __attribute__((aligned(16))) = {1ul, 1ul};
  __m128i mones = _mm_load_si128((__m128i*)xones);
#endif
#ifdef __x86_64__
  uint64_t x;
  unsigned int nbits, t;
#else
  unsigned int x;
#endif
  unsigned int i, n;

  n = nstart;

#if (APP_BUFLEN <= 6)
  for (i = 0; i < APP_BUFLEN; i++)
  {
    asm volatile ("fildll %0\n\t"
                  "fld1\n\t"
                  "fdivp"
                  : : "m" (P[(APP_BUFLEN-1)-i]) );
#ifndef __x86_64__
#ifndef __SSE2__
    K[i] = (P[i]+1)/2; /* K[i] <-- 2^{-1} mod P[i] */
#endif
#endif
  }
#else
  for (i = 0; i < 6; i++)
    asm volatile ("fildll %0\n\t"
                  "fld1\n\t"
                  "fdivp"
                  : : "m" (P[5-i]) );

  for ( ; i < APP_BUFLEN; i++)
    asm volatile ("fildll %1\n\t"
                  "fld1\n\t"
                  "fdivp\n\t"
                  "fstpt %0"
                  : "=m" (INV[i-6]) : "m" (P[i]) );

#ifndef __x86_64__
#ifndef __SSE2__
  for (i = 0; i < APP_BUFLEN; i++)
    K[i] = (P[i]+1)/2; /* K[i] <-- 2^{-1} mod P[i] */
#endif
#endif
#endif

#ifdef __x86_64__
  nbits = 31 - __builtin_clz(n);
  // Get the first 6 bits of b==t.  (Requires b >= 128.)
  t = 64-(n >> (nbits-5));
  nbits -= 6;

  // We assume that P[0] is the smallest of the N's.
  x = P[0];
  // if t is very small, one might be able to do the first mulmod here.
  if(t < 32) {
    // Square, but don't do the Montgomery step yet.
    x = 1ul << (t+t);
    // Call this case x*(x/2).  Still no Montgomery step yet.
    if(n & (1ul<<nbits)) x >>= 1;
  }
  if(x < P[0]) {
    // Work through the first 7 bits of b with Montgomery math.
    nbits--;
    for(i=0; i < APP_BUFLEN; i+=2) {
      register uint64_t r1, r2;
      register unsigned int in1 = (unsigned int)P[i], in2 = (unsigned int) P[i+1];

      //fprintf(stderr, "CASE 1\n");

      /* Suggestion from PLM: initing the inverse to (3*n) XOR 2 gives the
         correct inverse modulo 32, then 3 (for 32 bit) or 4 (for 64 bit) 
         Newton iterations are enough. */
      r1 = (3UL * P[i]) ^ 2UL;
      r2 = (3UL * P[i+1]) ^ 2UL;
      /* Newton iteration */
      r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
      r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
      r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
      r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
      r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
      r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
      r1 += r1 - r1 * r1 * P[i];
      r2 += r2 - r2 * r2 * P[i+1];
      // Here we do the Montgomery step, then leave Montgomery math with another.
      K[i] = mod_REDC(mod_REDC(x, P[i], -r1), P[i], -r1);
      K[i+1] = mod_REDC(mod_REDC(x, P[i+1], -r2), P[i+1], -r2);
    }
  } else {
    // Work through the first 6 bits of b with Montgomery math.
    // This is 2^-(6 bits of n) * 2^64
    x = 1ul << t;
    // If i is small (and it should be at least <= 32), there's a very good chance no mod is needed!
    if(x >= P[0]) {
      // Mod required - Montgomery math can't handle numbers >= P.
      for(i=0; i < APP_BUFLEN; i+=2) {
        register uint64_t r1, r2;
        register unsigned int in1 = (unsigned int)P[i], in2 = (unsigned int) P[i+1];

        /* Suggestion from PLM: initing the inverse to (3*n) XOR 2 gives the
           correct inverse modulo 32, then 3 (for 32 bit) or 4 (for 64 bit) 
           Newton iterations are enough. */
        r1 = (3UL * P[i]) ^ 2UL;
        r2 = (3UL * P[i+1]) ^ 2UL;
        /* Newton iteration */
        r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
        r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
        r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
        r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
        r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
        r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
        r1 += r1 - r1 * r1 * P[i];
        r2 += r2 - r2 * r2 * P[i+1];
        x = 1ul << t;
        x %= P[i];
        K[i] = mod_REDC(x, P[i], -r1);
        x = 1ul << t;
        x %= P[i+1];
        K[i+1] = mod_REDC(x, P[i+1], -r2);
      }
    } else {
      // No mod required.
      for(i=0; i < APP_BUFLEN; i+=2) {
        register uint64_t r1, r2;
        register unsigned int in1 = (unsigned int)P[i], in2 = (unsigned int) P[i+1];

        /* Suggestion from PLM: initing the inverse to (3*n) XOR 2 gives the
           correct inverse modulo 32, then 3 (for 32 bit) or 4 (for 64 bit) 
           Newton iterations are enough. */
        r1 = (3UL * P[i]) ^ 2UL;
        r2 = (3UL * P[i+1]) ^ 2UL;
        /* Newton iteration */
        r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
        r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
        r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
        r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
        r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
        r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
        r1 += r1 - r1 * r1 * P[i];
        r2 += r2 - r2 * r2 * P[i+1];
        K[i] = mod_REDC(x, P[i], -r1);
        K[i+1] = mod_REDC(x, P[i+1], -r2);
      }
    }
  }
  x = 1ul << (nbits+1);
#else
#ifdef __SSE2__
  x = 1U << (30 - __builtin_clz(n));
  {
    // Load the P's into SSE2 registers.
    __m128i mp0 = _mm_load_si128((__m128i*)(&P[0]));
    __m128i mp1 = _mm_load_si128((__m128i*)(&P[2]));
    __m128i mp2 = _mm_load_si128((__m128i*)(&P[4]));
    __m128i mtemp, mk;

    // The loop is unrolled, since each P pair is in a different register.
    // The first square is just 2^-1*2^-1 = (2^-1)/2.
    // So do that without a mulmod.
    // The first bit should be checked, too.
    if (n & x) {
      //k0 = (p0+1)/2
      mk = _mm_add_epi64(mp0, mones);
      mk = _mm_srli_epi64(mk, 1);
      for(i=0; i < 2; ++i) {
        //k0 += (k0 % 2)?p0:0;
        mtemp = _mm_and_si128(mk, mones);	// (mk % 2)
        mtemp = _mm_sub_epi64(mtemp, mones);	// 1 goes to 0; 0 goes to FFFFFFFFFFFFFFFF.
        mtemp = _mm_andnot_si128(mtemp, mp0);	// mp if mk%2 == 1; 0 if mk%2 == 0.
        mk = _mm_add_epi64(mk, mtemp);		// mk += the result.
        //k0 /= 2;
        mk = _mm_srli_epi64(mk, 1);
      }
      _mm_store_si128((__m128i*)(&K[0]), mk);

      //k0 = (p0+1)/2
      mk = _mm_add_epi64(mp1, mones);
      mk = _mm_srli_epi64(mk, 1);
      for(i=0; i < 2; ++i) {
        //k0 += (k0 % 2)?p0:0;
        mtemp = _mm_and_si128(mk, mones);	// (mk % 2)
        mtemp = _mm_sub_epi64(mtemp, mones);	// 1 goes to 0; 0 goes to FFFFFFFFFFFFFFFF.
        mtemp = _mm_andnot_si128(mtemp, mp1);	// mp if mk%2 == 1; 0 if mk%2 == 0.
        mk = _mm_add_epi64(mk, mtemp);		// mk += the result.
        //k0 /= 2;
        mk = _mm_srli_epi64(mk, 1);
      }
      _mm_store_si128((__m128i*)(&K[2]), mk);

      //k0 = (p0+1)/2
      mk = _mm_add_epi64(mp2, mones);
      mk = _mm_srli_epi64(mk, 1);
      for(i=0; i < 2; ++i) {
        //k0 += (k0 % 2)?p0:0;
        mtemp = _mm_and_si128(mk, mones);	// (mk % 2)
        mtemp = _mm_sub_epi64(mtemp, mones);	// 1 goes to 0; 0 goes to FFFFFFFFFFFFFFFF.
        mtemp = _mm_andnot_si128(mtemp, mp2);	// mp if mk%2 == 1; 0 if mk%2 == 0.
        mk = _mm_add_epi64(mk, mtemp);		// mk += the result.
        //k0 /= 2;
        mk = _mm_srli_epi64(mk, 1);
      }
      _mm_store_si128((__m128i*)(&K[4]), mk);
    } else {
      // Same thing, but only divides by 2 twice.
      //k0 = (p0+1)/2
      mk = _mm_add_epi64(mp0, mones);
      mk = _mm_srli_epi64(mk, 1);
      //k0 += (k0 % 2)?p0:0;
      mtemp = _mm_and_si128(mk, mones);		// (mk % 2)
      mtemp = _mm_sub_epi64(mtemp, mones);	// 1 goes to 0; 0 goes to FFFFFFFFFFFFFFFF.
      mtemp = _mm_andnot_si128(mtemp, mp0);	// mp if mk%2 == 1; 0 if mk%2 == 0.
      mk = _mm_add_epi64(mk, mtemp);		// mk += the result.
      //k0 /= 2;
      mk = _mm_srli_epi64(mk, 1);
      _mm_store_si128((__m128i*)(&K[0]), mk);

      //k0 = (p0+1)/2
      mk = _mm_add_epi64(mp1, mones);
      mk = _mm_srli_epi64(mk, 1);
      //k0 += (k0 % 2)?p0:0;
      mtemp = _mm_and_si128(mk, mones);		// (mk % 2)
      mtemp = _mm_sub_epi64(mtemp, mones);	// 1 goes to 0; 0 goes to FFFFFFFFFFFFFFFF.
      mtemp = _mm_andnot_si128(mtemp, mp1);	// mp if mk%2 == 1; 0 if mk%2 == 0.
      mk = _mm_add_epi64(mk, mtemp);		// mk += the result.
      //k0 /= 2;
      mk = _mm_srli_epi64(mk, 1);
      _mm_store_si128((__m128i*)(&K[2]), mk);

      //k0 = (p0+1)/2
      mk = _mm_add_epi64(mp2, mones);
      mk = _mm_srli_epi64(mk, 1);
      //k0 += (k0 % 2)?p0:0;
      mtemp = _mm_and_si128(mk, mones);		// (mk % 2)
      mtemp = _mm_sub_epi64(mtemp, mones);	// 1 goes to 0; 0 goes to FFFFFFFFFFFFFFFF.
      mtemp = _mm_andnot_si128(mtemp, mp2);	// mp if mk%2 == 1; 0 if mk%2 == 0.
      mk = _mm_add_epi64(mk, mtemp);		// mk += the result.
      //k0 /= 2;
      mk = _mm_srli_epi64(mk, 1);
      _mm_store_si128((__m128i*)(&K[4]), mk);
    }
  }   // Discard the cached P values in the SSE2 registers.
#else
  x = 1U << (31 - __builtin_clz(n));
  /*
  // The first square is just 2^-1*2^-1 = (2^-1)/2.
  // So do that without a mulmod.

  for (i = 0; i < APP_BUFLEN; i++)
    // This should force use of the CMOV instruction.
    // It's faster than a compare when K[i]%2 is random.
    K[i] += (((unsigned int)K[i]) & 1)?P[i]:0;

  for (i = 0; i < APP_BUFLEN; i++)
    K[i] /= 2;
 
  // The first bit should be checked, too.
  if (n & x) {
    for (i = 0; i < APP_BUFLEN; i++)
      // This should force use of the CMOV instruction.
      // It's faster than a compare when K[i]%2 is random.
      K[i] += (((unsigned int)K[i]) & 1)?P[i]:0;
    for (i = 0; i < APP_BUFLEN; i++)
      K[i] /= 2;
  }*/
#endif

#endif /* __x86_64__ */

  while ((x >>= 1) > 0)
  {
    asm ("fildll %1\n\t"
         "fmul %%st(0)\n\t"
         "fmul %%st(1)\n\t"
         "fistpll %0"
         : "=m" (T[0]) : "m" (K[0]) );

#if (APP_BUFLEN >= 2)
    asm ("fildll %1\n\t"
         "fmul %%st(0)\n\t"
         "fmul %%st(2)\n\t"
         "fistpll %0"
         : "=m" (T[1]) : "m" (K[1]) );
#endif
#if (APP_BUFLEN >= 3)
    asm ("fildll %1\n\t"
         "fmul %%st(0)\n\t"
         "fmul %%st(3)\n\t"
         "fistpll %0"
         : "=m" (T[2]) : "m" (K[2]) );
#endif
#if (APP_BUFLEN >= 4)
    asm ("fildll %1\n\t"
         "fmul %%st(0)\n\t"
         "fmul %%st(4)\n\t"
         "fistpll %0"
         : "=m" (T[3]) : "m" (K[3]) );
#endif
#if (APP_BUFLEN >= 5)
    asm ("fildll %1\n\t"
         "fmul %%st(0)\n\t"
         "fmul %%st(5)\n\t"
         "fistpll %0"
         : "=m" (T[4]) : "m" (K[4]) );
#endif
#if (APP_BUFLEN >= 6)
    asm ("fildll %1\n\t"
         "fmul %%st(0)\n\t"
         "fmul %%st(6)\n\t"
         "fistpll %0"
         : "=m" (T[5]) : "m" (K[5]) );
#endif
#if (APP_BUFLEN >= 7)
    for (i = 6; i < APP_BUFLEN; i++)
      asm ("fldt %2\n\t"
           "fildll %1\n\t"
           "fmul %%st(0)\n\t"
           "fmulp\n\t"
           "fistpll %0"
           : "=m" (T[i]) : "m" (K[i]), "m" (INV[i-6]) );
#endif

#ifdef __x86_64__
    /* A correction is required more often as P[i] increases, but no more
       than about 1 time in 8 on average, even for the largest P[i]. */
    for (i = 0; i < APP_BUFLEN; i++)
      if (__builtin_expect(((K[i] = K[i]*K[i] - T[i]*P[i]) >= P[i]),0))
        K[i] -= P[i];

    if (n & x)
    {
      for (i = 0; i < APP_BUFLEN; i++)
      {
        K[i] += (K[i] % 2)? P[i] : 0; /* Unpredictable */
        K[i] /= 2;
      }
    }
#else
#ifdef EMM // 32-bit SSE2 code
    if (n & x)
    {
      for (i = 0; i < APP_BUFLEN; i+=2) {
        register __m128i mt, mtemp, mtemp2;
        register __m128i mk = _mm_load_si128((__m128i*)(&K[i]));
        register __m128i mp = _mm_load_si128((__m128i*)(&P[i])); // Slip this in the latency.
        // K * K
        mtemp = _mm_srli_epi64(mk, 32);		// Get the high doubleword.
        mtemp = _mm_mul_epu32(mtemp, mk);
        mk = _mm_mul_epu32(mk, mk);
        mt = _mm_load_si128((__m128i*)(&T[i]));	// Slip this in the latency.
        mtemp = _mm_slli_epi64(mtemp, 33);	// Move result to other column, multiply by 2.
        mk = _mm_add_epi32(mk, mtemp);		// Add the results; only need high doublewords.
        // T * P
        mtemp = _mm_srli_epi64(mp, 32);		// Get the high doubleword.
        mtemp2 = _mm_srli_epi64(mt, 32);	// Get the high doubleword.
        mtemp = _mm_mul_epu32(mtemp, mt);
        mtemp2 = _mm_mul_epu32(mtemp2, mp);
        mt = _mm_mul_epu32(mt, mp);
        mtemp = _mm_add_epi32(mtemp, mtemp2);	// Just need the low doublewords.
        mtemp = _mm_slli_epi64(mtemp, 32);	// Move result to other column (high doublewords).
        mt = _mm_add_epi32(mt, mtemp);		// Add the results; only need high doublewords.
        // K*K-T*P
        mk = _mm_sub_epi64(mk, mt);
        // In case of (n & x), do the divide by two here.
        //k0 += (k0 % 2)?p0:0;
        mtemp = _mm_and_si128(mk, mones);	// (mk % 2)
        mtemp = _mm_sub_epi64(mtemp, mones);	// 1 goes to 0; 0 goes to FFFFFFFFFFFFFFFF.
        mtemp = _mm_andnot_si128(mtemp, mp);	// mp if mk%2 == 1; 0 if mk%2 == 0.
        mk = _mm_add_epi64(mk, mtemp);		// mk += the result.
        //k0 /= 2;
        mk = _mm_srli_epi64(mk, 1);
        _mm_store_si128((__m128i*)(&K[i]), mk);
        mk = _mm_sub_epi64(mk, mp);     // Negative iff K[i] < P[i]
        unsigned int bits = _mm_movemask_epi8(mk);
        if((bits & 0x80) == 0) K[i] -= P[i];
        if((bits & 0x8000) == 0) K[i+1] -= P[i+1];
      }
    } else {
      for (i = 0; i < APP_BUFLEN; i+=2) {
        register __m128i mt, mtemp, mtemp2;
        register __m128i mk = _mm_load_si128((__m128i*)(&K[i]));
        register __m128i mp = _mm_load_si128((__m128i*)(&P[i])); // Slip this in the latency.
        mtemp = _mm_srli_epi64(mk, 32);
        mtemp = _mm_mul_epu32(mtemp, mk);
        mk = _mm_mul_epu32(mk, mk);
        mt = _mm_load_si128((__m128i*)(&T[i])); // Slip this in the latency.
        mtemp = _mm_slli_epi64(mtemp, 33); // Move result to other column, multiply by 2.
        mk = _mm_add_epi32(mk, mtemp);  // Add the results; only need high doublewords.
        mtemp = _mm_srli_epi64(mp, 32);
        mtemp2 = _mm_srli_epi64(mt, 32);
        mtemp = _mm_mul_epu32(mtemp, mt);
        mtemp2 = _mm_mul_epu32(mtemp2, mp);
        mt = _mm_mul_epu32(mt, mp);
        mtemp = _mm_add_epi32(mtemp, mtemp2); // Just need the low doublewords.
        mtemp = _mm_slli_epi64(mtemp, 32); // Move result to other column (high doublewords).
        mt = _mm_add_epi32(mt, mtemp);  // Add the results; only need high doublewords.
        mk = _mm_sub_epi64(mk, mt);
        // In case of (n & x), do the divide by two here; This is not that case.
        _mm_store_si128((__m128i*)(&K[i]), mk);
        mk = _mm_sub_epi64(mk, mp);     // Negative iff K[i] < P[i]
        unsigned int bits = _mm_movemask_epi8(mk);
        if((bits & 0x80) == 0) K[i] -= P[i];
        if((bits & 0x8000) == 0) K[i+1] -= P[i+1];
      }      
    }
#else // 32-bit only code
    for (i = 0; i < APP_BUFLEN; i++)
      if (__builtin_expect(((K[i] = K[i]*K[i] - T[i]*P[i]) >= P[i]),0))
        K[i] -= P[i];

    if (n & x)
    {
      for (i = 0; i < APP_BUFLEN; i++)
        // This should force use of the CMOV instruction.
        // It's faster than a compare when K[i]%2 is random.
        K[i] += (((unsigned int)K[i]) & 1)?P[i]:0;
      // When dealing directly with memory, leave the memory
      // latency time to get assigned before re-reading it.
      for (i = 0; i < APP_BUFLEN; i++)
        K[i] /= 2;
    }
#endif
#endif
  }

  if (nstep <= 1) /* Use fast division by 2 */
  {
    while (1)
    {
      for (i = 0; i < APP_BUFLEN; i++)
      {
        uint64_t k = K[i], p = P[i];

        if (k <= kmax || p-k <= kmax) /* unlikely if p >> kmax */
        {
          k = (k%2)? k : p-k; /* Check k or -k, whichever is odd. */

          if (k <= kmax && k >= kmin)
            test_factor(p,k,n,(k==K[i])?-1:+1);
        }
      }

      if (++n > nmax)
        break;

      for (i = 0; i < APP_BUFLEN; i++)
      {
        K[i] += (K[i] % 2)? P[i] : 0; /* Unpredictable */
        K[i] /= 2;
      }
    }
  }
  else /* nstep > 1, use multiplication by 2^{nstep} */
  {
    /* First step size might be less than nstep */
#ifdef EMM
    // Load nstep for SSE2 shifting.
    __m128i mnstep = _mm_cvtsi32_si128(nstep);
    __m128i mkmax = _mm_load_si128((__m128i*)xkmax);
#endif

    for (i = 0; i < APP_BUFLEN; i++)
    {
#ifdef __x86_64__
      uint64_t kpos, kneg;
      unsigned int mpos, mneg;

      kpos = K[i];
      kneg = P[i]-K[i];
      mpos = __builtin_ctzll(kpos);
      mneg = __builtin_ctzll(kneg);
      kpos >>= mpos;
      kneg >>= mneg;

      if (kpos <= kmax && kpos >= kmin && n+mpos <= nmax)
        test_factor(P[i],kpos,n+mpos,-1);
      if (kneg <= kmax && kneg >= kmin && n+mneg <= nmax)
        test_factor(P[i],kneg,n+mneg,+1);
#else
      T[i] = P[i] - K[i];
    }

    for (i = 0; i < APP_BUFLEN; i++) {
      uint64_t kpos;
      unsigned int mpos, kbit;

      kbit = ((unsigned int)K[i]) & 1;

      // Test the even one.
      kpos = (kbit)?T[i]:K[i];
      mpos = __builtin_ctzll(kpos);
      kpos >>= mpos;

      if (kpos <= kmax && kpos >= kmin && n+mpos <= nmax)
        test_factor(P[i],kpos,n+mpos,2*kbit-1);

      // Test the odd one.
      kpos = (kbit)?K[i]:T[i];
      //kpos = P[i] - K[i];
      //mpos = __builtin_ctzll(kpos);
      //kpos >>= mpos;

      if (kpos <= kmax && kpos >= kmin)
        test_factor(P[i],kpos,n,1-2*kbit);
#endif
    }

    if (n > nmin)
    {
      /* Multiply inverses by constant 2^{nstep} */
      asm volatile ("fildl %0\n\t"
                    "fld1\n\t"
                    "fscale\n\t"
                    "fstp %%st(1)"
                    : : "m" (nstep) );
      asm volatile ("fmul %st(0), %st(1)");
#if (APP_BUFLEN >= 2)
      asm volatile ("fmul %st(0), %st(2)");
#endif
#if (APP_BUFLEN >= 3)
      asm volatile ("fmul %st(0), %st(3)");
#endif
#if (APP_BUFLEN >= 4)
      asm volatile ("fmul %st(0), %st(4)");
#endif
#if (APP_BUFLEN >= 5)
      asm volatile ("fmul %st(0), %st(5)");
#endif
#if (APP_BUFLEN >= 6)
      asm volatile ("fmul %st(0), %st(6)");
#endif
#if (APP_BUFLEN >= 7)
      for (i = 6; i < APP_BUFLEN; i++)
        asm ("fldt %0\n\t"
             "fmul %%st(1)\n\t"
             "fstpt %0"
             : "+m" (INV[i-6]) );
#endif
      asm volatile ("fstp %st(0)");

      do /* Remaining steps are all of equal size nstep */
      {
        n -= nstep;

        /* K[i] <-- K[i]*2^{nstep} mod P[i] */

        asm ("fildll %1\n\t"
             "fmul %%st(1)\n\t"
             "fistpll %0"
             : "=m" (T[0]) : "m" (K[0]) );

#if (APP_BUFLEN >= 2)
        asm ("fildll %1\n\t"
             "fmul %%st(2)\n\t"
             "fistpll %0"
             : "=m" (T[1]) : "m" (K[1]) );
#endif
#if (APP_BUFLEN >= 3)
        asm ("fildll %1\n\t"
             "fmul %%st(3)\n\t"
             "fistpll %0"
             : "=m" (T[2]) : "m" (K[2]) );
#endif
#if (APP_BUFLEN >= 4)
        asm ("fildll %1\n\t"
             "fmul %%st(4)\n\t"
             "fistpll %0"
             : "=m" (T[3]) : "m" (K[3]) );
#endif
#if (APP_BUFLEN >= 5)
        asm ("fildll %1\n\t"
             "fmul %%st(5)\n\t"
             "fistpll %0"
             : "=m" (T[4]) : "m" (K[4]) );
#endif
#if (APP_BUFLEN >= 6)
        asm ("fildll %1\n\t"
             "fmul %%st(6)\n\t"
             "fistpll %0"
             : "=m" (T[5]) : "m" (K[5]) );
#endif
#if (APP_BUFLEN >= 7)
        for (i = 6; i < APP_BUFLEN; i++)
          asm ("fldt %2\n\t"
               "fildll %1\n\t"
               "fmulp\n\t"
               "fistpll %0"
               : "=m" (T[i]) : "m" (K[i]), "m" (INV[i-6]) );
#endif

#ifndef EMM
        for (i = 0; i < APP_BUFLEN; i++)
          if (__builtin_expect(((K[i] = (K[i]<<nstep) - T[i]*P[i]) >= P[i]),0))
            K[i] -= P[i];
#else  // SSE2 version:
        for (i = 0; i < APP_BUFLEN; i+=2) {
          register __m128i mk, mp, mt, mtemp, mtemp2;
          mp = _mm_load_si128((__m128i*)(&P[i]));
          mt = _mm_load_si128((__m128i*)(&T[i]));
          mk = _mm_load_si128((__m128i*)(&K[i])); // Slip this in the latency.
          mtemp = _mm_srli_epi64(mp, 32);
          mtemp2 = _mm_srli_epi64(mt, 32);
          mtemp = _mm_mul_epu32(mtemp, mt);
          mtemp2 = _mm_mul_epu32(mtemp2, mp);
          mk = _mm_sll_epi64(mk, mnstep); // Slip this in on another port.
          mt = _mm_mul_epu32(mt, mp);
          mtemp = _mm_add_epi32(mtemp, mtemp2); // Just need the low doublewords.
          mtemp = _mm_slli_epi64(mtemp, 32); // Move result to other column (high doublewords).
          mt = _mm_add_epi32(mt, mtemp);  // Add the results; only need high doublewords.
          mk = _mm_sub_epi64(mk, mt);
          // In case of (n & x), do the divide by two here; This is not that case.
          _mm_store_si128((__m128i*)(&K[i]), mk);
          mk = _mm_sub_epi64(mk, mp);     // Negative iff K[i] < P[i]
          unsigned int bits = _mm_movemask_epi8(mk);
          if((bits & 0x80) == 0) K[i] -= P[i];
          if((bits & 0x8000) == 0) K[i+1] -= P[i+1];
        }
#endif

#ifdef __x86_64__
        for (i = 0; i < APP_BUFLEN; i++) {
          uint64_t kpos, kneg;
          unsigned int mpos, mneg;

          kpos = K[i];
          kneg = P[i]-K[i];
          mpos = __builtin_ctzll(kpos);
          mneg = __builtin_ctzll(kneg);
          kpos >>= mpos;
          kneg >>= mneg;

          if (kpos <= kmax && kpos >= kmin && mpos < nstep)
            test_factor(P[i],kpos,n+mpos,-1);
          if (kneg <= kmax && kneg >= kmin && mneg < nstep)
            test_factor(P[i],kneg,n+mneg,+1);
        }
#else
#ifdef EMM
        {
          // mk holds K; mt P or the value for T; mxor (K^(P-K));
          // and mbit all 1's or all 0's depending on K&1.
          // ...generally.  They mix it up a bit.
          __m128i mk, mt, mxor, mbit;
          unsigned int bits;
          for(i=0; i < APP_BUFLEN; i+=2) {
            mk = _mm_load_si128((__m128i*)(&K[i]));
            mt = _mm_load_si128((__m128i*)(&P[i]));
            mt = _mm_sub_epi64(mt, mk);   // mt = P-K
            mxor = _mm_xor_si128(mk, mt); // mxor = K^(P-K)
            mbit = _mm_and_si128(mones, mk);
            mbit = _mm_sub_epi64(mbit, mones);
            mxor = _mm_and_si128(mxor, mbit);
            mt = _mm_xor_si128(mt, mxor);
            mk = _mm_xor_si128(mk, mxor);
            mk = _mm_sub_epi64(mk, mkmax);
            _mm_store_si128((__m128i*)(&T[i]), mt);
            bits = _mm_movemask_epi8(mk);
            //assert(K[i] == T[i] || T[i] == (P[i]-K[i]));
            //assert(K[i+1] == T[i+1] || T[i+1] == (P[i+1]-K[i+1]));
            if ((bits & 0x80)) {
              uint64_t k = P[i]-T[i];
              if(k >= kmin)
                test_factor(P[i],k,n,(k==K[i])?-1:+1);
            }
            if ((bits & 0x8000)) {
              uint64_t k = P[i+1]-T[i+1];
              if(k >= kmin)
                test_factor(P[i+1],k,n,(k==K[i+1])?-1:+1);
            }
          }
        }
        for (i = 0; i < APP_BUFLEN; i++) {
          uint64_t kpos;
          unsigned int mpos;

          // Test the even one left over from the SSE2 work.
          kpos = T[i];
          //assert((kpos&1) == 0);
          mpos = __builtin_ctzll(kpos);
          kpos >>= mpos;

          if (kpos <= kmax && kpos >= kmin && mpos < nstep)
            test_factor(P[i],kpos,n+mpos,2*(((unsigned int)K[i])&1)-1);
        }
#else
        for (i = 0; i < APP_BUFLEN; i++) {
          T[i] = P[i] - K[i];
        }

        for (i = 0; i < APP_BUFLEN; i++) {
          uint64_t kpos;
          unsigned int mpos, kbit;

          kbit = ((unsigned int)K[i]) & 1;

          // Test the even one.
          kpos = (kbit)?T[i]:K[i];
          mpos = __builtin_ctzll(kpos);
          kpos >>= mpos;

          if (kpos <= kmax && kpos >= kmin && mpos < nstep)
            test_factor(P[i],kpos,n+mpos,2*kbit-1);

          // Test the odd one.
          kpos = (kbit)?K[i]:T[i];
          //kpos = P[i] - K[i];
          //mpos = __builtin_ctzll(kpos);
          //kpos >>= mpos;

          if (kpos <= kmax && kpos >= kmin)
            test_factor(P[i],kpos,n,1-2*kbit);
        }
#endif
#endif

      } while (n > nmin);
    }
  }

#if (APP_BUFLEN <= 6)
  for (i = 0; i < APP_BUFLEN; i++)
    asm volatile ("fstp %st(0)");
#else
  for (i = 0; i < 6; i++)
    asm volatile ("fstp %st(0)");
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
