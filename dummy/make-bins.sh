#
gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -I. -I.. -s -o d32 ../main.c ../sieve.c ../clock.c ../util.c app.c -lm -lpthread
gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -I. -I.. -s -o gfn_d32 ../gfn_main.c ../sieve.c ../clock.c ../util.c gfn_app.c -lm -lpthread
#
ssh coo "(cd `pwd`; gcc -V4.2 -Wall -O3 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o d64 ../main.c ../sieve.c ../clock.c ../util.c app.c -lm -lpthread)"
ssh coo "(cd `pwd`; gcc -V4.2 -Wall -O3 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o gfn_d64 ../gfn_main.c ../sieve.c ../clock.c ../util.c gfn_app.c -lm -lpthread)"
