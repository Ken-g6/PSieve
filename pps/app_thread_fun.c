/* ex: set softtabstop=2 shiftwidth=2 expandtab: */
/* app.c -- (C) Geoffrey Reynolds, April-August 2009.
 * With improvements by Ken Brazier August-October 2009.

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
//#ifndef __x86_64__  // Comment this to do benchmarking in 64-bit.
#ifdef __SSE2__
#ifdef __x86_64__
#include <time.h>
#include "app_thread_fun_x64.h"
#else
#include "app_thread_fun_sse2.h"
#define EMM
#include <emmintrin.h>
#endif
#else
#include "app_thread_fun_nosse2.h"
#endif
//#endif
#include "main.h"
#include "putil.h"
#include "app.h"
#define INLINE static inline

#ifndef __x86_64__
// Macro bsfq (Bit Search Forward Quadword) for 32-bit.
// MPOS = result (32-bit)
// KPOS = input (64-bit; evaluated twice!)
// ID = a unique ID string.
#ifdef __i386__
#define BSFQ(MPOS,KPOS,ID)          asm volatile \
            ( 		"bsfl	%[k0l], %[pos]	\n" \
                "	jnz	bsflok"ID"		\n" \
                "	bsfl	%[k0h], %[pos]	\n" \
                "	addl	$32, %[pos]	\n" \
                "bsflok"ID":" \
                : [pos] "=r" (MPOS) \
                : [k0l] "rm" ((unsigned int)(KPOS)), \
                [k0h] "rm" ((unsigned int)((KPOS) >> 32)) \
                : "cc" )
#else
// If anyone wants to compile on some non-x86 platform somehow...
#define BSFQ(MPOS,KPOS,ID) MPOS = __builtin_ctzll(KPOS);
#endif
#endif

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
    fprintf (stderr, "%sError, onemod_redc(%lu,%lu) = %lu\n",bmprefix(), 1ul, N, r);
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
    fprintf (stderr, "%sError, redc(%lu,%lu,%lu) = %lu\n",bmprefix(), a, N, Ns, r);
    bexit(EXIT_FAILURE);
  }
#endif

  return r;
}
#endif

/* This function is called 0 or more times in thread th, 0 <= th < num_threads.
   P is an array of APP_BUFLEN candidate primes.
   nstart is passed in as "n".
*/
#ifdef __x86_64__
void app_thread_fun_x64(int th, uint64_t *__attribute__((aligned(16))) P, const uint64_t kmin, const uint64_t kmax, const int addsign, const unsigned int nmin, const unsigned int nmax, unsigned int n, const unsigned int nstep, const int sse2_in_range, const uint64_t ld_r0, const int ld_bbits)  /* x64 only */
#else
#ifdef __SSE2__
void app_thread_fun_sse2(int th, uint64_t *__attribute__((aligned(16))) P, const uint64_t kmin, const uint64_t kmax, const int addsign, const unsigned int nmin, const unsigned int nmax, unsigned int n, const unsigned int nstep, const int sse2_in_range, const uint64_t *xkmax)  /* SSE2 only */
#else
void app_thread_fun_nosse2(int th, uint64_t *__attribute__((aligned(16))) P, const uint64_t kmin, const uint64_t kmax, const int addsign, const unsigned int nmin, const unsigned int nmax, unsigned int n, const unsigned int nstep)
#endif
#endif
{
  uint64_t K[APP_BUFLEN*2] __attribute__((aligned(16)));
  uint64_t T[APP_BUFLEN] __attribute__((aligned(16)));
#if (APP_BUFLEN >= 7)
  long double INV[APP_BUFLEN-6];
#endif
#if defined(__SSE2__) && (!defined(__x86_64__)) // || defined(_WIN32)
  static const uint64_t xones[2] __attribute__((aligned(16))) = {1ul, 1ul};
  __m128i mones = _mm_load_si128((__m128i*)xones);
#endif
  unsigned int x;
  unsigned int i;
  unsigned int nstart = n;

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

#if defined(__x86_64__) //&& !defined(_WIN32)
  // If the init said Montgomery math was OK, do it:
  if(ld_r0) {
    // Work through the first 6 bits of b with Montgomery math.
    // If ld_r0 is small (and it should be at least <= 32), there's a very good chance no mod is needed!
    for(i=0; i < APP_BUFLEN; i+=2) {
      // First, calculate the Montgomery inverses of P[i] and P[i+1].
      register uint64_t r1, r2;
      register unsigned int in1 = (unsigned int)P[i], in2 = (unsigned int) P[i+1];

      /* Suggestion from PLM: initing the inverse to (3*n) XOR 2 gives the
         correct inverse modulo 32, then 3 (for 32 bit) or 4 (for 64 bit) 
         Newton iterations are enough. */
      r1 = (((uint64_t)3) * P[i]) ^ ((uint64_t)2);
      r2 = (((uint64_t)3) * P[i+1]) ^ ((uint64_t)2);
      /* Newton iteration */
      r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
      r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
      r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
      r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
      r1 += r1 - (unsigned int) r1 * (unsigned int) r1 * in1;
      r2 += r2 - (unsigned int) r2 * (unsigned int) r2 * in2;
      r1 += r1 - r1 * r1 * P[i];
      r2 += r2 - r2 * r2 * P[i+1];
      // ld_r0 is precalculated as 2^-(1st 6 bits) * 2^64.
      // Use montgomery math to calculate 2^-(1st 6 bits) mod P, for both P's.
      // *** Doesn't work if P < 2^32!!!! ***
      K[i] = mod_REDC(ld_r0, P[i], -r1);
      K[i+1] = mod_REDC(ld_r0, P[i+1], -r2);
    }
    x = 1U << (ld_bbits+1);
  } else {
    // Just initialize it straight up.
    x = 1U << (31 - __builtin_clz(n));
  }
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
  // Just initialize it straight up.
  x = 1U << (31 - __builtin_clz(n));
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
#ifdef EMM // 32-bit SSE2 code for K^2-TP
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
#else // 32-bit only code for K^2-TP
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

  // Use only -K.
  if(addsign == 1) {
    for (i = 0; i < APP_BUFLEN; i++) {
      K[i] = P[i]-K[i];
    }
  }
  if (nstep <= MIN_MULMOD_NSTEP) /* Use fast division by 2 */
  {
    /* Check all N's */
# ifdef __x86_64__
    if(sse2_in_range) {
      for (i = 0; i < APP_BUFLEN; i+=2)
      {
        // Load K and P only once each.
        // Do two at a time for software pipelining.
        uint64_t k0 = K[i], p0 = P[i];
        uint64_t k1 = K[i+1], p1 = P[i+1];
        n = nstart;

        // Proceed with the rest.
        while (1)
        {
          if (k0 <= kmax && k0 >= kmin) /* unlikely if p >> kmax */
            test_factor(p0, k0, n, addsign);
          if (k1 <= kmax && k1 >= kmin) /* unlikely if p >> kmax */
            test_factor(p1, k1, n, addsign);

          if (++n > nmax)
            break;

          // A pipelined CMOV.
          k0 += (k0 % 2)?p0:0;
          k1 += (k1 % 2)?p1:0;
          k0 /= 2;
          k1 /= 2;
        }
      }
    } else {
      for (i = 0; i < APP_BUFLEN; i+=2)
      {
        // Load K and P only once each.
        // Do two at a time for software pipelining.
        uint64_t k0 = K[i], p0 = P[i];
        uint64_t k1 = K[i+1], p1 = P[i+1];
        unsigned int n1;
        n = nstart;
        n1 = nstart;

        // Proceed with the rest.
        while (1)
        {
          {
            unsigned int m0, m1;
            m0 = __builtin_ctzll(k0);
            m1 = __builtin_ctzll(k1);
            k0 >>= m0;
            n += m0;
            k1 >>= m1;
            n1 += m1;
          }
          if (k0 <= kmax && k0 >= kmin) /* unlikely if p >> kmax */
            test_factor(p0, k0, n, addsign);
          if (k1 <= kmax && k1 >= kmin) /* unlikely if p >> kmax */
            test_factor(p1, k1, n1, addsign);

          if (++n > nmax || ++n1 > nmax)
            break;

          // A pipelined CMOV.
          k0 += p0;
          k1 += p1;
          k0 /= 2;
          k1 /= 2;
        }

        // Finish up the straggler.
        if(n1 < n) {
          k0 = k1;
          p0 = p1;
          n = n1;
        }
        while (n <= nmax)
        {
          k0 += (k0 % 2)?p0:0;
          k0 /= 2;
          if (k0 <= kmax && k0 >= kmin) /* unlikely if p >> kmax */
            test_factor(p0, k0, n, addsign);

          ++n;
        }
      }
    }
# else
#ifdef __SSE2__
    __m128i mkmax = _mm_load_si128((__m128i*)xkmax);
    for (i = 0; i < APP_BUFLEN; i+=2)
    {
      unsigned int bits;
      n = nstart;
      // Load K and P only once each,
      // except in case of a factor.
      // Do two at a time with SSE2
      __m128i mp = _mm_load_si128((__m128i*)&P[i]);
      __m128i mk = _mm_load_si128((__m128i*)&K[i]);
      // Precompute for every P:
      //__m128i mpmkmax = _mm_sub_epi64(mp, mkmax);
      __m128i mtemp;

      while (1)
      {
        // Check: (mk <= kmax || mp-mk <= kmax) - unlikely if p >> kmax
        // We check mk-mkmax < 0 || ((mp-mk)-mkmax == (mp-mkmax)-mk) < 0
        // mkmax = kmax + 1, so this works like the <= above.
        mtemp = _mm_sub_epi64(mk, mkmax);
        //mtemp2 = _mm_sub_epi64(mpmkmax, mk);
        //mtemp = _mm_or_si128(mtemp, mtemp2);
        // Now get the sign bits.
        bits = _mm_movemask_epi8(mtemp);
        // The ones we care about are bits 7 and 15.
        if(bits & 0x8080) {
          // Move the K's back to memory for further work.
          _mm_store_si128 ((__m128i*)&K[i], mk);

          //if (k0 <= kmax || p0-k0 <= kmax) /* unlikely if p >> kmax */
          if(bits & 0x80)
            test_factor(P[i], K[i], n, addsign);
          //if (k1 <= kmax || p1-k1 <= kmax) /* unlikely if p >> kmax */
          if(bits & 0x8000)
            test_factor(P[i+1], K[i+1], n, addsign);
        }

        if (++n > nmax)
          break;

        // Now do an SSE2 CMOV-like bit trick.
        //k0 += (k0 % 2)?p0:0;
        mtemp = _mm_and_si128(mk, mones);		// (mk % 2)
        mtemp = _mm_sub_epi64(mtemp, mones);	// 1 goes to 0; 0 goes to FFFFFFFFFFFFFFFF.
        mtemp = _mm_andnot_si128(mtemp, mp);	// mp if mk%2 == 1; 0 if mk%2 == 0.
        mk = _mm_add_epi64(mk, mtemp);		// mk += the result.
        //k0 /= 2;
        mk = _mm_srli_epi64(mk, 1);
      }
    }
#else	// 32-bit, no SSE2
    for (i = 0; i < APP_BUFLEN; i++)
    {
      n = nstart;
      // Load K only once each.
      // Only one at a time, due to register pressure.
      uint64_t k0 = K[i];
      while (1)
      {
        if (k0 <= kmax && k0 >= kmin) // unlikely if p >> kmax
          test_factor(P[i], k0, n, addsign);

        if (++n > nmax)
          break;

        // Another CMOV.
        k0 += (((unsigned int)k0)&1)?P[i]:0;
        k0 /= 2;
      }
    }
#endif	// SSE2
#endif	// x86_64
  }
  else /* nstep > 1, use multiplication by 2^{nstep} */
  {
#ifdef EMM
    // Load nstep for SSE2 shifting.
#ifndef __x86_64__
    __m128i mnstep = _mm_cvtsi32_si128(nstep);
    __m128i mkmax = _mm_load_si128((__m128i*)xkmax);
#endif
#endif
    /* First step size might be less than nstep */
    for (i = 0; i < APP_BUFLEN; i++) {
      uint64_t kpos;
      unsigned int mpos;

      kpos = K[i];
      mpos = __builtin_ctzll(kpos);
      kpos >>= mpos;

      if (kpos <= kmax && kpos >= kmin && n+mpos <= nmax)
        test_factor(P[i],kpos,n+mpos,addsign);
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
      /* Remaining steps are all of equal size nstep */
#ifdef EMM
      // Faster, but range-restricted SSE2 algorithm:
      if(sse2_in_range)
        do {
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

#ifdef __x86_64__
        for (i = 0; i < APP_BUFLEN; i++)
          if (__builtin_expect(((K[i] = (K[i]<<nstep) - T[i]*P[i]) >= P[i]),0))
            K[i] -= P[i];
#else
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

        for (i = 0; i < APP_BUFLEN; i++)
          if (__builtin_expect(((K[i+APP_BUFLEN] = (K[i]<<nstep) - T[i]*P[i]) >= P[i]),0))
            K[i+APP_BUFLEN] -= P[i];

        for (i = 0; i < APP_BUFLEN; i++) {
          uint64_t mk2, nk2;
          mk2 = K[i];
          nk2 = (-mk2) & mk2;
          nk2 *= kmax;
          if(mk2 <= nk2) {
            uint64_t kpos;
            unsigned int mpos;
            kpos = K[i];
            mpos = __builtin_ctzll(kpos);
            kpos >>= mpos;

            if (kpos <= kmax && kpos >= kmin && mpos < nstep)
              test_factor(P[i],kpos,n+mpos,addsign);
          }
        }
        n -= nstep;
        for (; i < APP_BUFLEN*2; i++) {
          uint64_t mk2, nk2;
          mk2 = K[i];
          K[i-APP_BUFLEN] = mk2;
          nk2 = (-mk2) & mk2;
          nk2 *= kmax;
          if(mk2 <= nk2) {
            uint64_t kpos;
            unsigned int mpos;
            kpos = K[i];
            mpos = __builtin_ctzll(kpos);
            kpos >>= mpos;

            if (kpos <= kmax && kpos >= kmin && mpos < nstep)
              test_factor(P[i-APP_BUFLEN],kpos,n+mpos,addsign);
          }
        }
#else
        for(i=0; i < APP_BUFLEN; i+=2) {
          __m128i mk, nk;
          unsigned int bitsk;
          // This limits the range to kmax < P < 2^32*kmax, and kmax < 2^32
          mk = _mm_load_si128((__m128i*)(&K[i]));
          // 1. Find the LSB of K with (K & -K)
          nk = _mm_xor_si128(nk, nk);
          nk = _mm_sub_epi32(nk, mk);   // Can be 32-bit since just looking for 1's in that area.
          nk = _mm_and_si128(nk, mk);
          //4. Add kmax+1 (or in this case sub it from the original K.)
          mk = _mm_sub_epi64(mk, mkmax);	// No longer using original mk, so fix it here.
          //2. Subtract 1 so it's all 1's below the number in the worst case.
          //   Might as well be 32-bit, since mul is 32-bit, and 0-1 = all 1's. 
          nk = _mm_sub_epi32(nk, mones);
          //3. Multiply kmax+1 by (unsigned int)that LSB
          nk = _mm_mul_epu32(nk, mkmax);
          //5. Compare the values: sub and get high bits.
          mk = _mm_sub_epi64(mk, nk);
          bitsk = _mm_movemask_epi8(mk);
          if ((bitsk & 0x80)) {
            uint64_t kpos;
            unsigned int mpos;
            kpos = K[i];
            mpos = __builtin_ctzll(kpos);
            kpos >>= mpos;

            if (kpos <= kmax && kpos >= kmin && mpos < nstep)
              test_factor(P[i],kpos,n+mpos,addsign);
          }
          if ((bitsk & 0x8000)) {
            uint64_t kpos;
            unsigned int mpos;
            kpos = K[i+1];
            mpos = __builtin_ctzll(kpos);
            kpos >>= mpos;

            if (kpos <= kmax && kpos >= kmin && mpos < nstep)
              test_factor(P[i+1],kpos,n+mpos,addsign);
          }
        }
        /*n -= nstep;
        for(; i < APP_BUFLEN*2; i+=2) {
          __m128i mk, nk;
          unsigned int bitsk;
          // This limits the range to kmax < P < 2^32*kmax, and kmax < 2^32
          mk = _mm_load_si128((__m128i*)(&K[i]));
          _mm_store_si128((__m128i*)(&K[i-APP_BUFLEN]), mk);
          // 1. Find the LSB of K with (K & -K)
          nk = _mm_xor_si128(nk, nk);
          nk = _mm_sub_epi32(nk, mk);   // Can be 32-bit since just looking for 1's in that area.
          nk = _mm_and_si128(nk, mk);
          //4. Add kmax+1 (or in this case sub it from the original K.)
          mk = _mm_sub_epi64(mk, mkmax);	// No longer using original mk, so fix it here.
          //2. Subtract 1 so it's all 1's below the number in the worst case.  Might as well be 32-bit, since mul is 32-bit, and 0-1 = all 1's. 
          nk = _mm_sub_epi32(nk, mones);
          //3. Multiply kmax+1 by (unsigned int)that LSB
          nk = _mm_mul_epu32(nk, mkmax);
          //5. Compare the values: sub and get high bits.
          mk = _mm_sub_epi64(mk, nk);
          bitsk = _mm_movemask_epi8(mk);
          if ((bitsk & 0x80)) {
            uint64_t kpos;
            unsigned int mpos;
            kpos = K[i];
            mpos = __builtin_ctzll(kpos);
            kpos >>= mpos;

            if (kpos <= kmax && kpos >= kmin && mpos < nstep)
              test_factor(P[i-APP_BUFLEN],kpos,n+mpos,addsign);
          }
          if ((bitsk & 0x8000)) {
            uint64_t kpos;
            unsigned int mpos;
            kpos = K[i+1];
            mpos = __builtin_ctzll(kpos);
            kpos >>= mpos;

            if (kpos <= kmax && kpos >= kmin && mpos < nstep)
              test_factor(P[i-APP_BUFLEN+1],kpos,n+mpos,addsign);
          }
        }*/
#endif
      } while (n > nmin);
      else
#endif
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

#if defined(__x86_64__) || !defined(EMM)
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

        for (i = 0; i < APP_BUFLEN; i++) {
          uint64_t kpos;
          unsigned int mpos;
          kpos = K[i];
          mpos = __builtin_ctzll(kpos);
          if (__builtin_expect(((K[i+APP_BUFLEN] = (kpos<<nstep) - T[i]*P[i]) >= P[i]),0))
            K[i+APP_BUFLEN] -= P[i];

          kpos >>= mpos;
          if (kpos <= kmax && kpos >= kmin && mpos < nstep)
            test_factor(P[i],kpos,n+mpos,addsign);
        }
        n -= nstep;

        for (; i < APP_BUFLEN*2; i++) {
          uint64_t kpos;
          unsigned int mpos;

          kpos = K[i];
          K[i-APP_BUFLEN] = kpos;

          mpos = __builtin_ctzll(kpos);
          kpos >>= mpos;
          if (kpos <= kmax && kpos >= kmin && mpos < nstep)
            test_factor(P[i-APP_BUFLEN],kpos,n+mpos,addsign);
        }
#else
// A macro of what would go in a loop but for the unique IDs needed:
#define TESTKPK(NUM,NUMID) \
          kpos = K[NUM]; \
          BSFQ(mpos, kpos, NUMID"K"); \
          kpos >>= mpos; \
          if (kpos <= kmax && kpos >= kmin && mpos < nstep) \
            test_factor(P[NUM],kpos,n+mpos,addsign)

        {
          uint64_t kpos;
          unsigned int mpos;

          TESTKPK(0, "0");
          TESTKPK(1, "1");
#if (APP_BUFLEN > 2)
          TESTKPK(2, "2");
          TESTKPK(3, "3");
#if (APP_BUFLEN > 4)
          TESTKPK(4, "4");
          TESTKPK(5, "5");
#if (APP_BUFLEN > 6)
        }
        for (i = 6; i < APP_BUFLEN; i++) {
          uint64_t kpos;
          unsigned int mpos;

          // Test P-K
          kpos = PMINUSK(i);
          mpos = __builtin_ctzll(kpos);
          kpos >>= mpos;

          if (kpos <= kmax && kpos >= kmin && mpos < nstep)
            test_factor(P[i],kpos,n+mpos,addsign);
#endif
#endif
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
