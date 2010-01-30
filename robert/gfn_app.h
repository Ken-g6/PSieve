/* gfn_app.h -- (C) Geoffrey Reynolds, May 2009.

   A sieve for Generalised Fermat numbers a^2^m + b^2^m, m fixed.


   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
*/

#ifndef _GFN_APP_H
#define _GFN_APP_H 1

#include <stdio.h>
#include <stdint.h>


#define APP_VERSION "0.2"

/* Number of primes to buffer between calls to app_thread_fun()
 */
#define APP_BUFLEN 6

#define CHECKPOINT_FILENAME "robert-checkpoint.txt"
#define CONFIG_FILENAME "robert-config.txt"
#define FACTORS_FILENAME_DEFAULT "factors.txt"

#define VEC_LEN 4

#define APP_SHORT_OPTS "a:A:m:M:i:o:f:"
#define APP_LONG_OPTS \
  {"amin",          required_argument, 0, 'a'}, \
  {"amax",          required_argument, 0, 'A'}, \
  {"mmin",          required_argument, 0, 'm'}, \
  {"mmax",          required_argument, 0, 'M'}, \
  {"input",         required_argument, 0, 'i'}, \
  {"output",        required_argument, 0, 'o'}, \
  {"factors",       required_argument, 0, 'f'},

void app_banner(void);
int app_parse_option(int opt, char *arg, const char *source);
void app_help(void);
void app_init(void);
void app_thread_init(int th);
void app_thread_fun(int th, uint64_t *K);
void app_thread_fun1(int th, uint64_t *K, unsigned int len);
void app_thread_fini(int th);
int app_read_checkpoint(FILE *f);
void app_write_checkpoint(FILE *f);
void app_fini(void);

#endif /* _GFN_APP_H */
