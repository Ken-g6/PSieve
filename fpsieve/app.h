/* app.h -- (C) March 2009, Mark Rodenkirch, Geoffrey Reynolds.

   Factorial/Primorial sieve application.


   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
*/

#ifndef _APP_H
#define _APP_H 1

#include <stdio.h>
#include <stdint.h>


#define APP_VERSION "0.2.4"


/* Number of candidates to buffer between calls to app_thread_fun()
 */
#if defined(__ppc__) || defined(__ppc64__)
# define APP_BUFLEN 6
#else
# define APP_BUFLEN 4
#endif

#define CHECKPOINT_FILENAME "fpcheckpoint.txt"

#define CONFIG_FILENAME "fpconfig.txt"


#define FACTORS_FILENAME_DEFAULT "fpfactors.txt"

#if __i386__ && !__SSE2__
#define SSE2_OPT 512
#define NO_SSE2_OPT 513
#define SSE2_LONG_OPTS \
  {"sse2",          no_argument,       0, SSE2_OPT}, \
  {"no-sse2",       no_argument,       0, NO_SSE2_OPT},
#else
#define SSE2_LONG_OPTS
#endif

#define APP_SHORT_OPTS "n:N:i:o:f:xy"
#define APP_LONG_OPTS \
  {"nmin",          required_argument, 0, 'n'}, \
  {"nmax",          required_argument, 0, 'N'}, \
  {"input",         required_argument, 0, 'i'}, \
  {"output",        required_argument, 0, 'o'}, \
  {"factors",       required_argument, 0, 'f'}, \
  {"factorial",     no_argument,       0, 'x'}, \
  {"primorial",     no_argument,       0, 'y'}, \
  SSE2_LONG_OPTS

void app_banner(void);
int app_parse_option(int opt, char *arg, const char *source);
void app_help(void);
void app_init(void);
void app_thread_init(int th);
void app_thread_fun(int th, uint64_t *P);
void app_thread_fun1(int th, uint64_t *P, unsigned int len);
void app_thread_fini(int th);
int app_read_checkpoint(FILE *f);
void app_write_checkpoint(FILE *f);
void app_fini(void);

#endif /* _APP_H */
