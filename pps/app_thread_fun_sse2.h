/* app.h -- (C) Geoffrey Reynolds, April 2009.
 * and Ken Brazier October 2009.

   Proth Prime Search sieve.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
*/

#ifndef _APP_SSE2_H
#define _APP_SSE2_H 1

void app_thread_fun_sse2(int th, uint64_t *__attribute__((aligned(16))) P, const uint64_t kmin, const uint64_t kmax, const int addsign, const unsigned int nmin, const unsigned int nmax, unsigned int n, const unsigned int nstep, const int sse2_in_range, const uint64_t *xkmax);

#endif /* _APP_H */
