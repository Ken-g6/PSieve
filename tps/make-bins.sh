#
gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=pentium3 -I. -I.. -s -o tpsieve-x86-linux ../main.c ../sieve.c ../clock.c ../util.c app.c -lm -lpthread
gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=core2 -msse2 -I. -I.. -s -o tpsieve-x86-linux-sse2 ../main.c ../sieve.c ../clock.c ../util.c app.c -lm -lpthread
#gcc -Wall -O2 -fomit-frame-pointer -DNDEBUG -m32 -march=i686 -s -o tp_abcd tp_abcd.c
#
#i586-mingw32msvc-gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -I. -I.. -s -o tpsieve-x86-windows.exe ../main.c ../sieve.c ../clock.c ../util.c app.c -lm
#i586-mingw32msvc-gcc -Wall -O2 -fomit-frame-pointer -DNDEBUG -m32 -march=i686 -s -o tp_abcd.exe tp_abcd.c
#
gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m64 -march=k8 -mtune=core2 -I. -I.. -s -o tpsieve-x86_64-linux ../main.c ../sieve.c ../clock.c ../util.c app.c -lm -lpthread
#
#ssh coo "(cd `pwd`; x86_64-pc-mingw32-gcc -Wall -O3 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o tpsieve-x86_64-windows.exe ../main.c ../sieve.c ../clock.c ../util.c app.c -lm)"
#
rm -f tpsieve-0.3.2-bin.zip
zip -9 tpsieve-0.3.2-bin.zip README.txt CHANGES.txt tpconfig.txt tpsieve-x86-linux tpsieve-x86-linux-sse2 tpsieve-x86_64-linux tpsieve-x86-windows.exe tpsieve-x86-windows-sse2.exe tpsieve-x86_64-windows.exe make-bins.sh make-bins.bat app.c app.h
