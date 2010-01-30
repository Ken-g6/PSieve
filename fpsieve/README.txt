These executables are intended for testing only.

fpsieve combines the functions of fsieve and psieve. It should work with the
same input files and produce compatible output, but it currently lacks many
of the features of fsieve and psieve. As it uses the same core code it will
not be any faster.

I am working on some new features that I intend eventually to add to
gcwsieve and sr2sieve, but for testing purposes it is easier to try out
these ideas with the factorial and primorial sieves.


Multi-threading:

The main new feature is multi-threading that (should) work with Linux, Mac
and Windows. As with all the sieve algorithms employed by PrimeGrid there is
no algorithmic advantage to multi-threading over running multiple copies of
a single-threaded sieve, and so even a perfect implementation will not run
any faster. But it is more convenient on multi-core machines and uses less
memory.

The thread model currently employed only allows one thread at a time to use
the prime genrator (Sieve of Eratosthenes) code. This scheme is not ideal
but it is simple and should work OK when there are not too many threads and
when the total time spend generating primes is low compared to the time
spent in the rest of the program. I am still working on better schemes.


Other features:

Instead of a command-line.txt file, program options can be given default
values in a configuration file and then overridden on the command line. For
example if you want to checkpoint every 5 minutes (300 seconds) you can add
the line

  checkpoint=300

to the fpconfig.txt file, and then override it on the command line as

  fpsieve --checkpoint=60

or (if there is a short form of the switch)

  fpsieve -c60


Integer arguments to config file or command line options can be given using
this shorthand: K=10^3, M=10^6, G=10^9, T=10^12, P=10^15, or k=2^10, m=2^20,
g=2^30, t=2^40, p=2^50. So for example the integer 1000000 can be given as
any of: 1M, 1000K, 1000000, 1e6, 10e5, etc.


All threads are synchronised before checkpointing. Although this is less
efficient than the asynchronous method used previously, it makes possible
the keeping of checksum type information combined from all threads. This
will allow a rigorous double-check of a sieve range to be performed (not
implemented yet).


The status line contains information about how much CPU power is being
employed, and the CPU frequency. This will allow the performance of the
multi-threading code to be monitored, and provide an easy way to check that
the CPU is not in thermal throttling or power-saving modes. This needs to be
tested on different hardware and OS combinations.

