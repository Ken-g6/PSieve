Sieve for sequences of Generalised Fermat numbers a^2^m + (a+1)^2^m, m fixed.

This program was cobbled together from parts of another program I am working
on, and so has some quirks, and some parts are unfinished. In particular it
has no SSE2 optimisations and so performance on 32-bit machines is well
below what is possible. Performance on 64-bit machines should be OK, but
still with room for improvement.

It is completely untested. Let me know of any bugs: g_w_reynolds@yahoo.co.nz

A quirk: You must specify the range of candidate factors k*2^n+1, and k must
be odd. This means that if you want to sieve terms a^2^12 + (a+1)^b^12 for
all factors in the range kmin*2^13+1 to kmax*2^13+1, you must seperately
sieve the ranges:
  kmin*2^13+1 to kmax*2^13+1,
  (kmin/2)*2^14+1 to (kmax/2)*2^14+1,
  (kmin/4)*2^15+1 to (kmax/4)*2^15+1,
  and so on.

Factors are limited to k*2^n+1 < 2^62.
In a^2^m + (a+1)^2^m, a is limited to 2^62-2.


Some examples:

To start a new sieve for terms a^2^12 + (a+1)^2^12 with 1 <= a < 10000:

$ ./robert62 -a 1 -A 10000 -m 12 -o out1.txt -k 1 -K 1000000 -n 13


To continue the above sieve removing factors with n=14:

$ ./robert62 -i out1.txt -o out2.txt -k 1 -K 500000 -n 14


Have a look at the configuration file robert-config.txt. To see a full list
of options:

$ ./robert62 -h


Integer arguments to options can be given using the following shorthand:

k = 2^10  K = 10^3
m = 2^20  M = 10^6
g = 2^30  G = 10^9
p = 2^40  P = 10^12
t = 2^50  T = 10^15
b<N> = 2^N  e<N> = 10^N

E.g. 1000000 = 1000K = 1M = 1e6 = 10e5 etc.
     1048576 = 1024k = 1m = 1b20 = 2b19 etc.
