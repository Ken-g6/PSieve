#
gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -I. -I.. -s -o robert62-x86-linux ../gfn_main.c ../sieve.c ../clock.c ../util.c gfn_app.c -lm -lpthread
i586-mingw32msvc-gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -I. -I.. -s -o robert62-x86-windows.exe ../gfn_main.c ../sieve.c ../clock.c ../util.c gfn_app.c -lm
#
ssh coo "(cd `pwd`; gcc -V4.2 -Wall -O3 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o robert62-x86_64-linux ../gfn_main.c ../sieve.c ../clock.c ../util.c gfn_app.c -lm -lpthread)"
ssh coo "(cd `pwd`; x86_64-pc-mingw32-gcc -Wall -O3 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o robert62-x86_64-windows.exe ../gfn_main.c ../sieve.c ../clock.c ../util.c gfn_app.c -lm)"

rm -f robert62-0.2.0.zip
zip -9 robert62-0.2.0.zip CHANGES.txt README.txt robert-config.txt robert62-x86-linux robert62-x86-windows.exe robert62-x86_64-linux robert62-x86_64-windows.exe
