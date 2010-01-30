/* app.h -- (C) Geoffrey Reynolds, March 2009.

   Dummy application.


   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.
*/

#ifndef _APP_H
#define _APP_H 1

#include <stdio.h>
#include <stdint.h>


#define APP_VERSION "0.1"

/* Number of primes to buffer between calls to app_thread_fun()
 */
#define APP_BUFLEN 4

#define CHECKPOINT_FILENAME "dummy-checkpoint.txt"

#define CONFIG_FILENAME "dummy-config.txt"

#define APP_SHORT_OPTS ""
#define APP_LONG_OPTS

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
