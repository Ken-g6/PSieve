This is far from finished. Run `./tpsieve -h' for a list of options.


To sieve for factors 7700e12 <= p < 7701e12 from a NewPGen format file:

  ./tpsieve -i FILE -p 7700e12 -P 7701e12


To sieve without an input file (for testing or benchmarking):

  ./tpsieve -k 60e9 -K 100e9 -n 333333 -p 7700e12 -P 7701e12


Options can be given default values in a configuration file and overridden
on the command line. E.g. to start 2 threads add this line to tpconfig.txt:

  threads=2


Integer arguments to config file or command line options can be given using
this shorthand: K=10^3, M=10^6, G=10^9, T=10^12, P=10^15, or k=2^10, m=2^20,
g=2^30, t=2^40, p=2^50. So for example the integer 1000000 can be given as
any of: 1M, 1000K, 1000000, 1e6, 10e5, etc.


For best results, adjust the time spend sieving candidates p by specifying
the prime sieve depth q (e.g. sieve p for factors up to q=10e6):

  ./tpsieve -i FILE -p 7700e12 -P 7701e12 -Q 10e6


To convert a NewPGen format file INFILE to a more compact ABCD format file
OUTFILE (INFILE and OUTFILE must not be the same file):

  ./tp_abcd < INFILE > OUTFILE
