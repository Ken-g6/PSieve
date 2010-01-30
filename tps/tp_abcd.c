/* tp_abcd.c -- (C) Geoffrey Reynolds, July 2009.

   Convert a NewPGen twin sieve to ABCD format for use with tpsieve.
   Implemented in C instead of AWK script because some AWKs might not handle
   64-bit integers correctly.

   Usage: tp_abcd < INFILE > OUTFILE

   INFILE and OUTFILE must not be the same file!


   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <inttypes.h>

int main(void)
{
  uint64_t k, k0, p;
  unsigned int n, n0;
  int res, line;
  char ch;

  if (scanf("%"SCNu64":T:%*c:2:%c",&p,&ch) != 2 || ch != '3')
  {
    fprintf(stderr,"ERROR (line 1): Invalid header\n");
    exit(EXIT_FAILURE);
  }

  k0 = 0;
  n0 = 0;
  line = 2;
  while ((res = scanf(" %"SCNu64" %u",&k,&n)) == 2)
  {
    if (k%6 != 3)
    {
      fprintf(stderr,"ERROR (line %d): invalid k != 3 (mod 6)\n",line);
      exit(EXIT_FAILURE);
    }
    if (n == n0)
    {
      if (k <= k0)
      {
        fprintf(stderr,"ERROR (line %d): non-increasing k\n",line);
        exit(EXIT_FAILURE);
      }
      printf("%"PRIu64"\n",(k-k0)/6);
      k0 = k;
    }
    else
    {
      k0 = k;
      n0 = n;
      printf("ABCD (6*$a+3)*2^%u+1 & (6*$a+3)*2^%u-1 [%"PRIu64"]\n",n,n,k/6);
    }
    line++;
  }

  if (res != EOF)
  {
    fprintf(stderr,"ERROR (line %d): invalid input\n",line);
    exit(EXIT_FAILURE);
  }

  return 0;
}
