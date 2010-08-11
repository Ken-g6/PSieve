#
gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -I. -I.. -s -o lmsieve-x86-linux ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread
gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=k8 -msse2 -I. -I.. -s -o lmsieve-x86-linux-sse2 ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread
#
#i586-mingw32msvc-gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -I. -I.. -s -o lmsieve-x86-windows.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm
#i586-mingw32msvc-gcc -Wall -O3 -fomit-frame-pointer -DNDEBUG -D_REENTRANT -m32 -march=i686 -mtune=k8 -msse2 -I. -I.. -s -o lmsieve-x86-windows-sse2.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm
#
gcc -Wall -O3 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o lmsieve-x86_64-linux ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm -lpthread
#
#x86_64-pc-mingw32-gcc -Wall -O3 -DNDEBUG -D_REENTRANT -m64 -march=k8 -I. -I.. -s -o lmsieve-x86_64-windows.exe ../main.c ../sieve.c ../clock.c ../putil.c app.c -lm
#
rm -f lmsieve-0.2.4-bin.zip
zip -9 lmsieve-0.2.4-bin.zip README.txt CHANGES.txt lmconfig.txt lmsieve-x86-linux lmsieve-x86-linux-sse2 lmsieve-x86_64-linux lmsieve-x86-windows.exe lmsieve-x86-windows-sse2.exe lmsieve-x86_64-windows.exe
